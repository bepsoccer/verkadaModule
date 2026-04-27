---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Disable-VerkadaAccessUserFaceUnlock.md
schema: 2.0.0
---

# Disable-VerkadaAccessUserFaceUnlock

## SYNOPSIS
Disabled Face Unlock using https://apidocs.verkada.com/reference/deletefaceunlockdisableexternaluserviewv2 or https://apidocs.verkada.com/reference/deletefaceunlockdisableuserviewv2.

## SYNTAX

### user_id (Default)
```
Disable-VerkadaAccessUserFaceUnlock -userId <String> [-x_verkada_auth_api <String>] [-region <String>]
 [-version <String>] [-errorsToFile] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### external_id
```
Disable-VerkadaAccessUserFaceUnlock -externalId <String> [-x_verkada_auth_api <String>] [-region <String>]
 [-version <String>] [-errorsToFile] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Disable face unlock for a user.
This will delete their face credential and disable the face unlock access method.
Any pending mobile enrollment invitations for this user will also be deleted.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Disable-VerkadaAccessUserFaceUnlock -externalId 'newUserUPN@contoso.com'
This will disable Face Unlock for the user with externalId newUserUPN@contoso.com and will delete the existing face credential..  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Disable-VerkadaAccessUserFaceUnlock -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -x_verkada_auth_api 'v2_sd78d9verkada-token'
This will disable Face Unlock for the user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 and will delete the existing face credential.  The token is submitted as a parameter in the call.
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Disable-VerkadaAccessUserFaceUnlock.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Disable-VerkadaAccessUserFaceUnlock.md)

