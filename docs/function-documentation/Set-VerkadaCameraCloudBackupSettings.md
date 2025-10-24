---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraCloudBackupSettings.md
schema: 2.0.0
---

# Set-VerkadaCameraCloudBackupSettings

## SYNOPSIS
This updates the cloud backup settings for a camera using https://apidocs.verkada.com/reference/postcloudbackupviewv1

## SYNTAX

```
Set-VerkadaCameraCloudBackupSettings [-camera_id] <String> -days_to_preserve <String> -enabled <Int32>
 -time_to_preserve <String> -upload_timeslot <String> -video_quality <String> -video_to_upload <String>
 [-x_verkada_auth_api <String>] [-region <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function set the cloud back settings for a camera or cameras.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaCameraCloudBackupSettings -enabled 1 -upload_timeslot '0,86400' -time_to_preserve '25200,68400' -days_to_preserve '1,1,1,1,1,1,1'  -video_to_upload 'ALL' -video_quality 'STANDARD_QUALITY' -camera_id 'cwdfwfw-3f3-cwdf2-cameraId'
This will set the camera cwdfwfw-3f3-cwdf2-cameraId to use cloud backup with the submitted settings.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaCameraCloudBackupSettings -enabled 1 -upload_timeslot '0,86400' -time_to_preserve '25200,68400' -days_to_preserve '1,1,1,1,1,1,1'  -video_to_upload 'ALL' -video_quality 'STANDARD_QUALITY' -camera_id 'cwdfwfw-3f3-cwdf2-cameraId' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will set the camera cwdfwfw-3f3-cwdf2-cameraId to use cloud backup with the submitted settings.  The token is submitted as a parameter in the call.
```

### EXAMPLE 3
```
import-Csv ./cameras.csv | Set-VerkadaCameraCloudBackupSettings
This will set the camera cloud backup settings for all the rows in the CSV which contains all needed params.  The token will be populated from the cache created by Connect-Verkada.
```

## PARAMETERS

### -camera_id
The UUID of the camera who's cloud backup seetings are being changed

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

### -days_to_preserve
Delimited list of booleans indicating which days footage should be uploaded.
The elements in the array indicate the following days in order: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday.
If value is 1, cloud backup is on for that day.
If value is 0, cloud backup is off for that day.
For example, 0,1,1,1,1,1,0 means only backup on weekdays.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -enabled
Status of cloud backup for a camera.
If value is 1, cloud backup is enabled.
If value is 0, cloud backup is disabled.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -time_to_preserve
Delimited list of start_time, end_time as timeslot for which a user wants footage to be backed up to the cloud, start_time and end_time are integers indicating seconds to midnight, i.e, 3600,7200 means 1am - 2am

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -upload_timeslot
Delimited list of start_time, end_time as timeslot for scheduled time for footage upload, start_time and end_time are integers indicating seconds to midnight, i.e, 3600,7200 means 1am - 2am

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -video_quality
Quality of the uploaded video.
Two values are possible: STANDARD_QUALITY and HIGH_QUALITY.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -video_to_upload
The type of video that is backed-up.
Two values are possible: MOTION and ALL.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraCloudBackupSettings.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraCloudBackupSettings.md)

