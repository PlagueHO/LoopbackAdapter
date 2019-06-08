
function New-LoopbackAdapter
{
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    [CmdLetBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [switch]
        $Force
    )

    $null = $PSBoundParameters.Remove('Name')

    # Check for the existing Loopback Adapter
    $adapter = Get-NetAdapter `
        -Name $Name `
        -ErrorAction SilentlyContinue

    # Is the loopback adapter installed?
    if ($adapter)
    {
        Throw ($localizedData.NetworkAdapterExistsError -f $Name)
    } # if

    # Make sure DevCon is installed.
    $devConExe = (Install-Devcon @PSBoundParameters).FullName

    <#
        Get a list of existing Loopback adapters
        This will be used to figure out which adapter was just added
    #>
    $existingAdapters = (Get-LoopbackAdapter).PnPDeviceID

    <#
        Use Devcon.exe to install the Microsoft Loopback adapter
        Requires local Admin privs.
    #>
    $null = & $DevConExe @('install', "$($ENV:SystemRoot)\inf\netloop.inf", '*MSLOOP')

    # Find the newly added Loopback Adapter
    $adapter = Get-NetAdapter |
        Where-Object -FilterScript {
            ($_.PnPDeviceID -notin $ExistingAdapters ) -and `
            ($_.DriverDescription -eq 'Microsoft KM-TEST Loopback Adapter')
        }

    if (-not $adapter)
    {
        Throw $LocalizedData.NewNetworkAdapterNotFoundError
    } # if

    # Rename the new Loopback adapter
    $adapter | Rename-NetAdapter `
        -NewName $Name `
        -ErrorAction Stop

    # Set the metric to 254
    Set-NetIPInterface `
        -InterfaceAlias $Name `
        -InterfaceMetric 254 `
        -ErrorAction Stop

    <#
        Wait till IP address binding has registered in the CIM subsystem.
        if after 30 seconds it has not been registered then throw an exception.
    #>
    [System.Boolean] $adapterBindingReady = $false
    [System.DateTime] $startTime = Get-Date

    while (-not $adapterBindingReady `
            -and (((Get-Date) - $startTime).TotalSeconds) -lt 30)
    {
        try
        {
            $ipAddress = Get-CimInstance `
                -ClassName MSFT_NetIPAddress `
                -Namespace ROOT/StandardCimv2 `
                -Filter "((InterfaceAlias = '$Name') AND (AddressFamily = 2))" `
                -ErrorAction Stop

            if ($ipAddress)
            {
                $adapterBindingReady = $true
            } # if

            Start-Sleep -Seconds 1
        }
        catch
        {
            Write-Warning -Message ($LocalizedData.GetIPAddressWarning -f $_)
        }
    } # while

    if (-not $ipAddress)
    {
        throw $LocalizedData.NewNetworkAdapterNotFoundInCIMError
    }

    # Pull the newly named adapter (to be safe)
    $adapter = Get-NetAdapter `
        -Name $Name `
        -ErrorAction Stop

    return $adapter
}
