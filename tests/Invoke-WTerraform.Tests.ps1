$outputDir       = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
$outputModDir    = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
$manifest        = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
$outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion

# Remove all versions of the module from the session. Pester can't handle multiple versions.
#Get-Module $env:BHProjectName | Remove-Module -Force
Import-Module -Name (Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1") -Verbose:$false -ErrorAction Stop
$cachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform"
$tempcachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraformTempTest"
$restore = $false

Describe "Invoke-WTerraform" {
    BeforeAll {
        if (Test-Path $cachePath) {
            Move-Item -LiteralPath $cachePath -Destination $tempcachePath
            $restore = $true
        }
    }
    AfterAll {
        if ($restore) {
            Remove-Item $cachePath -Recurse
            Move-Item -LiteralPath $tempcachePath -Destination $cachePath
        }
    }
    Context "Configured Folders" {
        BeforeAll {
            $path = "TestDrive:\1"
            New-Item -Path $path -ItemType Directory
            Push-Location -Path $path
            Set-WTerraformVersion -Version "0.14.0"
        }
        It "Should run Specified Version" {
            $actualVersion = Invoke-WTerraform -version
            $actualVersion[0] | Should -Be "Terraform v0.14.0"
        }
        It "Should work with PSDrives" {
            Push-Location -Path (Join-Path -Path $TestDrive -ChildPath 1)
            $actualVersion = Invoke-WTerraform -version
            $actualVersion[0] | Should -Be "Terraform v0.14.0"
            Pop-Location
        }
        it "Should work With alias" {
            $actualVersion = terraform -version
            $actualVersion[0] | Should -Be "Terraform v0.14.0"
        }
        AfterAll {
            Pop-Location
            Pop-Location -ErrorAction SilentlyContinue
        }
    }
}
