---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaLicensePlatesOfInterest.md
schema: 2.0.0
---

# Get-VerkadaLicensePlatesOfInterest

## SYNOPSIS
Returns creation time, description, and license plate number for all License Plates of Interest for an organization.

## SYNTAX

```
Get-VerkadaLicensePlatesOfInterest [[-x_verkada_auth_api] <String>] [-errorsToFile]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function uses the public api endpoint(https://api.verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest) to returns creation time, description, and license plate number for all License Plates of Interest for an organization.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaLicensePlatesOfInterest
The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaLPoI
The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 3
```
Get-VerkadaLicensePlatesOfInterest -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
The token is submitted as a parameter in the call.
```

## PARAMETERS

### -x_verkada_auth_api
The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Global:verkadaConnection.x_verkada_auth_api
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -errorsToFile
Switch to write errors to file

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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaLicensePlatesOfInterest.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaLicensePlatesOfInterest.md)

