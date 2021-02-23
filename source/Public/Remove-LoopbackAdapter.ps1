function Remove-LoopbackAdapter
{
    [CmdLetBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [switch]
        $Force
    )

    process {
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

        # Make sure DevCon is installed and return path to executable
        $devConExe = (Install-Devcon @PSBoundParameters).FullName

        <#
            Use Devcon.exe to remove the Microsoft Loopback adapter using the PnPDeviceID.
            Requires local Admin privs.
        #>
        Write-Verbose -Message ($LocalizedData.RemovingLoopbackAdapterMessage -f $Name)
        $null = & $devConExe @('remove',"@$($adapter.PnPDeviceID)")

        <#
            Don't continue until:
            1. DevCon.exe has finished, and
            2. The registry entry for the adapter has been updated (Get-NetAdapter throws if
               used before that operation is done).
        #>
        Get-Process -Name 'DevCon' -ErrorAction SilentlyContinue | Wait-Process -Timeout 5
        $registryUpdated = $false
        while (-not $registryUpdated) {
            try {
                $adapterToRemove = Get-NetAdapter -Name '*' -ErrorAction Stop |
                    Where-Object -FilterScript { $_.PnPDeviceID -contains $adapter.PnPDeviceID }
                if ($null -eq $adapterToRemove) {
                    $registryUpdated = $true
                }
            }
            catch {
                Start-Sleep -Milliseconds 500
            }
        }
    }
} # function Remove-LoopbackAdapter
