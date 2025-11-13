---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserProfilePicture.md
schema: 2.0.0
---

# Get-VerkadaAccessUserProfilePicture

## SYNOPSIS
Retrieves a profile photo for the specified Access user using https://apidocs.verkada.com/reference/getprofilephotoviewv1

## SYNTAX

```
Get-VerkadaAccessUserProfilePicture [[-userId] <String>] [[-externalId] <String>] [[-outPath] <String>]
 [[-original] <Boolean>] [[-x_verkada_auth_api] <String>] [[-region] <String>] [-errorsToFile]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This will download the Access user's, specified by the user_Id or external_Id, current profile picture.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Export-VerkadaAccessUserProfilePicture -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -outPath './MyProfilePics'
This downloads the Access user's, with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3, picture to ./MyProfilePics/801c9551-b04c-4293-84ad-b0a6aa0588b3.jpg.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Export-VerkadaAccessUserProfilePicture -externalId 'newUserUPN@contoso.com' -outPath './MyProfilePics' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This downloads the Access user's, with externalId newUserUPN@contoso.com picture to ./MyProfilePics/newUserUPN.jpg.  The token is submitted as parameter in the call.
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

### -outPath
This is the path the picture/s will attempt to be saved to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: ./
Accept pipeline input: False
Accept wildcard characters: False
```

### -original
The flag that states whether to download the original or cropped version

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserProfilePicture.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserProfilePicture.md)

