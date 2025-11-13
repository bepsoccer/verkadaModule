---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Enable-VerkadaAccessUserCard.md
schema: 2.0.0
---

# Enable-VerkadaAccessUserCard

## SYNOPSIS
Activates a credential for an Aceess user in an organization using https://apidocs.verkada.com/reference/putaccesscardactivateviewv1

## SYNTAX

```
Enable-VerkadaAccessUserCard [[-userId] <String>] [[-externalId] <String>] [[-cardId] <String>]
 [[-x_verkada_auth_api] <String>] [[-region] <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Given the Verkada defined User ID (OR user defined External ID)and Card ID, activate a specific access card for a user.
Returns the updated Access Card Object.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Enable-VerkadaAccessUserCard -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -cardId '3f3b3e4d-1a67-4b88-a321-43c5e502991c'
This will activate the credential with cardId 10110010000000000000001011 for the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 as a credential.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Enable-VerkadaAccessUserCard -externalId 'newUserUPN@contoso.com' -cardId '3f3b3e4d-1a67-4b88-a321-43c5e502991c' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will activate the credential with cardId 10110010000000000000001011 for the Access user with externalId newUserUPN@contoso.com as a credential.  The token is submitted as a parameter in the call.
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

### -cardId
The cardId of the credential

```yaml
Type: String
Parameter Sets: (All)
Aliases: card_id

Required: False
Position: 3
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
Position: 4
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
Position: 5
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Enable-VerkadaAccessUserCard.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Enable-VerkadaAccessUserCard.md)

