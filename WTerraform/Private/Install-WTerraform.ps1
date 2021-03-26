<#
.SYNOPSIS
Downloads the specified Terraform Version if not present
.DESCRIPTION
Downloads and extracts release from hashicorp.
#>
function Install-WTerraform {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                $_ -match "^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$"
            })]
        [String]$Version,
        [Parameter(Mandatory)]
        [ValidateSet("windows")]
        [String]$OS,
        [Parameter(Mandatory)]
        [ValidateSet("amd64", "386")]
        [String]$Architecture
    )

    begin {
        $baseUri = "https://releases.hashicorp.com/terraform"
        $OS = $OS.ToLower()
        $Architecture = $Architecture.ToLower()
        if (-not (Test-Path -Path $Script:Path)) {
            New-Item -Path $script:Path -ItemType Directory
        }
    }

    process {
        $terraformFullVersion = "terraform_$($Version)_$($OS)_$($Architecture)"
        $versionPath = Join-Path -Path $Script:Path -ChildPath $terraformFullVersion
        $exePath = Join-Path -Path $versionPath -ChildPath "terraform.exe"
        if (Test-Path -LiteralPath $exePath) {
            Write-Verbose "$terraformFullVersion already present in $exePath"
        } else {
            $zipPath = Join-Path -Path $Script:Path -ChildPath "$terraformFullVersion.zip"
            Invoke-WebRequest -Uri "$baseUri/$Version/$terraformFullVersion.zip" -OutFile $zipPath
            Expand-Archive -Path $zipPath -DestinationPath $versionPath
        }
    }

    end {
        Remove-Item -Path (Join-Path -Path $Script:Path -ChildPath "*.zip")
    }
}
