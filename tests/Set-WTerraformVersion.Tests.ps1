$outputDir = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
$outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
$manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
$outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion

# Remove all versions of the module from the session. Pester can't handle multiple versions.
#Get-Module $env:BHProjectName | Remove-Module -Force
Import-Module -Name (Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1") -Verbose:$false -ErrorAction Stop
$cachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform"
$tempcachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraformTempTest"

Describe "Set-WTerraformVersion" {
    BeforeAll {
        Move-Item -LiteralPath $cachePath -Destination $tempcachePath
    }
    AfterAll {
        Remove-Item $cachePath -Recurse
        Move-Item -LiteralPath $tempcachePath -Destination $cachePath
    }
    Context "Basic Run Tests" {
        BeforeAll {
            Push-Location -LiteralPath "TestDrive:\"
        }
        AfterAll {
            Pop-Location
        }

        It "Should not run without Version" {
            {Set-WTerraformVersion} | Should -Throw
        }

        It "Should run with version specified" {
            Set-WTerraformVersion -Version 0.14.0
        }

        It "Should run with same Version again" {
            Set-WTerraformVersion -Version 0.14.0
        }

        It "Should warn about new Version" {
            Set-WTerraformVersion -Version 0.14.4 3>1 | Should -Be "123"
        }
    }
}
