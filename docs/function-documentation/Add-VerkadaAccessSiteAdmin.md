---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessSiteAdmin.md
schema: 2.0.0
---

# Add-VerkadaAccessSiteAdmin

## SYNOPSIS
Adds a user as an Access Site Admin to a site

## SYNTAX

```
Add-VerkadaAccessSiteAdmin [-userId] <String[]> [[-siteName] <String>] [[-siteId] <String>]
 [[-org_id] <String>] [[-x_verkada_token] <String>] [[-x_verkada_auth] <String>] [[-usr] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function will make the provided user/s an Access aite admin for the provided site.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaAccessSiteAdmin -userId '2418dd52-0f0a-4cb0-8b4c-ad8432164804' -siteName 'HQ'
This will add the user with userId 2418dd52-0f0a-4cb0-8b4c-ad8432164804 as an Access site admin for the site name 'HQ'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaAccessSiteAdmin -userId 'e618d19c-cf3a-4070-af41-284fd977759c','5e9455ba-06cd-4c0f-a241-ec3d673d247b','2418dd52-0f0a-4cb0-8b4c-ad8432164804' -siteId '9fb72cf6-e025-418b-86ca-31d6bad05091' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will add the users provided as Access site admins on the site with siteId 9fb72cf6-e025-418b-86ca-31d6bad05091.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Read-VerkadaCommandUsers | ?{$_.firstName -eq 'alex' -or $_.firstName -eq 'john'} | Add-VerkadaAccessSiteAdmin -siteName 'HQ'
This will add the users found as an Access site admin for the site name 'HQ'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

### -userId
The UUID of the user the permission is being granted to

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -siteName
The name of the site being retrieved. 
Will be ignored if siteId is present

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -siteId
The UUID of of the site being retrieved

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessSiteAdmin.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessSiteAdmin.md)

