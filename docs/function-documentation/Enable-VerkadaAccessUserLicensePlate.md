---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Enable-VerkadaAccessUserLicensePlate.md
schema: 2.0.0
---

# Enable-VerkadaAccessUserLicensePlate

## SYNOPSIS
Activates a license plate credential for an Aceess user in an organization using https://apidocs.verkada.com/reference/putlicenseplateactivateviewv1

## SYNTAX

```
Enable-VerkadaAccessUserLicensePlate [[-userId] <String>] [[-externalId] <String>]
 [[-licensePlateNumber] <String>] [[-org_id] <String>] [[-x_api_key] <String>] [-errorsToFile]
 [<CommonParameters>]
```

## DESCRIPTION
Given the Verkada defined user ID (OR user defined External ID)and License Plate Number, activate a users License Plate Credential.
Returns the updated License Plate Object.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Enable-VerkadaAccessUserLicensePlate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -licensePlateNumber 'ABC123'
This will activate the license plate ABC123 for the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 as a credential.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Enable-VerkadaAccessUserLicensePlate -externalId 'newUserUPN@contoso.com' -licensePlateNumber 'ABC123' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_api_key 'sd78ds-uuid-of-verkada-token'
This will activate the license plate ABC123 for the Access user with externalId newUserUPN@contoso.com as a credential.  The org_id and tokens are submitted as parameters in the call.
```

## PARAMETERS

### -userId
The UUID of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: user_id

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -externalId
unique identifier managed externally provided by the consumer

```yaml
Type: String
Parameter Sets: (All)
Aliases: external_id

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -licensePlateNumber
The license plate number of the user credential

```yaml
Type: String
Parameter Sets: (All)
Aliases: license_plate_number

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Global:verkadaConnection.org_id
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
Position: 5
Default value: $Global:verkadaConnection.token
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Enable-VerkadaAccessUserLicensePlate.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Enable-VerkadaAccessUserLicensePlate.md)

