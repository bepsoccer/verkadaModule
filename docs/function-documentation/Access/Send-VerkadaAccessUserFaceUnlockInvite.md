---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Send-VerkadaAccessUserFaceUnlockInvite.md
schema: 2.0.0
---

# Send-VerkadaAccessUserFaceUnlockInvite

## SYNOPSIS
Sends an invite for an Access user to enrol their face to enable Face Unlock using https://apidocs.verkada.com/reference/postfaceunlockinviteexternaluserviewv2 or https://apidocs.verkada.com/reference/postfaceunlockinviteuserviewv2

## SYNTAX

### user_id (Default)
```
Send-VerkadaAccessUserFaceUnlockInvite -userId <String> [-overwrite <Boolean>] [-method <String[]>]
 [-x_verkada_auth_api <String>] [-region <String>] [-version <String>] [-errorsToFile]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### external_id
```
Send-VerkadaAccessUserFaceUnlockInvite -externalId <String> [-overwrite <Boolean>] [-method <String[]>]
 [-x_verkada_auth_api <String>] [-region <String>] [-version <String>] [-errorsToFile]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Enable face unlock for a user by sending them an invitation to enroll their face via mobile device.
An email will be sent to the user with a link to complete the enrollment process.
If the user already has a face credential and overwrite is False, the request will fail.
When overwrite is True, the invitation is sent and the user can upload a new photo which will replace the existing credential.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Send-VerkadaAccessUserFaceUnlockInvite -externalId 'newUserUPN@contoso.com'
This will send a Face Unlock invite to the user with externalId newUserUPN@contoso.com.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Send-VerkadaAccessUserFaceUnlockInvite -externalId 'newUserUPN@contoso.com' -overwrite $true -x_verkada_auth_api 'v2_sd78d9verkada-token'
This will send a Face Unlock invite to the user with externalId newUserUPN@contoso.com and will overwrite the existing face credential if it exists.  The token is submitted as a parameter in the call.
```

### EXAMPLE 3
```
Send-VerkadaAccessUserFaceUnlockInvite -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -method 'email'
This will send a Face Unlock invite to the user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 via email only, not the default sms and email.  The token will be populated from the cache created by Connect-Verkada.
```

## PARAMETERS

### -userId
The UUID of the user

```yaml
Type: String
Parameter Sets: user_id
Aliases: user_id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -externalId
unique identifier managed externally provided by the consumer

```yaml
Type: String
Parameter Sets: external_id
Aliases: external_id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -overwrite
The flag that states whether to overwrite the existing profile photo

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -method
The method to send the invite

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @('email','sms')
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

### -version
Version designation for which version of the function to use

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: V2
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Send-VerkadaAccessUserFaceUnlockInvite.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Send-VerkadaAccessUserFaceUnlockInvite.md)

