---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessMfaCode.md
schema: 2.0.0
---

# Add-VerkadaAccessUserMfaCode

## SYNOPSIS
Adds a mfa code credential to a user using https://apidocs.verkada.com/reference/postmfacodeviewv1

## SYNTAX

```
Add-VerkadaAccessUserMfaCode [[-userId] <String>] [[-externalId] <String>] [[-mfaCode] <String>]
 [[-org_id] <String>] [[-x_verkada_auth_api] <String>] [[-region] <String>] [-errorsToFile]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Adds a mfa code credential to a user given a specified user_id or external_id and org_id.
MFA code object will be passed in the body of the request as a json.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaAccessUserMfaCode -mfaCode '9567' -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3'
This adds the MFA code 9567 to the Access user's profile with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3. The org_id and token will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaAccessUserMfaCode -mfaCode '9567' -externalId 'newUserUPN@contoso.com' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This adds the MFA code 9567 to the Access user's profile with externalId newUserUPN@contoso.com. The org_id and token are submitted as parameters in the call.
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

### -mfaCode
The Access MFA code

```yaml
Type: String
Parameter Sets: (All)
Aliases: mfa_code, code

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

### -x_verkada_auth_api
The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessMfaCode.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessMfaCode.md)

