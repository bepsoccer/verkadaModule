---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCameraCloudBackupSettings.md
schema: 2.0.0
---

# Get-VerkadaCameraCloudBackupSettings

## SYNOPSIS
Gets a camera's cloud backup settings using https://apidocs.verkada.com/reference/getcloudbackupviewv1

## SYNTAX

```
Get-VerkadaCameraCloudBackupSettings [-camera_id] <String> [-backup] [[-x_verkada_auth_api] <String>]
 [[-region] <String>] [-errorsToFile] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function will retrieve the cloud backup settings of the camera requested.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaCameraCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId"
This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaCameraCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId" -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId.  The token is submitted as a parameter in the call.
```

### EXAMPLE 3
```
Get-VerkadaCameraCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId" -backup
This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId and write it to a csv.  The token will be populated from the cache created by Connect-Verkada.
```

## PARAMETERS

### -camera_id
The UUID of the camera who's cloud backup seetings are being retrieved

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -backup
Switch used to write the retrieved cloud backup settings to a csv. 
This will prompt for the path and file name for the output csv when the backup switch is used

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

### -x_verkada_auth_api
The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCameraCloudBackupSettings.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCameraCloudBackupSettings.md)

