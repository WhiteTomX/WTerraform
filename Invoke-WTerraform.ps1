<#
.SYNOPSIS
Wrapper for terraform
.DESCRIPTION
Runs terraform in version specified by Set-WTerraformVersion.
Parameters are just forwarded to terraform
#>
function Invoke-WTerraform {
    $versionMap = Get-WTerraformVersionMap
    $version = $versionMap."$($PWD.Path)"
    if ($version) {
        $path = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform" | Join-Path -ChildPath $version | Join-Path -ChildPath "terraform.exe"
        if (Test-Path -LiteralPath $path) {
            & $path $args
        } else {
            #TODO: Redownload terraform
            throw "$version is not found"
        }

    } else {
        throw "No Version for $pwd specified. Please Run Set-WTerraformVerstion."
    }
}