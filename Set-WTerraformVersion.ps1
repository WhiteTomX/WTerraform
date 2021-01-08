<#
.SYNOPSIS
Specify the Terraform Version to use in this folder.
.DESCRIPTION
Checks if specified Version is already present. If not download from Terraform. Also saves the Version for this folder so Invoke-WTerraform will use this Version.
#>
function Set-WTerraformVersion {
    [CmdletBinding()]
    param (
        [String]$Version = "0.14.4"
    )

    begin {
        $baseUri = "https://releases.hashicorp.com/terraform"
        $cachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform"
        $versionMapPath = Join-Path -Path $cachePath -ChildPath "versionmap.json"
        $currentPath = $pwd.Path
        if (-not (Test-Path -LiteralPath $cachePath)) {
            New-Item -Path $cachePath -ItemType Directory
        }
        $terraformFullVersion = "terraform_$($Version)_windows_amd64"
    }

    process {
        $cacheVersionRootPath = Join-Path -Path $cachePath -ChildPath "$terraformFullVersion"
        $cacheVersionTerraformPath = Join-Path -Path $cacheVersionRootPath -ChildPath "terraform.exe"
        $cacheVersionZipPath = Join-Path -Path $cachePath -ChildPath "$terraformFullVersion.zip"
        if (Test-Path -LiteralPath $cacheVersionTerraformPath) {
            Write-Verbose "Terraform $terraformFullVersion already present"
        } else {
            Invoke-Webrequest -Uri "$baseUri/$Version/$terraformFullVersion.zip" -OutFile $cacheVersionZipPath
            Expand-Archive -Path $cacheVersionZipPath -DestinationPath $cacheVersionRootPath
            Remove-Item -Path $cacheVersionZipPath
        }

        $versionMap = Get-WTerraformVersionMap
        $oldVersion = $versionMap."$($PWD.Path)"
        if ($oldVersion) {
            Write-Warning "Set Terraform Version from $oldVersion to $terraformFullVersion for $currentPath"
        }
        Write-Verbose "Set Terraform Version to $terraformFullVersion for $currentPath"
        $versionMap[$currentPath] = $terraformFullVersion
        Set-Content -Value ($versionMap | ConvertTo-Json) -LiteralPath $versionMapPath
    }
}