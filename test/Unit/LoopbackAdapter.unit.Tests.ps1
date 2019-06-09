[System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoIdUsingConvertToSecureStringWithPlainText', '')]
[CmdletBinding()]
param (
)

$ModuleManifestName = 'LoopbackAdapter.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\..\src\$ModuleManifestName"

Import-Module -Name $ModuleManifestPath -Force -Verbose:$false

InModuleScope LoopbackAdapter {
    function devcon
    {
        param
        (
            $Args
        )
    }

    $script:adaptersWithNoLoopbackAdapter = {
        @(
            @{
                Name = 'NormalAdapter'
                DriverDescription = 'Not a Loopback Adapter'
                PnPDeviceID = 'NormalDeviceId'
            }
        )
    }

    $script:adaptersWithOneLoopbackAdapter = {
        @(
            @{
                Name = 'LoopbackAdapter'
                DriverDescription = 'Microsoft KM-TEST Loopback Adapter'
                PnPDeviceID = 'LoopbackDeviceId'
            }
        )
    }

    $script:adaptersWithTwoLoopbackAdapters = {
        @(
            @{
                Name = 'LoopbackAdapter1'
                DriverDescription = 'Microsoft KM-TEST Loopback Adapter'
                PnPDeviceID = 'LoopbackDeviceId1'
            },
            @{
                Name = 'LoopbackAdapter2'
                DriverDescription = 'Microsoft KM-TEST Loopback Adapter'
                PnPDeviceID = 'LoopbackDeviceId2'
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
                Get-LoopbackAdapter -Verbose | Should -BeNullOrEmpty
            }
        }

        Context 'When called with no adapter name and no Loopback Adapters exist' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithNoLoopbackAdapter

            It 'Should return null' {
                Get-LoopbackAdapter -Verbose | Should -BeNullOrEmpty
            }
        }

        Context 'When called with no adapter name and one Loopback Adapter exists' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithOneLoopbackAdapter

            It 'Should return expected loopback adapter' {
                $adapters = Get-LoopbackAdapter -Verbose
                $adapters | Should -HaveCount 1
                $adapters.Name | Should -BeExactly 'LoopbackAdapter'
                $adapters.DriverDescription | Should -BeExactly 'Microsoft KM-TEST Loopback Adapter'
            }
        }

        Context 'When called with no adapter name and two Loopback Adapter exists' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithTwoLoopbackAdapters

            It 'Should return two expected loopback adpaters' {
                $adapters = Get-LoopbackAdapter -Verbose
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
                    Get-LoopbackAdapter -Name 'LoopbackAdapter' -Verbose
                } | Should -Throw 'No Adapter'
            }
        }

        Context 'When called with an adapter name and the adapter does exist and is a loopback adapter' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithOneLoopbackAdapter

            It 'Should return expected loopback adapter' {
                $adapters = Get-LoopbackAdapter -Name 'LoopbackAdapter' -Verbose
                $adapters | Should -HaveCount 1
                $adapters.Name | Should -BeExactly 'LoopbackAdapter'
                $adapters.DriverDescription | Should -BeExactly 'Microsoft KM-TEST Loopback Adapter'
            }
        }

        Context 'When called with an adapter name and the adapter does exist and is not a loopback adapter' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithNoLoopbackAdapter

            It 'Should throw expected exception' {
                {
                    Get-LoopbackAdapter -Name 'LoopbackAdapter' -Verbose
                } | Should -Throw ($LocalizedData.NetworkAdapterExistsWrongTypeError -f 'LoopbackAdapter')
            }
        }
    }

    Describe 'Install-Chocolatey' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Install-Chocolatey -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When Chocolatey is already installed' {
            Mock -CommandName Test-Path -MockWith { $true }

            It 'Should not throw exception' {
                {
                    Install-Chocolatey -Force -Verbose
                } | Should -Not -Throw
            }
        }

        Context 'When Chocolatey is not installed and installs correctly' {
            Mock -CommandName Test-Path -MockWith { $false }
            Mock -CommandName Invoke-WebRequest -MockWith {
                @{ Content = '$result = "Complete"' }
            }

            It 'Should not throw exception' {
                {
                    Install-Chocolatey -Force -Verbose
                } | Should -Not -Throw
            }
        }

        Context 'When Chocolatey is not installed and an error occurs installing' {
            Mock -CommandName Test-Path -MockWith { $false }
            Mock -CommandName Invoke-WebRequest -MockWith {
                throw 'Error'
            }

            It 'Should throw expected exception' {
                {
                    Install-Chocolatey -Force -Verbose
                } | Should -Throw ($LocalizedData.ChocolateyInstallationError -f 'Error')
            }
        }
    }

    Describe 'Install-Devcon' -Tag 'Unit' {
        BeforeAll {
            Mock -CommandName Install-Chocolatey
            Mock -CommandName Get-Childitem `
                -ParameterFilter { $Path -eq "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe" } `
                -MockWith {
                    @{
                        Fullname = "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe"
                    }
                }
            Mock -CommandName Get-Childitem `
                -ParameterFilter { $Path -eq "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe" } `
                -MockWith {
                    @{
                        Fullname = "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe"
                    }
                }
        }

        It 'Should exist' {
            { Get-Command -Name Install-Devcon -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When DevCon32 and Devcon64 is installed' {
            Mock -CommandName Get-Childitem `
                -ParameterFilter { $Path -eq "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe" } `
                -MockWith {
                    @{
                        Fullname = "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe"
                    }
                }
            Mock -CommandName Get-Childitem `
                -ParameterFilter { $Path -eq "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe" } `
                -MockWith {
                    @{
                        Fullname = "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe"
                    }
                }

            It 'Should return path to Devcon' {
                {
                    $path = Install-Devcon -Force -Verbose

                    if ([Environment]::Is64BitOperatingSystem)
                    {
                        $path.Fullname | Should -Be "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe"
                    }
                    else
                    {
                        $path.Fullname | Should -Be "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe"
                    }
                } | Should -Not -Throw
            }
        }

        Context 'When DevCon32 and Devcon64 is not installed' {
            Mock -CommandName Test-Path `
                -ParameterFilter { $Path -eq "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe" } `
                -MockWith { $false }
            Mock -CommandName Test-Path `
                -ParameterFilter { $Path -eq "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe" } `
                -MockWith { $false }
            Mock -CommandName Choco

            It 'Should return path to Devcon' {
                {
                    $path = Install-Devcon -Force -Verbose

                    if ([Environment]::Is64BitOperatingSystem)
                    {
                        $path.Fullname | Should -Be "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe"
                    }
                    else
                    {
                        $path.Fullname | Should -Be "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe"
                    }
                } | Should -Not -Throw
            }

            It 'Should call choco' {
                Assert-MockCalled -CommandName choco
            }
        }

        Context 'When DevCon32 and Devcon64 is not installed and error occurs installing' {
            Mock -CommandName Test-Path `
                -ParameterFilter { $Path -eq "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon32.exe" } `
                -MockWith { $false }
            Mock -CommandName Test-Path `
                -ParameterFilter { $Path -eq "$ENV:ProgramData\Chocolatey\Lib\devcon.portable\Devcon64.exe" } `
                -MockWith { $false }
            Mock -CommandName Choco -MockWith { throw 'Choco Error' }

            It 'Should return path to Devcon' {
                {
                    Install-Devcon -Force -Verbose
                } | Should -Throw ($LocalizedData.DevConInstallationError -f 'Choco Error')
            }

            It 'Should call choco' {
                Assert-MockCalled -CommandName choco
            }
        }
    }

    Describe 'New-LoopbackAdapter' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name New-LoopbackAdapter -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When the adapter does not exist and is created successfully and the IP address is assigned' {
            $global:getNetAdapterCallCount = 0
            Mock -CommandName Get-NetAdapter `
                -ParameterFilter {
                    $Name -eq 'LoopbackAdapter'
                } `
                -MockWith {
                    $global:getNetAdapterCallCount++
                }
            Mock -CommandName Get-NetAdapter `
                -ParameterFilter {
                    $Name -eq 'LoopbackAdapter' -and `
                    $global:getNetAdapterCallCount -ge 1
                } `
                -MockWith {
                    $global:getNetAdapterCallCount++
                    'NewLoopbackAdapter'
                }
            Mock -CommandName Install-Devcon -MockWith {
                @{
                    FullName = 'devcon'
                }
            }
            Mock -CommandName devcon
            Mock -CommandName Get-LoopbackAdapter -MockWith $script:adaptersWithOneLoopbackAdapter
            Mock -CommandName Rename-NetAdapter
            Mock -CommandName Set-NetIPInterface
            Mock -CommandName Get-CimInstance -MockWith { '192.168.0.1' }
            Mock -CommandName Start-Sleep

            It 'Should not throw exception' {
                {
                    $script:loopbackAdapter = New-LoopbackAdapter -Name 'LoopbackAdapter' -Force -Verbose
                } | Should -Not -Throw
            }

            It 'Should return the loopback adapter' {
                $script:loopbackAdapter | Should -HaveCount 1
                $script:loopbackAdapter | Should -BeExactly 'NewLoopbackAdapter'
            }
        }

        Context 'When the adapter exists' {
            Mock -CommandName Get-NetAdapter `
                -ParameterFilter {
                    $Name -eq 'LoopbackAdapter'
                } `
                -MockWith $script:adaptersWithOneLoopbackAdapter

            It 'Should throw expected exception' {
                {
                    $script:loopbackAdapter = New-LoopbackAdapter -Name 'LoopbackAdapter' -Force -Verbose
                } | Should -Throw ($LocalizedData.NetworkAdapterExistsError -f 'LoopbackAdapter')
            }
        }

        Context 'When the adapter does not exist but does not appear after being created' {
            $global:getNetAdapterCallCount = 0
            Mock -CommandName Get-NetAdapter `
                -ParameterFilter {
                    $Name -eq 'LoopbackAdapter'
                }
            Mock -CommandName Get-NetAdapter
            Mock -CommandName Install-Devcon -MockWith {
                @{
                    FullName = 'devcon'
                }
            }
            Mock -CommandName devcon
            Mock -CommandName Get-LoopbackAdapter -MockWith $script:adaptersWithOneLoopbackAdapter

            It 'Should throw expected exception' {
                {
                    $script:loopbackAdapter = New-LoopbackAdapter -Name 'LoopbackAdapter' -Force -Verbose
                } | Should -Throw ($LocalizedData.NewNetworkAdapterNotFoundError -f 'LoopbackAdapter')
            }
        }
    }

    Describe 'Remove-LoopbackAdapter' -Tag 'Unit' {
        It 'Should exist' {
            { Get-Command -Name Remove-LoopbackAdapter -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When called with an adapter name and the adapter does not exist' {
            Mock -CommandName Get-NetAdapter

            It 'Should throw expected exception' {
                {
                    Remove-LoopbackAdapter -Name 'LoopbackAdapter' -Force -Verbose
                } | Should -Throw ($LocalizedData.LoopbackAdapterNotFound -f 'LoopbackAdapter')
            }
        }

        Context 'When called with an adapter name and the adapter does exist and is a loopback adapter' {
            Mock -CommandName Get-NetAdapter `
                -MockWith @script:adaptersWithOneLoopbackAdapter `
                -ParameterFilter {
                    $Name -eq 'LoopbackAdapter'
                }
            Mock -CommandName Get-NetAdapter `
                -MockWith @script:adaptersWithOneLoopbackAdapter `
                -ParameterFilter {
                    $Name -eq 'LoopbackAdapter'
                }
            Mock -CommandName Install-Devcon -MockWith {
                @{
                    FullName = 'devcon'
                }
            }
            Mock -CommandName devcon

            It 'Should not throw exception' {
                {
                    Remove-LoopbackAdapter -Name 'LoopbackAdapter' -Force -Verbose
                } | Should -Not -Throw
            }
        }

        Context 'When called with an adapter name and the adapter does exist but is not a loopback adapter' {
            Mock -CommandName Get-NetAdapter -MockWith @script:adaptersWithNoLoopbackAdapter

            It 'Should throw expected exception' {
                {
                    Remove-LoopbackAdapter -Name 'NormalAdapter' -Force -Verbose
                } | Should -Throw ($LocalizedData.NetworkAdapterWrongTypeError -f 'NormalAdapter')
            }
        }
    }

    Describe 'Uninstall-Devcon' -Tag 'Unit' {
        BeforeAll {
            Mock -CommandName Install-Chocolatey
            Mock -CommandName Choco
        }

        It 'Should exist' {
            { Get-Command -Name Uninstall-Devcon -ErrorAction Stop } | Should -Not -Throw
        }

        Context 'When no exception occurs calling Chocolatey' {
            Mock -CommandName Choco

            It 'Should not throw exception' {
                {
                    Uninstall-Devcon -Force -Verbose
                } | Should -Not -Throw
            }

            It 'Should call choco' {
                Assert-MockCalled -CommandName Choco
            }
        }

        Context 'When an exception occurs calling Chocolatey' {
            Mock -CommandName Choco -MockWith { throw 'Choco Error' }

            It 'Should throw expected exception' {
                {
                    Uninstall-Devcon -Force -Verbose
                } | Should -Throw ($LocalizedData.DevConNotUninstallationError -f 'Choco Error')
            }

            It 'Should call choco' {
                Assert-MockCalled -CommandName Choco
            }
        }
    }
}
