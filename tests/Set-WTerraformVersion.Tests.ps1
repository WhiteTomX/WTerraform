$outputDir       = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
$outputModDir    = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
$manifest        = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
$outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion

# Remove all versions of the module from the session. Pester can't handle multiple versions.
#Get-Module $env:BHProjectName | Remove-Module -Force
Import-Module -Name (Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1") -Verbose:$false -ErrorAction Stop


Describe "Set-WTerraformVersion" {
    Context "ContextName" {

    }
}
