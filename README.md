# WTerraform

Don*t worry about installing Terraform anymore!

## Overview

Handles the download and usage of terraform folder specific. Adds `terraform` as an alias to Invoke-WTerraform for convenient use.
Currently only supports forwarding cli style to terraform directly. Max be improved in the future.

## Installation

The Module is in the gallery so you can just install it.
Please be aware, that the PowerShell Versions before 5.1 are only tested for compatibility, not by actually running tests.

```powershell
Install-Module WTerraform
```

## Examples

As it is just an easy wrapper for now you just need to specify the Terraform version once per folder and use the `terraform`command as usual

```powershell
Install-Module WTerraform
Set-WTerraformVersion -Version "0.14.0"
Invoke-WTerraform -help
terraform -help
```

## Contributing

### Making a release

- Add the new Release version to Changelog
- Change the Version in Manifest
- Create Pull Request
- Create Release in GitHub
- Release will be published to gallery automatically by GitHub Action
