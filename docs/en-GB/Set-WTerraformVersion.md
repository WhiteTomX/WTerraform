---
external help file: WTerraform-help.xml
Module Name: WTerraform
online version:
schema: 2.0.0
---

# Set-WTerraformVersion

## SYNOPSIS
Specify the Terraform Version to use in this folder.

## SYNTAX

```
Set-WTerraformVersion [-Version] <String> [<CommonParameters>]
```

## DESCRIPTION
Checks if specified Version is already present.
If not download from Terraform.
Also saves the Version for this folder so Invoke-WTerraform will use this Version.

## EXAMPLES

### EXAMPLE 1
```
Set-WTerraformVersion -Version 0.14.4
```

Downloads Terraform Version 0.14.0 if not present and saves the specified version for later use with Invoke-WTerraform

## PARAMETERS

### -Version
Version of Terraform to use in this folder

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0.14.4
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
