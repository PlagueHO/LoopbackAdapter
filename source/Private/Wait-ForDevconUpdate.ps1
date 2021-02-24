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
        [int]$DevconExeTimeout = 5,
        [int]$RegistryUpdateTimeout = 5
    )

    Get-Process -Name 'DevCon' -ErrorAction SilentlyContinue | Wait-Process -Timeout $DevconExeTimeout
    $registryUpdated = $false
    $registryTimer = 0
    $waitIncrement = 500
    while ($registryUpdated -eq $false)
    {
        try
        {
            Get-NetAdapter -ErrorAction Stop *>&1 | Out-Null
            $registryUpdated = $true
        }
        catch [Microsoft.Management.Infrastructure.CimException]
        {
            if ($registryTimer -ge $RegistryUpdateTimeout * 1000)
            {
                throw $_
            }
            Start-Sleep -Milliseconds $waitIncrement
            $registryTimer += $waitIncrement
        }
    }
}
