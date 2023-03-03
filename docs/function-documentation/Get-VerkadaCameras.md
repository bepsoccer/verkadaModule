---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version:
schema: 2.0.0
---

# Get-VerkadaCameras

## SYNOPSIS
Gets all cameras in an organization

## SYNTAX

```
Get-VerkadaCameras [[-org_id] <String>] [[-x_api_key] <String>] [[-serial] <String>] [-refresh]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -org_id
{{ Fill org_id Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Global:verkadaConnection.org_id
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -x_api_key
{{ Fill x_api_key Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Global:verkadaConnection.token
Accept pipeline input: False
Accept wildcard characters: False
```

### -serial
{{ Fill serial Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -refresh
{{ Fill refresh Description }}

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

## NOTES

## RELATED LINKS
