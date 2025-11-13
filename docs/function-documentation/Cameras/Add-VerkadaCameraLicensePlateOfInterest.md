---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCameraLicensePlateOfInterest.md
schema: 2.0.0
---

# Add-VerkadaCameraLicensePlateOfInterest

## SYNOPSIS
Creates a License Plate of Interest for an organization using a specified description and license plate number using https://apidocs.verkada.com/reference/postlicenseplateofinterestviewv1

## SYNTAX

```
Add-VerkadaCameraLicensePlateOfInterest [-license_plate] <String> [-description] <String>
 [-x_verkada_auth_api <String>] [-region <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a License Plate of Interest for an organization using a specified description and license plate number.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaCameraLicensePlateOfInterest -license_plate 'ABC123' -description 'New License Plate'
The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaLPoI 'ABC123' 'New License Plate'
The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 3
```
Import-CSV ./file_ofLicenses_and_Descriptions.csv | Add-VerkadaLPoI
The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 4
```
Add-VerkadaCameraLicensePlateOfInterest -license_plate 'ABC123' -description 'New License Plate' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
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

### -description
The description for the License Plate of Interest

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCameraLicensePlateOfInterest.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCameraLicensePlateOfInterest.md)

