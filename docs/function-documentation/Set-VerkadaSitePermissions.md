---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaSitePermissions.md
schema: 2.0.0
---

# Set-VerkadaSitePermissions

## SYNOPSIS
Sets a group's or user's permission on a site in an organization

## SYNTAX

```
Set-VerkadaSitePermissions [-cameraGroupId] <String> [-securityEntityGroupId] <String> [-roleKey] <String>
 [[-org_id] <String>] [[-x_verkada_token] <String>] [[-x_verkada_auth] <String>] [[-usr] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Sets a group's or user's permission on a site in an organization. 
This function takes pipeline paramters making it easy to add mulitple sites via csv with the desired named out of the gate.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaSitePermissions -cameraGroupId '919dedeb-b3fe-420c-b663-ce44cbfd1c1e' -securityEntityGroupId(userGroupId) '719c81b9-0617-4871-b249-61559dc4684c' -roleKey 'SITE_ADMIN'
This will give the user group with ID '719c81b9-0617-4871-b249-61559dc4684c' SITE_ADMIN permission on the site with ID '919dedeb-b3fe-420c-b663-ce44cbfd1c1e'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaSitePermissions -cameraGroupId '919dedeb-b3fe-420c-b663-ce44cbfd1c1e' -securityEntityGroupId(userGroupId) '719c81b9-0617-4871-b249-61559dc4684c' -roleKey 'SITE_ADMIN' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
This will give the user group with ID '719c81b9-0617-4871-b249-61559dc4684c' SITE_ADMIN permission on the site with ID '919dedeb-b3fe-420c-b663-ce44cbfd1c1e'.  The org_id and tokens are submitted as parameters in the call.
```

## PARAMETERS

### -cameraGroupId
The cameraGroupId of the site who permissions are being set

```yaml
Type: String
Parameter Sets: (All)
Aliases: entityId, siteId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -securityEntityGroupId
The securityEntityGroupId of group or user who's being given permission to the site

```yaml
Type: String
Parameter Sets: (All)
Aliases: userGroupId, userId

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -roleKey
The permission being given

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

### -x_verkada_token
The Verkada(CSRF) token of the user running the command

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Global:verkadaConnection.csrfToken
Accept pipeline input: False
Accept wildcard characters: False
```

### -x_verkada_auth
The Verkada Auth(session auth) token of the user running the command

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: $Global:verkadaConnection.userToken
Accept pipeline input: False
Accept wildcard characters: False
```

### -usr
The UUID of the user account making the request

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Global:verkadaConnection.usr
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaSitePermissions.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaSitePermissions.md)

