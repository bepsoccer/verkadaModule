---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraTamperSensitivity.md
schema: 2.0.0
---

# Set-VerkadaCameraTamperSensitivity

## SYNOPSIS
Sets the tamper sensitivity of a Verkada Camera

## SYNTAX

### cameraId
```
Set-VerkadaCameraTamperSensitivity [-org_id <String>] -camera_id <String> [-serial <String>]
 [-sensitivity <String>] [-sensitivityNumber <Int32>] [-x_verkada_token <String>] [-x_verkada_auth <String>]
 [-usr <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### serial
```
Set-VerkadaCameraTamperSensitivity [-org_id <String>] -serial <String> [-sensitivity <String>]
 [-sensitivityNumber <Int32>] [-x_verkada_token <String>] [-x_verkada_auth <String>] [-usr <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This is used to set the sensitivity of the tamper sensor of a Verkada camera and can use the pre-defined Low, Moderate, and High or an integer between -200 to 100.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaCameraTamperSensitivity -camera_id '4b822169-4f79-4ade-a4dd-676d39d4e802' -sensitivity High
This will set the tamper sensitivity of the camera with cameraId 4b822169-4f79-4ade-a4dd-676d39d4e802 to High(100).  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaCameraTamperSensitivity -serial 'YRF9-AKGQ-HC3P' -sensitivityNumber 50 -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will set the tamper sensitivity of the camera with serial YRF9-AKGQ-HC3P to 50.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Get-VerkadaCameras | Set-VerkadaCameraTamperSensitivity -sensitivity Low 
This will set all the cameras in the org to have a tamper sensitity of Low(-200).  The org_id and tokens will be populated from the cached created by Connect-Verkada.
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

### -sensitivity
The tamper sensitivity pre-defined value

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

### -sensitivityNumber
The tamper sensitivity integer value

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraTamperSensitivity.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraTamperSensitivity.md)

