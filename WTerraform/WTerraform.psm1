$Script:Path = Join-Path -Path $env:LOCALAPPDATA -ChildPath "WTerraform"

New-Alias -Name terraform -Value Invoke-WTerraform
