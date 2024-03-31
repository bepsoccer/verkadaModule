---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Export-VerkadaAccessUserProfilePicture.md
schema: 2.0.0
---

# Export-VerkadaAccessUserProfilePicture

## SYNOPSIS
Downloads a copy of the current Verkada Access profile picture.

## SYNTAX

```
Export-VerkadaAccessUserProfilePicture [[-userId] <String>] [[-outPath] <String>] [[-org_id] <String>]
 [[-x_verkada_token] <String>] [[-x_verkada_auth] <String>] [[-usr] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This will download the Access user's, specified by the userId, current profile picture.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Export-VerkadaAccessUserProfilePicture -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -outPath './MyProfilePics'
This downloads the Access user's, with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3, picture to ./MyProfilePics/801c9551-b04c-4293-84ad-b0a6aa0588b3.jpg.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Find-VerkadaUserId -email 'some.user@contoso.com' | Export-VerkadaAccessUserProfilePicture
This downloads the Access user's, with email some.user@contoso.com, picture to ./MyProfilePics/801c9551-b04c-4293-84ad-b0a6aa0588b3.jpg.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 3
```
Export-VerkadaAccessUserProfilePicture -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -outPath './MyProfilePics' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This downloads the Access user's, with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3, picture to ./MyProfilePics/801c9551-b04c-4293-84ad-b0a6aa0588b3.jpg.  The org_id and tokens are submitted as parameters in the call.
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

### -outPath
This is the path the picture/s will attempt to be saved to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: ./
Accept pipeline input: False
Accept wildcard characters: False
```

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
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
Position: 5
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
Position: 6
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Export-VerkadaAccessUserProfilePicture.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Export-VerkadaAccessUserProfilePicture.md)

