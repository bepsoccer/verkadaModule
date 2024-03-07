---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessDoorScheduleOverride.md
schema: 2.0.0
---

# Set-VerkadaAccessDoorScheduleOverride

## SYNOPSIS
This is used to set a Verkada Access door schedule override

## SYNTAX

### minutes
```
Set-VerkadaAccessDoorScheduleOverride -doorId <String> -minutes <Int32> [-startDate <DateTime>]
 -doorState <String> [-org_id <String>] [-x_verkada_token <String>] [-x_verkada_auth <String>] [-usr <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### indefinite
```
Set-VerkadaAccessDoorScheduleOverride -doorId <String> [-indefinite] [-startDate <DateTime>]
 -doorState <String> [-org_id <String>] [-x_verkada_token <String>] [-x_verkada_auth <String>] [-usr <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function allows for setting a VerkadaAccess door schedule overide in an organization. 
This can change the state to LOCKED, UNLOCKED, ACCESS_CONTROL for the period of time specified. 
This can also be indefinte and be set to start in the future.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaAccessDoorScheduleOverride -doorId '373c1b23-3965-4bf8-80cb-6bd245b366b8' -doorState 'UNLOCKED' -minutes 30
This will set the door with doorId 373c1b23-3965-4bf8-80cb-6bd245b366b8 to change its schedule to be unlocked for the next 30 minutes.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaAccessDoorScheduleOverride -doorId '373c1b23-3965-4bf8-80cb-6bd245b366b8' -doorState 'LOCKED' -startDateTime '11/3/2023 12:16PM' -indefinite -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will set the door with doorId 373c1b23-3965-4bf8-80cb-6bd245b366b8 to change its schedule to be locked indefinitely fstarting on November 3, 2023 at 12:16PM local time.  The org_id and tokens are submitted as parameters in the call.
```

## PARAMETERS

### -doorId
The UUID of the door

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

### -minutes
The duration in minutes for the override

```yaml
Type: Int32
Parameter Sets: minutes
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -indefinite
The switch to make the overide indefinite

```yaml
Type: SwitchParameter
Parameter Sets: indefinite
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -startDate
The Date/Time the override starts

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: startDateTime

Required: False
Position: Named
Default value: (Get-Date)
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -doorState
The desired door override state

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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessDoorScheduleOverride.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessDoorScheduleOverride.md)

