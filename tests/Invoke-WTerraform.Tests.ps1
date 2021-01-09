$outputDir       = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
$outputModDir    = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
$manifest        = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
$outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion

# Remove all versions of the module from the session. Pester can't handle multiple versions.
#Get-Module $env:BHProjectName | Remove-Module -Force
Import-Module -Name (Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1") -Verbose:$false -ErrorAction Stop
$cachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform"
$tempcachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraformTempTest"

Describe "Invoke-WTerraform" {
    BeforeAll {
        Move-Item -LiteralPath $cachePath -Destination $tempcachePath
    }
    AfterEach {
        $path = Get-Location
        Pop-Location
        Remove-Item $path -Recurse
    }
    Context "Configured Folders" {

        It "Should run Specified Version" {
            $path = "TestDrive:\1"
            New-Item -Path $path -ItemType Directory
            Push-Location -Path $path
            Set-WTerraformVersion -Version "0.14.0"
            $actualVersion = Invoke-WTerraform -version
            $actualVersion[0] | Should -Be "Terraform v0.14.0"
        }
    }
    AfterAll {
        Remove-Item $cachePath -Recurse
        Move-Item -LiteralPath $tempcachePath -Destination $cachePath
    }
}
