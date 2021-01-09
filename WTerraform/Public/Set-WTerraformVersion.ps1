<#
.SYNOPSIS
Specify the Terraform Version to use in this folder.
.DESCRIPTION
Checks if specified Version is already present. If not download from Terraform. Also saves the Version for this folder so Invoke-WTerraform will use this Version.
.PARAMETER Version
Version of Terraform to use in this folder
.EXAMPLE
Set-WTerraformVersion -Version 0.14.4
Downloads Terraform Version 0.14.0 if not present and saves the specified version for later use with Invoke-WTerraform
#>
function Set-WTerraformVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Version
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
        $cacheVersionRootPath = Join-Path -Path $cachePath -ChildPath "$terraformFullVersion"
        $cacheVersionTerraformPath = Join-Path -Path $cacheVersionRootPath -ChildPath "terraform.exe"
        $cacheVersionZipPath = Join-Path -Path $cachePath -ChildPath "$terraformFullVersion.zip"
        if (Test-Path -LiteralPath $cacheVersionTerraformPath) {
            Write-Verbose "Terraform $terraformFullVersion already present"
        } else {
            Invoke-WebRequest -Uri "$baseUri/$Version/$terraformFullVersion.zip" -OutFile $cacheVersionZipPath
            Expand-Archive -Path $cacheVersionZipPath -DestinationPath $cacheVersionRootPath
            Remove-Item -Path $cacheVersionZipPath
        }

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
