---
external help file: WTerraform-help.xml
Module Name: WTerraform
online version:
schema: 2.0.0
---

# Invoke-WTerraform

## SYNOPSIS
Wrapper for terraform

## SYNTAX

```
Invoke-WTerraform [<CommonParameters>]
```

## DESCRIPTION
Runs terraform in version specified by Set-WTerraformVersion.
Parameters are just forwarded to terraform

## EXAMPLES

### EXAMPLE 1
```
Invoke-WTerraform -version
```

Throws error if no Terraform Version was specified earlier.
Otherwise runs command 'terraform -version'

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
