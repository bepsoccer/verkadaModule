---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserEndDate.md
schema: 2.0.0
---

# Set-VerkadaAccessUserEndDate

## SYNOPSIS
Sets the end date for an Access user's access in an organization using https://apidocs.verkada.com/reference/putaccessenddateviewv1

## SYNTAX

```
Set-VerkadaAccessUserEndDate [[-userId] <String>] [[-externalId] <String>] [[-endDate] <DateTime>]
 [[-org_id] <String>] [[-x_api_key] <String>] [-errorsToFile] [<CommonParameters>]
```

## DESCRIPTION
Given the user defined External ID or Verkada defined User ID (but not both), set the end date for an access users' credentials to become invalid.
After this time, all methods of access will be revoked.
End date value will be passed as a parameter in a json payload.
Returns the updated Access Information Object.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaAccessUserEndDate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -endDate '11/28/2025 08:00 AM'
This sets the Access user's access to end at 8am on Nov 28, 2025 with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaAccessUserEndDate -externalId 'newUserUPN@contoso.com' -endDate (Get-Date) -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_api_key 'sd78ds-uuid-of-verkada-token'
This sets the Access user's access to end immediately since you are specifiying the current date and time with externalId newUserUPN@contoso.com.  The org_id and tokens are submitted as parameters in the call.
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

### -endDate
The Date/Time the user's Access ends

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: end_date

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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserEndDate.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserEndDate.md)

