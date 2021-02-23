
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
        throw ($localizedData.NetworkAdapterExistsError -f $Name)
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
    Write-Verbose -Message ($LocalizedData.CreatingLoopbackAdapterMessage -f $Name)
    $null = & $DevConExe @('install', "$($ENV:SystemRoot)\inf\netloop.inf", '*MSLOOP')

    <#
        Don't continue until:
        1. DevCon.exe has finished, and
        2. The registry entry for the adapter has been updated (Get-NetAdapter throws if
            used before that operation is done).
    #>
    Get-Process -Name 'DevCon' -ErrorAction SilentlyContinue | Wait-Process -Timeout 5
    $adapters = @()
    while (-not $adapters) {
        try {
            $adapters = Get-NetAdapter -Name '*' -ErrorAction Stop
        }
        catch {
            Start-Sleep -Milliseconds 500
        }
    }

    # Find the newly added Loopback Adapter
    $adapter = $adapters |
        Where-Object -FilterScript {
            ($_.PnPDeviceID -notin $ExistingAdapters ) -and `
            ($_.DriverDescription -eq 'Microsoft KM-TEST Loopback Adapter')
        }

    if (-not $adapter)
    {
        throw ($LocalizedData.NewNetworkAdapterNotFoundError -f $Name)
    } # if

    # Rename the new Loopback adapter
    Write-Verbose -Message ($LocalizedData.SettingNameOfNewLoopbackAdapterMessage -f $Name)
    $null = Rename-NetAdapter `
        -Name $adapter.Name `
        -NewName $Name `
        -ErrorAction Stop

    # Set the metric to 254
    Write-Verbose -Message ($LocalizedData.SettingMetricOfNewLoopbackAdapterMessage -f $Name)
    $null = Set-NetIPInterface `
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

            Write-Verbose -Message ($LocalizedData.WaitingForIPAddressMessage -f $Name)
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
