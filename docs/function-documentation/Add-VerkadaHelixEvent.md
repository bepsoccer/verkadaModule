---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaHelixEvent.md
schema: 2.0.0
---

# Add-VerkadaHelixEvent

## SYNOPSIS
Creates a Helix event in Commadn using https://apidocs.verkada.com/reference/postvideotaggingeventviewv1

## SYNTAX

```
Add-VerkadaHelixEvent [[-org_id] <String>] [-camera_id] <String> [-event_type_uid] <String>
 [-timeStamp] <DateTime> [-attributes] <Object> [[-flagged] <Boolean>] [[-x_verkada_auth_api] <String>]
 [[-region] <String>] [-errorsToFile] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This method can be used to generate a Helix Event in Command.
Users will be able to specify the attribute values for each attribute key that was previously defined in the Event Type creation process.
To successfully create a Helix Event, users will need to input the associated Camera ID, API Token with Helix permissions, Event Type UID, and the exact event epoch timestamp in milliseconds.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaHelixEvent -camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc -event_type_uid cf918b16-26cd-4c01-a672-5a91b79311e1 -timeStamp (get-date) -attributes $attributes 
This will add a new helix event for the current time for the sepcified camera, event ID, and submitted attributes. The org_id and token will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaHelixEvent -camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc -event_type_uid cf918b16-26cd-4c01-a672-5a91b79311e1 -timeStamp '1/1/2025 08:35:00 -06' -attributes $attributes -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will add a new helix event for Jan 1, 2025 at 8:35 AM CST for the sepcified camera, event ID, and submitted attributes. The org_id and token are submitted as parameters in the call.
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
The the epoch time of the event

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -attributes
The parameters to be submitted for the event

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -flagged
Boolean if the event should be flagged

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
Position: 7
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
Position: 8
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaHelixEvent.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaHelixEvent.md)

