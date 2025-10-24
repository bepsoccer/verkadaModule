---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaCameraLicensePlateOfInterest.md
schema: 2.0.0
---

# Remove-VerkadaCameraLicensePlateOfInterest

## SYNOPSIS
This removes a license plate from being an LPoI using https://apidocs.verkada.com/reference/deletelicenseplateofinterestviewv1

## SYNTAX

```
Remove-VerkadaCameraLicensePlateOfInterest [-license_plate] <String> [-x_verkada_auth_api <String>]
 [-region <String>] [-errorsToFile] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Deletes a license plate from License Plates of Interest using a specified license plate number.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Remove-VerkadaCameraLicensePlateOfInterest -license_plate 'ABC123'
The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Remove-VerkadaLPoI 'ABC123'
The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 3
```
Import-CSV ./file_ofLicenses.csv | Remove-VerkadaLPoI
The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 4
```
Remove-VerkadaCameraLicensePlateOfInterest -license_plate 'ABC123' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
The token is submitted as a parameter in the call.
```

## PARAMETERS

### -license_plate
The license plate number of the License Plate of Interest

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -x_verkada_auth_api
The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Global:verkadaConnection.x_verkada_auth_api
Accept pipeline input: False
Accept wildcard characters: False
```

### -region
The region of the public API to be used

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Api
Accept pipeline input: False
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaCameraLicensePlateOfInterest.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaCameraLicensePlateOfInterest.md)

