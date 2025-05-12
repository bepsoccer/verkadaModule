---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaAccessUserFromGroup.md
schema: 2.0.0
---

# Remove-VerkadaAccessUserFromGroup

## SYNOPSIS
Removes an Access user from an Access group in an organization using https://apidocs.verkada.com/reference/deleteaccessgroupuserviewv1

## SYNTAX

```
Remove-VerkadaAccessUserFromGroup [[-userId] <String>] [[-externalId] <String>] [[-groupId] <String>]
 [[-org_id] <String>] [[-x_verkada_auth_api] <String>] [[-region] <String>] [-errorsToFile]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Remove an access user from an access group with the Verkada defined group ID and the user defined either by their User ID or their External ID.
Both the group ID and the User ID(or External ID) are passed as query parameters in the URL.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Remove-VerkadaAccessUserFromGroup -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -groupId '2d64e7de-fd95-48be-8b5c-7a23bde94f52'
This will remove the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 from the group with groupId 2d64e7de-fd95-48be-8b5c-7a23bde94f52.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Remove-VerkadaAccessUserFromGroup -externalId 'newUserUPN@contoso.com' -groupId '2d64e7de-fd95-48be-8b5c-7a23bde94f52' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will remove the Access user with externalId newUserUPN@contoso.com from the group with groupId 2d64e7de-fd95-48be-8b5c-7a23bde94f52.  The org_id and tokens are submitted as parameters in the call.
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

### -groupId
The UUID of the group

```yaml
Type: String
Parameter Sets: (All)
Aliases: group_id

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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaAccessUserFromGroup.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaAccessUserFromGroup.md)

