<#
    .SYNOPSIS
        Waits for changes made by DevCon.exe to complete before continuing.

    .DESCRIPTION
        Waits for the DevCon.exe process to exit and then checks whether Get-NetAdapter completes successfully.
        Get-NetAdapter will throw "Illegal operation attempted on a registry key that has been marked for
        deletion." if the changes are still processing.

    .PARAMETER DevconExeTimeout
        Time in seconds to wait for the DevCon process to complete.

    .PARAMETER RegistryUpdateTimeout
        Time in seconds to wait for the registry to finish processing changes.

    .EXAMPLE
        Wait-ForDevconUpdate

    .NOTES
        N/A
#>
function Wait-ForDevconUpdate
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.Int32]
        $DevconExeTimeout = 5,

        [Parameter()]
        [System.Int32]
        $RegistryUpdateTimeout = 5
    )

    Get-Process -Name 'DevCon' -ErrorAction SilentlyContinue | Wait-Process -Timeout $DevconExeTimeout
    $registryUpdated = $false
    $registryTimer = 0
    $waitIncrement = 0.5

    while ($registryUpdated -eq $false)
    {
        try
        {
            $null = Get-NetAdapter -ErrorAction Stop *>&1
            $registryUpdated = $true
        }
        catch [Microsoft.Management.Infrastructure.CimException]
        {
            if ($registryTimer -ge $RegistryUpdateTimeout)
            {
                throw $_
            }

            Start-Sleep -Seconds $waitIncrement
            $registryTimer += $waitIncrement
        }
    }
}
