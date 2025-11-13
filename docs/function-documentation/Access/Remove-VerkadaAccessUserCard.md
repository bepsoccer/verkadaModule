---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaAccessUserCard.md
schema: 2.0.0
---

# Remove-VerkadaAccessUserCard

## SYNOPSIS
Deletes a credential for an Aceess user in an organization using https://apidocs.verkada.com/reference/deleteaccesscardviewv1

## SYNTAX

```
Remove-VerkadaAccessUserCard [[-userId] <String>] [[-externalId] <String>] [[-cardId] <String>]
 [[-x_verkada_auth_api] <String>] [[-region] <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Deletes an access card of a specified access user given their user_id or external_id, the org_id, and the card_id.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Remove-VerkadaAccessUserCard -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -cardId '10110010000000000000001011'
This will delete the credential with cardId 10110010000000000000001011 for the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 as a credential.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Remove-VerkadaAccessUserCard -externalId 'newUserUPN@contoso.com' -cardId '10110010000000000000001011' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will delete the credential with cardId 10110010000000000000001011 for the Access user with externalId newUserUPN@contoso.com as a credential.  The token is submitted as a parameter in the call.
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaAccessUserCard.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaAccessUserCard.md)

