[System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
[System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
[CmdletBinding()]
param (
)

$ModuleManifestName = 'LoopbackAdapter.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\..\src\$ModuleManifestName"

Import-Module -Name $ModuleManifestPath -Force -Verbose:$false

Describe 'LoopbackAdapter Module' -Tag 'Integration' {
    BeforeAll {
        $script:testAdapterName = 'Test Loopback Adapter'
    }

    Context 'When installing a Loopback Adapter' {
        It 'Should not throw an exception' {
            New-LoopbackAdapter -Name $script:testAdapterName -Verbose
        }
    }

    Context 'When getting an existing Loopback Adapter' {
        It 'Should not throw an exception' {
            $script:adapter = Get-LoopbackAdapter -Name $script:testAdapterName -Verbose
        }

        It 'Should return the expected adapter' {
            $script:adapter.Name | Should -BeExactly $script:testAdapterName
            $script:adapter.DriverDescription | Should -BeExactly 'Microsoft KM-TEST Loopback Adapter'
        }
    }

    Context 'When removing a Loopback Adapter' {
        It 'Should not throw an exception' {
            Remove-LoopbackAdapter -Name $script:testAdapterName -Verbose
        }

        It 'Should have removed the loopback adapter' {
            Get-NetAdapter | Where-Object -FilterScript { $_.Name -eq  $script:testAdapterName } | Should -BeNullOrEmpty
        }
    }
}
