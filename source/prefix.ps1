<#
.EXTERNALHELP LoopbackAdapter-help.xml
#>

$moduleRoot = Split-Path `
    -Path $MyInvocation.MyCommand.Path `
    -Parent

#region LocalizedData
$culture = 'en-US'

if (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath $PSUICulture))
{
    $culture = $PSUICulture
}

Import-LocalizedData `
    -BindingVariable LocalizedData `
    -Filename 'LoopbackAdapter.strings.psd1' `
    -BaseDirectory $moduleRoot `
    -UICulture $culture
#endregion
