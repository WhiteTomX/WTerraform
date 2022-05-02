<#
.SYNOPSIS
Specify the Terraform Version to use in this folder.
.DESCRIPTION
Checks if specified Version is already present. If not download from Terraform. Also saves the Version for this folder so Invoke-WTerraform will use this Version.
.PARAMETER Version
Version of Terraform to use in this folder
.PARAMETER Global
Set the Version globally (in userPath) instead of local folder
.EXAMPLE
Set-WTerraformVersion -Version 0.14.4
Downloads Terraform Version 0.14.0 if not present and saves the specified version for later use with Invoke-WTerraform
#>
function Set-WTerraformVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Version,
        [switch]$Global
    )

    begin {
        $baseUri = "https://releases.hashicorp.com/terraform"
        $cachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform"
        $versionMapPath = Join-Path -Path $cachePath -ChildPath "versionmap.json"
        $currentPath = Convert-Path $pwd.Path
        if (-not (Test-Path -LiteralPath $cachePath)) {
            New-Item -Path $cachePath -ItemType Directory
        }
        $terraformFullVersion = "terraform_$($Version)_windows_amd64"
    }

    process {
        Install-WTerraform -Version $Version -OS "windows" -Architecture "amd64"
        if ($Global.IsPresent) {
            $regex = $cachePath
            $regex = [regex]::Escape($regex)
            $regex = $regex + "\\(terraform_\d+\.\d+\.\d+_\w+_\w+);?"
            $versionPath = $cachePath | Join-Path -ChildPath $terraformFullVersion
            $path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
            if ($path -match $regex) {
                Write-Warning "Set Terraform Version from $($matches[1]) to $terraformFullVersion globally"
                $path = $path -replace $regex, ""
            }
            $path = $path + ";" + $versionPath
            [System.Environment]::SetEnvironmentVariable("Path", $path, [System.EnvironmentVariableTarget]::User)
            $env:Path = [System.Environment]::SetEnvironmentVariable("Path", $path, [System.EnvironmentVariableTarget]::Machine) + ";"+  [System.Environment]::SetEnvironmentVariable("Path", $path, [System.EnvironmentVariableTarget]::User)
        } else {
            $versionMap = Get-WTerraformVersionMap
            $oldVersion = Get-WTerraformversion
            $versionChange = $false
            if ($oldVersion -eq $terraformFullVersion) {
                Write-Verbose "Terraform Version for $currentPath is already $oldVersion"
            } elseif ($oldVersion -and $oldVersion -ne $terraformFullVersion) {
                Write-Warning "Set Terraform Version from $oldVersion to $terraformFullVersion for $currentPath"
                $versionMap."$currentPath" = $terraformFullVersion
                $versionChange = $true
            } else {
                Write-Verbose "Set Terraform Version to $terraformFullVersion for $currentPath"
                Add-Member -InputObject $versionMap -MemberType NoteProperty -Name $currentPath -Value $terraformFullVersion
                $versionChange = $true
            }

            if ($true -eq $versionChange) {
                Set-Content -Value ($versionMap | ConvertTo-Json) -LiteralPath $versionMapPath
            }
        }
    }
}
