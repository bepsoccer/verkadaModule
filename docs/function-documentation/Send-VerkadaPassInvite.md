---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Send-VerkadaPassInvite.md
schema: 2.0.0
---

# Send-VerkadaPassInvite

## SYNOPSIS
Send a Verkada Pass email invited to an Access user in an organization using https://apidocs.verkada.com/reference/postsendpassappinviteviewv1

## SYNTAX

```
Send-VerkadaPassInvite [[-userId] <String>] [[-externalId] <String>] [-activateBLE]
 [[-x_verkada_auth_api] <String>] [[-region] <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Given the user defined External ID or Verkada defined User ID (but not both) and the Organization ID, send out a Pass App invite.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Send-VerkadaPassInvite -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3'
This will send an email invite to an Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Send-VerkadaPassInvite -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -activateBLE
This will send an email invite to an Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 and activate BLE unlocks.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 3
```
Send-VerkadaPassInvite -externalId 'newUserUPN@contoso.com' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will send an email invite to an Access user with -externalId 'newUserUPN@contoso.com'.  The token is submitted as a parameter in the call.
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

### -activateBLE
Switch to also Activate BLE for the user

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
Position: 3
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
Position: 4
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Send-VerkadaPassInvite.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Send-VerkadaPassInvite.md)

