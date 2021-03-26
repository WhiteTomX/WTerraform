$Script:Path = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform"
$Script:TempPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraformTestBackup"
<#
.SYNOPSIS
Move the WTerraform Path to a Backup Location
#>
function Move-WTestTerraform {
    param (
    )
    if ((Test-Path $Script:Path) -and -not (Test-Path -Path $Script:TempPath)) {
        Move-Item -LiteralPath $Script:Path -Destination $Script:TempPath
    } elseif (Test-Path $Script:Path) {
        Throw "Can't backup, because $($Script:TempPath) already present"
    } else {
        Write-Verbose "No need to Move anything."
    }
}

<#
.SYNOPSIS
Restore folder that was moved.
#>
function Restore-WTestTerraform {
    if (Test-Path $Script:Path) {
        Remove-Item $Script:Path -Recurse -ErrorAction Stop
    }
    if ((Test-Path $Script:TempPath) -and -not (Test-Path $Script:Path)) {
        Move-Item -LiteralPath $Script:TempPath -Destination $Script:Path
    } elseif (Test-Path $Script:TempPath) {
        Throw "Could not restore: $($Script:Path) still present"
    } else {
        Write-Verbose "No Backup to restore"
    }
}

<#
.SYNOPSIS
Get Path to WTerraform Folder
#>
function Get-WTestTerraformPath {
    return $Script:Path
}
