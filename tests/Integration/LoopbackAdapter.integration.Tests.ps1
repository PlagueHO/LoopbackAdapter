[System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
[CmdletBinding()]
param ()

$ProjectPath = "$PSScriptRoot\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName

Import-Module -Name $ProjectName -Force

Describe 'LoopbackAdapter Module' -Tag 'Integration' {
    BeforeAll {
        $script:testAdapterName = 'Test Loopback Adapter'
        Get-LoopbackAdapter |
            Where-Object -FilterScript { $_.Name -match $script:testAdapterName } |
            Remove-LoopbackAdapter -Force
    }

    AfterAll {
        Get-LoopbackAdapter |
            Where-Object -FilterScript { $_.Name -match $script:testAdapterName } |
            Remove-LoopbackAdapter -Force
    }

    Context 'When installing a Loopback Adapter' {
        It 'Should not throw an exception' {
            New-LoopbackAdapter -Name $script:testAdapterName -Force -Verbose
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
            Get-LoopbackAdapter -Name $script:testAdapterName | Remove-LoopbackAdapter -Force -Verbose
        }

        It 'Should have removed the loopback adapter' {
            Get-NetAdapter | Where-Object -FilterScript { $_.Name -eq  $script:testAdapterName } | Should -BeNullOrEmpty
        }
    }

    Context 'When installing and removing multiple adapters' {
        It 'should not throw an exception when using the same name' {
            for ($i = 0; $i -lt 3; $i++) {
                { New-LoopbackAdapter -Name $script:testAdapterName -Force | Remove-LoopbackAdapter -Force } |
                    Should -Not -Throw
            }
        }

        It 'should not throw an exception when removing several adapters at once' {
            for ($i = 0; $i -lt 3; $i++) {
                New-LoopbackAdapter -Name "$script:testAdapterName $($i + 1)" -Force
            }
            {
                Get-LoopbackAdapter |
                    Where-Object -FilterScript { $_.Name -match $script:testAdapterName } |
                    Remove-LoopbackAdapter -Force
            } | Should -Not -Throw
        }
    }
}
