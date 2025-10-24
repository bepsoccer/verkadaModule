---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserGroup.md
schema: 2.0.0
---

# Set-VerkadaAccessUserGroup

## SYNOPSIS
Adds an Access user to an Access group in an organization using https://apidocs.verkada.com/reference/putaccessgroupuserviewv1

## SYNTAX

### groupId (Default)
```
Set-VerkadaAccessUserGroup [-userId <String>] [-externalId <String>] [-groupId <String>]
 [-x_verkada_auth_api <String>] [-region <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### groupName
```
Set-VerkadaAccessUserGroup [-userId <String>] [-externalId <String>] [-groupName <String>]
 [-x_verkada_auth_api <String>] [-region <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Add an access user to an access group with the Verkada defined Group ID and either the user defined External ID or the Verkada defined User ID.The Group ID is passed in as query parameter in the URL.
The External ID or Verkada User ID(but not both) is passed in the json object in the body of the request.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaAccessUserGroup -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -groupId '2d64e7de-fd95-48be-8b5c-7a23bde94f52'
This adds the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 to Access group with groupId 2d64e7de-fd95-48be-8b5c-7a23bde94f52.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaAccessUserGroup -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -groupName 'MyAccessGroup'
This adds the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 to Access group with groupName MyAccessGroup.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 3
```
Set-VerkadaAccessUserGroup -externalId 'newUserUPN@contoso.com' -groupId '2d64e7de-fd95-48be-8b5c-7a23bde94f52' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This adds the Access user uwith xternalId newUserUPN@contoso.com to Access group with groupId 2d64e7de-fd95-48be-8b5c-7a23bde94f52.  The token is submitted as a parameter in the call.
```

## PARAMETERS

### -userId
The UUID of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: user_id

Required: False
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -groupId
The UUID of the group

```yaml
Type: String
Parameter Sets: groupId
Aliases: group_id

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -groupName
The name of the group the user should be added to

```yaml
Type: String
Parameter Sets: groupName
Aliases:

Required: False
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserGroup.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserGroup.md)

