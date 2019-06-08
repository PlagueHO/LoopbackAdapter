<#
    .SYNOPSIS
        Install the DevCon.Portable (Windows Device Console) package using Chocolatey.

    .DESCRIPTION
        Installs Chocolatey from the internet if it is not installed, then uses
        it to uninstall the DevCon.Portable (Windows Device Console) package.

        Chocolatey will remain installed after this function is called.

    .PARAMETER Force
        Force the uninstall of the devcon.portable package if it is installed, without confirming with the user.

    .EXAMPLE
        Uninstall-Devcon

    .OUTPUTS
        None.
#>
function Uninstall-Devcon
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

    Install-Chocolatey @PSBoundParameters

    try
    {
        <#
            This will download and install DevCon.exe
            It will also be automatically placed into the path
        #>
        if ($Force -or $PSCmdlet.ShouldProcess($LocalizedData.UninstallDevConShould))
        {
            $null = & choco uninstall -r -y devcon.portable
        }
        else
        {
            Throw $LocalizedData.DevConNotUninstalledError
        }
    }
    catch
    {
        Throw $LocalizedData.DevConNotUninstallationError
    }
}
