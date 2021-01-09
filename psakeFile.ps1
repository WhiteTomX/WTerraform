properties {
    $PSBPreference.Build.CompileModule = $true
    $PSBPreference.Test.CodeCoverage.Enabled = $false
}

task default -depends Test

task Test -FromModule PowerShellBuild -Version '0.4.0'
