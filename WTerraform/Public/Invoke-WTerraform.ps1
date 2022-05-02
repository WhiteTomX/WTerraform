<#
.SYNOPSIS
Wrapper for terraform
.DESCRIPTION
Runs terraform in version specified by Set-WTerraformVersion.
Parameters are just forwarded to terraform
.Example
Invoke-WTerraform -version
Throws error if no Terraform Version was specified earlier. Otherwise runs command 'terraform -version'
#>
function Invoke-WTerraform {
    $pwdVersion = Get-WTerraformVersion
    $wTerraformPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform"
    if ($pwdVersion) {
        $path =  Join-Path -Path $wTerraformPath -ChildPath $pwdVersion | Join-Path -ChildPath "terraform.exe"
    } elseif ($terraformCommand = Get-Command -Name "terraform.exe" -CommandType Application -ErrorAction SilentlyContinue) {
        $path = $terraformCommand.Source
        if (-not $path.StartsWith($wTerraformPath)) {
            Write-Warning -Message "Using terraform in $path. This is not installed by WTerraform!"
        }
    } else {
        throw "No Version for $pwd specified. Please Run Set-WTerraformVersion."
    }
    if (Test-Path -LiteralPath $path) {
        & $path $args
    } else {
        #TODO: Redownload terraform
        throw "$pwdVersion is not found"
    }
}
