---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Find-VerkadaUserId.md
schema: 2.0.0
---

# Get-AddressCheck

## SYNOPSIS
Used to verify an address with Google Maps API and retrieve lat/lon

## SYNTAX

```
Get-AddressCheck [-address] <String> [-key <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Private function to verify an address with Google Maps API and retrieve lat/lon

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -address
The url for the enpoint to be used

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

### -key
Google Maps API Key

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: AIzaSyBOqayI1MPP1zWM_MiP-Hjq3gR9144jqvM
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
