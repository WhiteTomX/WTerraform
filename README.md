# WTerraform

Don*t worry about installing Terraform anymore!

## Overview

Handles the download and usage of terraform folder specific. Adds `terraform` as an alias to Invoke-WTerraform for convenient use.
Currently only supports forwarding cli style to terraform directly. Max be improved in the future.

## Installation

The Module is in the gallery (soonish) so you can just install it.

```powershell
Install-Module WTerraform
```

## Examples

```powershell
Install-Module WTerraform
Set-WTerraformVersion -Version "0.14.0"
Invoke-WTerraform -help
terraform -help
```
