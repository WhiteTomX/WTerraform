$outputDir = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
$outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
$manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
$outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion

# Remove all versions of the module from the session. Pester can't handle multiple versions.
#Get-Module $env:BHProjectName | Remove-Module -Force
Import-Module -Name (Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1") -Verbose:$false -ErrorAction Stop
$cachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform"
$tempcachePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraformTempTest"
$restore = $false
Describe "Set-WTerraformVersion for current folder" {
    BeforeAll {
        Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Helper.psm1') -Verbose:$false -Force
        Move-WTestTerraform
        Mock -CommandName "Install-WTerraform" -ModuleName WTerraform {}
    }
    AfterAll {
        Restore-WTestTerraform
    }
    Context "Basic Run Tests" {
        BeforeAll {
            Push-Location -LiteralPath "TestDrive:\"
        }
        AfterAll {
            Pop-Location
        }

        It "Should not run without Version" {
            (Get-Command Set-WTerraformVersion).Parameters.Version.ParameterSets."__AllParameterSets".IsMandatory | Should -BeTrue
        }

        It "Should run with version specified" {
            Set-WTerraformVersion -Version 0.14.0
        }

        It "Should run with same Version again" {
            Set-WTerraformVersion -Version 0.14.0
        }

        It "Should warn about new Version" {
            Set-WTerraformVersion -Version 0.14.4 3>&1 | Should -Be "Set Terraform Version from terraform_0.14.0_windows_amd64 to terraform_0.14.4_windows_amd64 for $TestDrive\"
        }
    }
}

Describe "Set-WTerraformVersion global" {
    BeforeAll {
        Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Helper.psm1') -Verbose:$false -Force
        $backUpPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
        Move-WTestTerraform
        Mock -CommandName "Install-WTerraform" -ModuleName WTerraform {}
    }
    AfterAll {
        [System.Environment]::SetEnvironmentVariable("Path", $backUpPath, [System.EnvironmentVariableTarget]::User)
        Restore-WTestTerraform
    }
    BeforeEach {
        $regex = Get-WTestTerraformPath
        $regex = [regex]::Escape($regex)
        $regex = $regex + "[\w|\\]+;?"
        $cleanPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) -replace $regex, ""
        [System.Environment]::SetEnvironmentVariable("Path", $cleanPath, [System.EnvironmentVariableTarget]::User)
    }
    Context "No global Version set" {
        It "Should add Version Folder to Path" {
            Set-WTerraformVersion -Version "0.14.8" -Global
            $versionPath = Join-Path -Path (Get-WTestTerraformPath) -ChildPath "terraform_0.14.8_windows_amd64"
            [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) | Should -BeLike "*$($versionPath)*"
        }
    }
    Context "Global Version set" {
        BeforeAll {
            $cleanPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
            $versionPath = Join-Path -Path (Get-WTestTerraformPath) -ChildPath "terraform_0.14.0_windows_amd64"
            $newVersionPath = Join-Path -Path (Get-WTestTerraformPath) -ChildPath "terraform_0.14.8_windows_amd64"
            $newPath = $cleanPath + ";" + $versionPath
            [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::User)
            $output = Set-WTerraformVersion -Version "0.14.8" -Global 3>&1
        }
        It "Should warn about new Version" {
            $output | Should -Be "Set Terraform Version from terraform_0.14.0_windows_amd64 to terraform_0.14.8_windows_amd64 globally"
        }
        It "Should add new Version Folder to Path" {
            [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) | Should -BeLike "*$($newVersionPath)*"
        }
        It "Should remove old Version Folder from Path" {
            [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) | Should -Not -BeLike "*$($versionPath)*"
        }
    }
}
