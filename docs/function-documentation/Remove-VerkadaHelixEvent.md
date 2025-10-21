---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaHelixEvent.md
schema: 2.0.0
---

# Remove-VerkadaHelixEvent

## SYNOPSIS
Deletes a Helix event using https://apidocs.verkada.com/reference/deletevideotaggingeventviewv1

## SYNTAX

```
Remove-VerkadaHelixEvent [[-org_id] <String>] [-camera_id] <String> [-event_type_uid] <String>
 [[-timeStamp] <DateTime>] [[-epoch_time] <Int64>] [[-x_verkada_auth_api] <String>] [[-region] <String>]
 [-errorsToFile] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This method can be used to delete a Helix event from Command.
The required parameter to successfully delete a Helix event are the associated Camera ID, API Token with Helix permissions, Event Type UID, and the exact event epoch time in milliseconds.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Remove-VerkadaHelixEvent -camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc -event_type_uid cf918b16-26cd-4c01-a672-5a91b79311e1 -timeStamp '1/1/2025 08:35:00 -06'
This will delete the helix event for Jan 1, 2025 at 8:35 AM CST for the sepcified camera, and event ID. The org_id and token will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Remove-VerkadaHelixEvent -camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc -event_type_uid cf918b16-26cd-4c01-a672-5a91b79311e1 -timeStamp '1/1/2025 08:35:00 -06' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will delete the helix event for Jan 1, 2025 at 8:35 AM CST for the sepcified camera, and event ID. The org_id and token are submitted as parameters in the call.
```

## PARAMETERS

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Global:verkadaConnection.org_id
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -camera_id
The UUID of the camera who's name is being changed

```yaml
Type: String
Parameter Sets: (All)
Aliases: cameraId

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -event_type_uid
The UID of the event type to be used when creating the event

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -timeStamp
The the timestamp of the event

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -epoch_time
The the epoch time of the event in milliseconds

```yaml
Type: Int64
Parameter Sets: (All)
Aliases: time_ms

Required: False
Position: 5
Default value: 0
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
Position: 6
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
Position: 7
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaHelixEvent.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaHelixEvent.md)

