---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAlarmsPanicButtonSettings.md
schema: 2.0.0
---

# Set-VerkadaAlarmsPanicButtonSettings

## SYNOPSIS
This is used to set the various settings of a Verkada Alarms panic button

## SYNTAX

```
Set-VerkadaAlarmsPanicButtonSettings [-deviceId] <String> [[-panicPressType] <String>]
 [[-enableMobileMode] <Boolean>] [[-isSilent] <Boolean>] [[-isMuted] <Boolean>] [[-tamperIsMuted] <Boolean>]
 [[-org_id] <String>] [[-x_verkada_token] <String>] [[-x_verkada_auth] <String>] [[-usr] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
This will set the settings of a Verkada Alarms wireless panic button in an organization. 
This can be used to set the press type, the mobile mode, silent mode, mute device, and mute tamper events settings.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaAlarmsPanicButtonSettings -deviceId 'cd1f1bb9-c8b9-40b9-ab14-546a93d952cf' -panicPressType 'long'
Sets the panic button press type to long for the panic button with deviceId cd1f1bb9-c8b9-40b9-ab14-546a93d952cf.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaAlarmsDevices | Select-Object -ExpandProperty panicButton | Set-VerkadaAlarmsPanicButtonSettings -tamperIsMuted $true
Sets all the panic buttons in an org to mute tamper events. The org_id and tokens are submitted as parameters in the call.
```

## PARAMETERS

### -deviceId
The UUID of the panic button

```yaml
Type: String
Parameter Sets: (All)
Aliases: device_id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -panicPressType
The panicPressType setting

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -enableMobileMode
The enableMobileMode setting

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -isSilent
The isSilent setting

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -isMuted
The isMuted setting

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -tamperIsMuted
The tamperIsMuted setting

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $Global:verkadaConnection.org_id
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
Position: 8
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
Position: 9
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
Position: 10
Default value: $Global:verkadaConnection.usr
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAlarmsPanicButtonSettings.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAlarmsPanicButtonSettings.md)

