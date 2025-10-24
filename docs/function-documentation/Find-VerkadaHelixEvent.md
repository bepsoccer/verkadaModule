---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Find-VerkadaHelixEvent.md
schema: 2.0.0
---

# Find-VerkadaHelixEvent

## SYNOPSIS
Finds Helix event using https://apidocs.verkada.com/reference/postvideotaggingeventsearchviewv1

## SYNTAX

```
Find-VerkadaHelixEvent [[-camera_ids] <String[]>] [[-event_type_uid] <String>] [[-startTimeStamp] <DateTime>]
 [[-start_epoch_time] <Int64>] [[-endTimeStamp] <DateTime>] [[-end_epoch_time] <Int64>]
 [[-attribute_filters] <Object[]>] [[-keywords] <String[]>] [[-flagged] <Boolean>]
 [[-x_verkada_auth_api] <String>] [[-region] <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This method can be used to search for either a single or multiple Helix Events that have already been posted to Command.
In the return message, the users will be able to see the corresponding attribute keys and attribute values for those specific Helix Events.

The only required parameters to search for Helix Events is a Verkada API Token with Helix permissions.
Users will be returned a complete list of all Helix Events that are currently available in Command.
Users can further narrow down their search by adding:

Camera ID: returns all Helix Events linked to that specific camera or list of cameras.
Event Type UID: returns all Helix Events that share that specific Event Type UID.
Start and End Times: returns all Helix Events that have occurred during that time range.
Attributes Keys and Values: returns all Helix Events that have attributes keys and values matching the user's entered parameters.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Find-VerkadaHelixEvent -camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc
This will get the helix events for camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc. The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Find-VerkadaHelixEvent -event_type_uid cf918b16-26cd-4c01-a672-5a91b79311e1 -startTimeStamp '1/1/2025 08:35:00 -06' -endTimeStamp '1/7/2025 17:00:00 -06' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will find the helix events for from Jan 1, 2025 at 8:35 AM CST to Jan 7, 2025 at 5:00 APM CST for the sepcified event ID. The token is submitted as parameter in the call.
```

## PARAMETERS

### -camera_ids
The UUID of the camera who's name is being changed

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: cameraId, cameraIds, camera_id

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -event_type_uid
The UID of the event type to be used when creating the event

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -startTimeStamp
The the start timestamp of the events being serached

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -start_epoch_time
The the epoch start time of the events being serached in milliseconds

```yaml
Type: Int64
Parameter Sets: (All)
Aliases: start_time_ms

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -endTimeStamp
The the end timestamp of the events being serached

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -end_epoch_time
The the epoch end time of the events being serached in milliseconds

```yaml
Type: Int64
Parameter Sets: (All)
Aliases: end_time_ms

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -attribute_filters
The attribute filters to be used in the search query

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -keywords
The keyword/s to be used in the search query

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: keyword

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -flagged
Boolean if the event should be flagged

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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
Position: 10
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
Position: 11
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Find-VerkadaHelixEvent.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Find-VerkadaHelixEvent.md)

