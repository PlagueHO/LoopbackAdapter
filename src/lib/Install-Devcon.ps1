<#
    .SYNOPSIS
        Install the DevCon.Portable (Windows Device Console) package using Chocolatey.

    .DESCRIPTION
        Installs Chocolatey from the internet if it is not installed, then uses
        it to download the DevCon.Portable (Windows Device Console) package.
        The devcon.portable Chocolatey package can be found here and installed manually
        if no internet connection is available:
        https://chocolatey.org/packages/devcon.portable/

        Chocolatey will remain installed after this function is called.

    .PARAMETER Force
        Force the install of Chocolatey and the Devcon.portable package if not already
        installed, without confirming with the user.

    .EXAMPLE
        Install-Devcon

    .OUTPUTS
        The fileinfo object containing the appropriate DevCon*.exe application that was
        installed for this architecture.
#>
function Install-Devcon
{
    [OutputType([System.IO.FileInfo])]
    [CmdLetBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High')]
    param
    (
        [Parameter()]
        [Switch]
        $Force
    )

    Install-Chocolatey @PSBoundParameters

    # Check DevCon installed - if not, install it.
    $devConInstalled = ((Test-Path -Path "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe") `
        -and (Test-Path -Path "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe"))

    if (-not $devConInstalled)
    {
        try
        {
            <#
                This will download and install DevCon.exe
                It will also be automatically placed into the path
            #>
            if ($Force -or $PSCmdlet.ShouldProcess($LocalizedData.DownloadAndInstallDevConShould))
            {
                $null = & choco install -r -y devcon.portable
            }
            else
            {
                throw $LocalizedData.DevConNotInstalledError
            }
        }
        catch
        {
            throw ($LocalizedData.DevConInstallationError -f $_)
        }
    }

    if ([Environment]::Is64BitOperatingSystem -eq $True)
    {
        Get-ChildItem -Path "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe"
    }
    else
    {
        Get-ChildItem -Path "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe"
    }
}
