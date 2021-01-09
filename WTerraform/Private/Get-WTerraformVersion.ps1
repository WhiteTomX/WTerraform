<#
.SYNOPSIS
Get the TerraformVersion saved for current Location
.DESCRIPTION
Convert the crrent Path to ProviderPath and look up the version.
#>
function Get-WTerraformVersion {
    [CmdletBinding()]
    param ()

    begin {
        $currentPath = Convert-Path -Path $PWD
    }

    process {
        $versionMap = Get-WTerraformVersionMap
        return $versionMap."$currentPath"
    }
}
