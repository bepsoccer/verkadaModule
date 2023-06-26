---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaLicensePlateOfInterest.md
schema: 2.0.0
---

# Set-VerkadaLicensePlateOfInterest

## SYNOPSIS
Updates a License Plate of Interest for an organization using a specified description and license plate number.

## SYNTAX

```
Set-VerkadaLicensePlateOfInterest [-org_id <String>] [-license_plate] <String> [-description] <String>
 [-x_api_key <String>] [<CommonParameters>]
```

## DESCRIPTION
This function uses the public api endpoint(https://api.verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest) to update a License Plate of Interest to the specified organization.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaLicensePlateOfInterest -license_plate 'ABC123' -description 'New License Plate Descriptionv2'
The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaLPoI 'ABC123' 'New License Plate Descriptionv2'
The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 3
```
Import-CSV ./file_ofLicenses_and_Descriptions.csv | Set-VerkadaLPoI
The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 4
```
Set-VerkadaLicensePlateOfInterest -license_plate 'ABC123' -description 'New License Plate Descriptionv2' -org_id 'deds343-uuid-of-org' -x_api_key 'sd78ds-uuid-of-verkada-token'
The org_id and tokens are submitted as parameters in the call.
```

## PARAMETERS

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Global:verkadaConnection.org_id
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

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

### -x_api_key
The public API key to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Global:verkadaConnection.token
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaLicensePlateOfInterest.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaLicensePlateOfInterest.md)

