[System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
[CmdletBinding()]
param (
)

$moduleManifestName = 'LoopbackAdapter.psd1'
$moduleRootPath = "$PSScriptRoot\..\..\src\"
$moduleManifestPath = Join-Path -Path $moduleRootPath -ChildPath $moduleManifestName

Describe 'LoopbackAdapter Module'{
    Context 'PSScriptAnalyzer' {
        Import-Module -Name 'PSScriptAnalyzer'

        $modulePath = Join-Path -Path $moduleRootPath -ChildPath 'LoopbackAdapter.psm1'

        # Perform PSScriptAnalyzer scan
        $PSScriptAnalyzerResult = Invoke-ScriptAnalyzer `
            -Path $modulePath `
            -Settings (Join-Path -Path $moduleRootPath -ChildPath '..\PSScriptAnalyzerSettings.psd1') `
            -ErrorAction SilentlyContinue `
            -Verbose:$false
        $PSScriptAnalyzerResult += Invoke-ScriptAnalyzer `
            -Path (Join-Path -Path $moduleRootPath -ChildPath 'lib') `
            -Recurse `
            -Settings (Join-Path -Path $moduleRootPath -ChildPath '..\PSScriptAnalyzerSettings.psd1') `
            -ErrorAction SilentlyContinue `
            -Verbose:$false

        $PSScriptAnalyzerErrors = $PSScriptAnalyzerResult | Where-Object {
            $_.Severity -eq 'Error'
        }

        It 'Should have no Error level PowerShell Script Analyzer violations' {
            if ($PSScriptAnalyzerErrors -ne $null)
            {
                Write-Warning -Message 'There are Error level PowerShell Script Analyzer violations that must be fixed:'

                foreach ($violation in $PSScriptAnalyzerErrors)
                {
                    Write-Warning -Message "$($violation.Scriptname) (Line $($violation.Line)): $($violation.Message)"
                }

                Write-Warning -Message  'For instructions on how to run PSScriptAnalyzer on your own machine, please go to https://github.com/powershell/psscriptAnalyzer/'

                $PSScriptAnalyzerErrors.Count | Should -Be $null
            }
        }

        It 'Should have no Warning level PowerShell Script Analyzer violations' {
            $PSScriptAnalyzerWarnings = $PSScriptAnalyzerResult | Where-Object {
                $_.Severity -eq 'Warning'
            }

            if ($PSScriptAnalyzerWarnings -ne $null)
            {
                Write-Warning -Message 'There are Warning level PowerShell Script Analyzer violations that should be fixed:'

                foreach ($violation in $PSScriptAnalyzerWarnings)
                {
                    Write-Warning -Message "$($violation.Scriptname) (Line $($violation.Line)): $($violation.Message)"
                }

                Write-Warning -Message  'For instructions on how to run PSScriptAnalyzer on your own machine, please go to https://github.com/powershell/psscriptAnalyzer/'
            }
        }

        It 'Should have no Information level PowerShell Script Analyzer violations' {
            $PSScriptAnalyzerInformation = $PSScriptAnalyzerResult | Where-Object {
                $_.Severity -eq 'Information'
            }

            if ($PSScriptAnalyzerInformation -ne $null)
            {
                Write-Warning -Message 'There are Information level PowerShell Script Analyzer violations that must be fixed:'

                foreach ($violation in $PSScriptAnalyzerInformation)
                {
                    Write-Warning -Message "$($violation.Scriptname) (Line $($violation.Line)): $($violation.Message)"
                }

                Write-Warning -Message  'For instructions on how to run PSScriptAnalyzer on your own machine, please go to https://github.com/powershell/psscriptAnalyzer/'

                $PSScriptAnalyzerErrors.Count | Should -Be $null
            }
        }
    }

    Context 'Manifest' {
        $moduleManifestPath = Join-Path -Path $moduleRootPath -ChildPath 'LoopbackAdapter.psd1'

        It 'Should have a valid manifest' {
            $script:moduleManifest = Test-ModuleManifest -Path $moduleManifestPath
            $script:moduleManifest | Should -Not -BeNullOrEmpty
        }

        It 'Should have less than 10000 characters in the release notes of the module manifest' {
            $script:moduleManifest.ReleaseNotes.Length | Should -BeLessThan 10000
        }
    }
}
