---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraOrientation.md
schema: 2.0.0
---

# Set-VerkadaCameraOrientation

## SYNOPSIS
Sets the orientation of a Verkada camera

## SYNTAX

### cameraId
```
Set-VerkadaCameraOrientation [-org_id <String>] -camera_id <String> [-serial <String>] [-orientation <String>]
 [-x_verkada_token <String>] [-x_verkada_auth <String>] [-usr <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### serial
```
Set-VerkadaCameraOrientation [-org_id <String>] -serial <String> [-orientation <String>]
 [-x_verkada_token <String>] [-x_verkada_auth <String>] [-usr <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This will set the orientation of a Verkada camera to Normal, Upside down, Left, or Right. 
Note Left and Right are "portraight" views.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaCameraOrientation -camera_id '4b822169-4f79-4ade-a4dd-676d39d4e802' -orientation Normal
This will set the orientation of the camera with cameraId 4b822169-4f79-4ade-a4dd-676d39d4e802 to Normal(180).  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaCameraOrientation -serial 'YRF9-AKGQ-HC3P' -orientation Right -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will set the orientation of the camera with serial YRF9-AKGQ-HC3P to Right(270).  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Get-VerkadaCameras | Set-VerkadaCameraOrientation -orientation UpsideDown 
This will set all the cameras in the org to have an orientation of UpsideDown(0).  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Global:verkadaConnection.org_id
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -camera_id
The UUID of the camera who's name is being changed

```yaml
Type: String
Parameter Sets: cameraId
Aliases: cameraId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -serial
The serial of the camera who's name is being changed

```yaml
Type: String
Parameter Sets: cameraId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: serial
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -orientation
The orientation of the camera

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -x_verkada_token
The Verkada(CSRF) token of the user running the command

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
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
Position: Named
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraOrientation.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraOrientation.md)

