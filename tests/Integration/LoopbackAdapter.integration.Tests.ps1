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
            Remove-LoopbackAdapter -Name $script:testAdapterName -Force -Verbose
        }

        It 'Should have removed the loopback adapter' {
            Get-NetAdapter | Where-Object -FilterScript { $_.Name -eq  $script:testAdapterName } | Should -BeNullOrEmpty
        }

        It 'Should take pipeline input from Get-LoopbackAdapter' {
            New-LoopbackAdapter -Name $script:testAdapterName -Force
            Get-LoopbackAdapter -Name $script:testAdapterName | Remove-LoopbackAdapter -Force -Verbose
        }
    }
}
