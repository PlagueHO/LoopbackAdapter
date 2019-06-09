---
external help file: LoopbackAdapter-help.xml
Module Name: LoopbackAdapter
online version:
schema: 2.0.0
---

# Get-LoopbackAdapter

## SYNOPSIS

Returns a specified Loopback Network Adapter or all Loopback Adapters.

## SYNTAX

```powershell
Get-LoopbackAdapter [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION

This function will return either the Loopback Adapter specified in the $Name parameter
or all Loopback Adapters.
It will only return adapters that use the Microsoft KM-TEST Loopback Adapter
driver.

This function does not use Chocolatey or the DevCon (Device Console) application, so does not
require administrator access.

## EXAMPLES

### EXAMPLE 1

```powershell
$Adapter = Get-LoopbackAdapter -Name 'MyNewLoopback'
```

Returns the Loopback Adapter called MyNewLoopback.
If this Loopback Adapter does not exist or does not use the
Microsoft KM-TEST Loopback Adapter driver then an exception will be thrown.

## PARAMETERS

### -Name

The name of the Loopback Adapter to return.
If not specified will return all Loopback Adapters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Returns a specific Loopback Adapter or all Loopback adapters.

## NOTES

## RELATED LINKS
