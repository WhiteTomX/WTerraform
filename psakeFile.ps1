properties {
    $PSBPreference.Build.CompileModule = $true
    $PSBPreference.Test.CodeCoverage.Enabled = $false
    $PSBPreference.Test.ScriptAnalysis.FailBuildOnSeverityLevel = "Warning"
    $PSBPreference.Test.OutputFile = "report.xml"
    $PSBPreference.Test.ScriptAnalysis.SettingsPath = "./tests/ScriptAnalyzerSettings.psd1"
}

task default -depends Test

task Test -FromModule PowerShellBuild -Version '0.4.0'
