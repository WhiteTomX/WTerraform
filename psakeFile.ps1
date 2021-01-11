properties {
    $PSBPreference.Build.CompileModule = $true
    $PSBPreference.Test.CodeCoverage.Enabled = $false
    $PSBPreference.Test.ScriptAnalysis.FailBuildOnSeverityLevel = "Warning"
    $PSBPreference.Test.OutputFile = "report.xml"
    $PSBPreference.Test.ScriptAnalysis.SettingsPath = "./tests/ScriptAnalyzerSettings.psd1"
}

task default -depends Test

task Test -FromModule PowerShellBuild -Version '0.4.0'

Task PublishAndZip -Depends Publish {
    Compress-Archive -LiteralPath (Join-Path -Path $PSBPreference.Build.ModuleOutDir -ChildPath "*") -DestinationPath (Join-Path -Path $PSBPreference.Build.OutDir -ChildPath "WTerraform.zip")
}
