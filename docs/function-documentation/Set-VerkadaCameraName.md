---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraName.md
schema: 2.0.0
---

# Set-VerkadaCameraName

## SYNOPSIS
Set the name of a camera in an organization

## SYNTAX

### cameraId
```
Set-VerkadaCameraName [-org_id <String>] -camera_id <String> [-serial <String>] -camera_name <String>
 [-x_verkada_token <String>] [-x_verkada_auth <String>] [<CommonParameters>]
```

### serial
```
Set-VerkadaCameraName [-org_id <String>] -serial <String> -camera_name <String> [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [-x_api_key <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to rename a camera or cameras in a Verkada org.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaCameraName -camera_id 'cwdfwfw-3f3-cwdf2-cameraId' -camera_name 'Camera1'
This will rename camera_id cwdfwfw-3f3-cwdf2-cameraId to Camera1.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaCameraName -camera_id 'cwdfwfw-3f3-cwdf2-cameraId' -camera_name 'Camera1' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will rename camera_id cwdfwfw-3f3-cwdf2-cameraId to Camera1.   The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Set-VerkadaCameraName -serial 'ABCD-123-UNME' -camera_name 'Camera1'
This will rename the camera with serial ABCD-123-UNME to Camera1.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 4
```
Import-Csv ./cameras.csv | Set-VerkadaCameraName  
This will rename all the cameras in the imported CSV which needs to caontain the camera_id(cameraId) or serial and the camera_name(name).  The org_id and tokens are submitted as parameters in the call.
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

### -camera_name
The new name for the camera who's name is being changed

```yaml
Type: String
Parameter Sets: (All)
Aliases: name

Required: True
Position: Named
Default value: None
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

### -x_api_key
The public API key to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: serial
Aliases:

Required: False
Position: Named
Default value: $Global:verkadaConnection.token
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraName.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraName.md)

