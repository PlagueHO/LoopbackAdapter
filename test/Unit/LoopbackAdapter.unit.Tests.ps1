[System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoIdUsingConvertToSecureStringWithPlainText', '')]
[CmdletBinding()]
param (
)

$ModuleManifestName = 'LoopbackAdapter.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\..\src\$ModuleManifestName"

Import-Module -Name $ModuleManifestPath -Force -Verbose:$false

InModuleScope LoopbackAdapter {
    $script:adaptersWithNoLoopbackAdapter = {
        @(
            @{
                Name = 'NormalAdapter'
                DriverDescription = 'Not a Loopback Adapter'
            }
        )
    }

    $script:adaptersWithOneLoopbackAdapter = {
        @(
            @{
                Name = 'LoopbackAdapter'
                DriverDescription = 'Microsoft KM-TEST Loopback Adapter'
            }
        )
    }

    $script:adaptersWithTwoLoopbackAdapters = {
        @(
            @{
                Name = 'LoopbackAdapter1'
                DriverDescription = 'Microsoft KM-TEST Loopback Adapter'
            },
            @{
                Name = 'LoopbackAdapter2'
                DriverDescription = 'Microsoft KM-TEST Loopback Adapter'
            }
        )
    }

    Describe 'Get-LoopbackAdapter' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Get-LoopbackAdapter -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When called with no adapter name and no adapters exist' {
            Mock -CommandName Get-NetAdapter

            It 'Should return null' {
                Get-LoopbackAdapter | Should -BeNullOrEmpty
            }
        }

        Context 'When called with no adapter name and no Loopback Adapters exist' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithNoLoopbackAdapter

            It 'Should return null' {
                Get-LoopbackAdapter | Should -BeNullOrEmpty
            }
        }

        Context 'When called with no adapter name and one Loopback Adapter exists' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithOneLoopbackAdapter

            It 'Should return null' {
                $adapters = Get-LoopbackAdapter
                $adapters | Should -HaveCount 1
                $adapters.Name | Should -BeExactly 'LoopbackAdapter'
                $adapters.DriverDescription | Should -BeExactly 'Microsoft KM-TEST Loopback Adapter'
            }
        }

        Context 'When called with no adapter name and two Loopback Adapter exists' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithTwoLoopbackAdapters

            It 'Should return null' {
                $adapters = Get-LoopbackAdapter
                $adapters | Should -HaveCount 2
                $adapters[0].Name | Should -BeExactly 'LoopbackAdapter1'
                $adapters[0].DriverDescription | Should -BeExactly 'Microsoft KM-TEST Loopback Adapter'
                $adapters[1].Name | Should -BeExactly 'LoopbackAdapter2'
                $adapters[1].DriverDescription | Should -BeExactly 'Microsoft KM-TEST Loopback Adapter'
            }
        }

        Context 'When called with an adapter name and the adapter does not exist' {
            Mock -CommandName Get-NetAdapter -MockWith { throw 'No Adapter' }

            It 'Should throw expected exception' {
                {
                    Get-LoopbackAdapter -Name 'LoopbackAdapter'
                } | Should -Throw 'No Adapter'
            }
        }

        Context 'When called with an adapter name and the adapter does exist and is a loopback adapter' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithOneLoopbackAdapter

            It 'Should return null' {
                $adapters = Get-LoopbackAdapter -Name 'LoopbackAdapter'
                $adapters | Should -HaveCount 1
                $adapters.Name | Should -BeExactly 'LoopbackAdapter'
                $adapters.DriverDescription | Should -BeExactly 'Microsoft KM-TEST Loopback Adapter'
            }
        }

        Context 'When called with an adapter name and the adapter does exist and is not a loopback adapter' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithNoLoopbackAdapter

            It 'Should throw expected exception' {
                {
                    Get-LoopbackAdapter -Name 'LoopbackAdapter'
                } | Should -Throw ($LocalizedData.NetworkAdapterExistsWrongTypeError -f 'LoopbackAdapter')
            }
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
