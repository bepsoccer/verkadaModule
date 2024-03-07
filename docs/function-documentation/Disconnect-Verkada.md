---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Disconnect-Verkada.md
schema: 2.0.0
---

# Disconnect-Verkada

## SYNOPSIS
Removes cached credentials for Verkada's API Enpoints

## SYNTAX

```
Disconnect-Verkada [[-org_id] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to removed stored org_id, tokens, and cached data from the session.

## EXAMPLES

### EXAMPLE 1
```
Disconnect-Verkada
```

## PARAMETERS

### -org_id
The UUID of the organization the user belongs to(not implemented)

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Disconnect-Verkada.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Disconnect-Verkada.md)

