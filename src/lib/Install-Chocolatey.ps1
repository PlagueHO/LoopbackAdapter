<#
    .SYNOPSIS
        Install Chocolatey.

    .DESCRIPTION
        Installs Chocolatey from the internet if it is not installed.

    .PARAMETER Force
        Force the install of Chocolatey, without confirming with the user.

    .EXAMPLE
        Install-Chocolatey

    .OUTPUTS
        None
#>
function Install-Chocolatey
{
    [CmdLetBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High')]
    param
    (
        [Parameter()]
        [Switch]
        $Force
    )

    # Check chocolatey is installed - if not, install it
    $chocolateyInstalled = Test-Path -Path (Join-Path -Path $ENV:ProgramData -ChildPath 'Chocolatey\Choco.exe')

    if (-not $chocolateyInstalled)
    {
        if ($Force -or $PSCmdlet.ShouldProcess($LocalizedData.DownloadAndInstallChocolateyShould))
        {
            Write-Verbose -Message $LocalizedData.InstallingChocolateyMessage
            try
            {
                $chocolateyInstallScript = (Invoke-WebRequest -UseBasicParsing -Uri 'https://chocolatey.org/install.ps1').Content
                $chocolateyInstallScript = [scriptblock]::Create($chocolateyInstallScript)
                $null = $chocolateyInstallScript.Invoke()
            }
            catch
            {
                throw ($LocalizedData.ChocolateyInstallationError -f $_)
            }
        }
        else
        {
            throw $LocalizedData.NetworkAdapterExistsWrongTypeError
        }
    }
    else
    {
        Write-Verbose -Message $LocalizedData.ChocolateyInstalledMessage
    }
}
