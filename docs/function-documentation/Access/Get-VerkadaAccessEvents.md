---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessEvents.md
schema: 2.0.0
---

# Get-VerkadaAccessEvents

## SYNOPSIS
Returns Verkada Access Control events using https://apidocs.verkada.com/reference/geteventsviewv1

## SYNTAX

```
Get-VerkadaAccessEvents [[-x_verkada_auth_api] <String>] [[-region] <String>] [[-start_time] <DateTime>]
 [[-end_time] <DateTime>] [[-event_type] <String[]>] [[-side_id] <String[]>] [[-device_id] <String[]>]
 [[-user_id] <String[]>] [-toLocalTime] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns events for an organization within a specified time range.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaAccessEvents
This will return all the access events from 1 hour in the past until present.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaAccessEvents -start_time 'January 1, 2025 9:00:00AM' -end_time 'February 8, 2025 10:30:00PM' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will return all the access events from Jan 1 at 9am to Feb 8 at 10:30pm.  The token is submitted as parameter in the call.
```

## PARAMETERS

### -x_verkada_auth_api
The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Position: 2
Default value: Api
Accept pipeline input: False
Accept wildcard characters: False
```

### -start_time
The optional start time for the date range of events

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

### -end_time
The optional end time for the date range of events

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -event_type
The optional event type/s for the events

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -side_id
The optional site_id/s for the events

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -device_id
The optional device_id/s for the events

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -user_id
The optional user_id/s for the events

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -toLocalTime
Switch to convert timestamps to local time

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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessEvents.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessEvents.md)

