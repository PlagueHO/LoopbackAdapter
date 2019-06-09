---
external help file: LoopbackAdapter-help.xml
Module Name: LoopbackAdapter
online version:
schema: 2.0.0
---

# Remove-LoopbackAdapter

## SYNOPSIS

Uninstall an existing Loopback Network Adapter.

## SYNTAX

```powershell
Remove-LoopbackAdapter [-Name] <String> [-Force] [<CommonParameters>]
```

## DESCRIPTION

Uses Chocolatey to download the DevCon (Windows Device Console) package and
uses it to uninstall a new Loopback Network Adapter with the name specified.

## EXAMPLES

### EXAMPLE 1

```powershell
Remove-LoopbackAdapter -Name 'MyNewLoopback'
```

Removes an existing Loopback Adapter called MyNewLoopback.

## PARAMETERS

### -Name

The name of the Loopback Adapter to uninstall.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Force the install of Chocolatey and the Devcon.portable package if not already installed, without confirming with the user.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None

## NOTES

## RELATED LINKS
