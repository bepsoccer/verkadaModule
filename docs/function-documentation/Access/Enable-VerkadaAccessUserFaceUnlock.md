---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Enable-VerkadaAccessUserFaceUnlock.md
schema: 2.0.0
---

# Enable-VerkadaAccessUserFaceUnlock

## SYNOPSIS
Enables face unlock for an Access user using https://apidocs.verkada.com/reference/postfaceunlockcopyuserphotoexternaluserviewv2, https://apidocs.verkada.com/reference/postfaceunlockuploadphotoexternaluserviewv2, https://apidocs.verkada.com/reference/postfaceunlockcopyuserphotouserviewv2, and https://apidocs.verkada.com/reference/postfaceunlockuploadphotouserviewv2

## SYNTAX

### external_profilePhoto (Default)
```
Enable-VerkadaAccessUserFaceUnlock -externalId <String> [-overwrite <Boolean>] [-x_verkada_auth_api <String>]
 [-region <String>] [-version <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### user_upload
```
Enable-VerkadaAccessUserFaceUnlock -userId <String> -imagePath <String> [-overwrite <Boolean>]
 [-x_verkada_auth_api <String>] [-region <String>] [-version <String>] [-errorsToFile]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### user_profilePhoto
```
Enable-VerkadaAccessUserFaceUnlock -userId <String> [-overwrite <Boolean>] [-x_verkada_auth_api <String>]
 [-region <String>] [-version <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### external_upload
```
Enable-VerkadaAccessUserFaceUnlock -externalId <String> -imagePath <String> [-overwrite <Boolean>]
 [-x_verkada_auth_api <String>] [-region <String>] [-version <String>] [-errorsToFile]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Enable face unlock for a user by using their existing profile photo by uploading a new photo.
This will create a face credential from the user's profile photo or by providing a photo via uplaod.
If the user already has a face credential and overwrite is False, the request will fail.
The profile photo must meet quality requirements for face recognition.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Enable-VerkadaAccessUserLicensePlate -externalId 'newUserUPN@contoso.com'
This will enable Face Unlock for the user with externalId newUserUPN@contoso.com using their existing AC profile photo.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Enable-VerkadaAccessUserLicensePlate -externalId 'newUserUPN@contoso.com' -imagePath './myPicture.png' -overwrite $true -x_verkada_auth_api 'v2_sd78d9verkada-token'
This will enable Face Unlock for the user with externalId newUserUPN@contoso.com using the photo specified in the imagePath, ./myPicture.png, and will overwrite the existing face credential if it exists.  The token is submitted as a parameter in the call.
```

### EXAMPLE 3
```
Enable-VerkadaAccessUserLicensePlate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3'
This will enable Face Unlock for the user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 using their existing AC profile photo.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 4
```
Enable-VerkadaAccessUserLicensePlate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -imagePath './801c9551-b04c-4293-84ad-b0a6aa0588b3.png' -overwrite $true -x_verkada_auth_api 'v2_sd78d9verkada-token'
This will enable Face Unlock for the user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 using the photo specified in the imagePath, ./801c9551-b04c-4293-84ad-b0a6aa0588b3.png, and will overwrite the existing face credential if it exists.  The token is submitted as a parameter in the call.
```

## PARAMETERS

### -userId
The UUID of the user

```yaml
Type: String
Parameter Sets: user_upload, user_profilePhoto
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
Parameter Sets: external_profilePhoto, external_upload
Aliases: external_id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -imagePath
This is the path the image will be uploaded from

```yaml
Type: String
Parameter Sets: user_upload, external_upload
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -overwrite
The flag that states whether to overwrite the existing profile photo

```yaml
Type: Boolean
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Enable-VerkadaAccessUserFaceUnlock.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Enable-VerkadaAccessUserFaceUnlock.md)

