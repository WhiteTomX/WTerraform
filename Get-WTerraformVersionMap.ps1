<#
.SYNOPSIS
Load the VersionMap of Folders to Terraform Versions
.DESCRIPTION
Returns Empty if no VersionMap Found
#>
function Get-WTerraformVersionMap {
    [CmdletBinding()]
    param (

    )

    begin {
        $versionMap = @{}
        $cachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform"
        $versionMapPath = Join-Path -Path $cachePath -ChildPath "versionmap.json"
    }

    process {
        if (Test-Path $versionMapPath) {
            $versionMap = Get-Content -LiteralPath $versionMapPath | ConvertFrom-Json
        }
    }

    end {
        return $versionMap
    }
}