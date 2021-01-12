$outputDir = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
$outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
$manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
$outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion

Import-Module -Name (Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1") -Verbose:$false -ErrorAction Stop

InModuleScope -ModuleName WTerraform {
    Describe "Install-WTerraform" {
        BeforeAll {
            Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Helper.psm1') -Verbose:$false -Force
            Move-WTestTerraform
            $testCases = @(
                @{Version = "0.14.2"; OS = "windows"; Architecture = "amd64" }
                @{Version = "0.14.3"; OS = "windows"; Architecture = "386" }
                @{Version = "0.14.4"; OS = "WinDows"; Architecture = "aMd64" }
            )
        }
        AfterAll {
            Restore-WTestTerraform
        }
        Context "WTerraform folder not present" {
            BeforeAll {
                if (Test-Path -Path (Get-WTestTerraformPath)) {
                    Remove-Item -Path (Get-WTestTerraformPath) -Recurse
                }
            }
            It "should create it" {
                Install-WTerraform -Version $testCases[0]["Version"] -OS $testCases[0]["OS"] -Architecture $testCases[0]["Architecture"]
                Get-WTestTerraformPath | Should -Exist
            }
            It "Should save new terraform.exe from <Version> <OS> <Architecture>" -TestCases $testCases {
                param($Version, $OS, $Architecture)
                Install-WTerraform -Version $Version -OS $OS -Architecture $Architecture
                Join-Path -Path (Get-WTestTerraformPath) -ChildPath "terraform_$($Version)_$($OS)_$($Architecture)" | Join-Path -ChildPath "terraform.exe" | Should -Exist
            }

            It "Should Not download Again <Version> <OS> <Architecture>" -TestCases $testCases {
                param($Version, $OS, $Architecture)
                Mock Invoke-WebRequest {}
                Mock Expand-Archive {}
                Install-WTerraform -Version $Version -OS $OS -Architecture $Architecture
                Assert-MockCalled Invoke-WebRequest -Exactly 0
                Assert-MockCalled Expand-Archive -Exactly 0
            }

            It "Should Remove Zip Files" {
                Test-Path -Path "*.zip" | Should -BeFalse
            }
        }
        Context "WTerraform folder present" {
            BeforeAll {
                if (-not (Test-Path (Get-WTestTerraformPath))) {
                    New-Item -Path (Get-WTestTerraformPath) -ItemType Directory
                }
            }
            It "should run without error" {
                Install-WTerraform -Version $testCases[0].Version -OS $testCases[0].OS -Architecture $testCases[0].Architecture
            }
        }
    }
}
