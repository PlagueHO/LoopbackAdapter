[System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoIdUsingConvertToSecureStringWithPlainText', '')]
[CmdletBinding()]
param (
)

$ModuleManifestName = 'LoopbackAdapter.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\..\src\$ModuleManifestName"

Import-Module -Name $ModuleManifestPath -Force -Verbose:$false

InModuleScope LoopbackAdapter {
    Describe 'Get-LoopbackAdapter' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Get-LoopbackAdapter -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Describe 'Install-Chocolatey' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Install-Chocolatey -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Describe 'Install-Devcon' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Install-Devcon -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Describe 'New-LoopbackAdapter' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name New-LoopbackAdapter -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Describe 'Remove-LoopbackAdapter' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Remove-LoopbackAdapter -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Describe 'Uninstall-Devcon' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Uninstall-Devcon -ErrorAction Stop } | Should -Not -Throw
        }
    }
}
