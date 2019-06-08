function Remove-LoopbackAdapter
{
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
    if (-not $adapter)
    {
        # Adapter doesn't exist
        throw ($LocalizedData.LoopbackAdapterNotFound -f $Name)
    }

    # Is the adapter Loopback adapter?
    if ($adapter.DriverDescription -ne 'Microsoft KM-TEST Loopback Adapter')
    {
        # Not a loopback adapter - don't uninstall this!
        throw ($LocalizedData.NetworkAdapterWrongTypeError -f $Name)
    } # if

    # Make sure DevCon is installed.
    $devConExe = (Install-Devcon @PSBoundParameters).FullName

    <#
        Use Devcon.exe to remove the Microsoft Loopback adapter using the PnPDeviceID.
        Requires local Admin privs.
    #>
    $null = & $devConExe @('remove',"@$($adapter.PnPDeviceID)")
} # function Remove-LoopbackAdapter
