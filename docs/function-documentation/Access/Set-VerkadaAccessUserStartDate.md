---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserStartDate.md
schema: 2.0.0
---

# Set-VerkadaAccessUserStartDate

## SYNOPSIS
Sets the start date for an Access user's access in an organization using https://apidocs.verkada.com/reference/putaccessstartdateviewv1

## SYNTAX

```
Set-VerkadaAccessUserStartDate [[-userId] <String>] [[-externalId] <String>] [[-startDate] <DateTime>]
 [[-x_verkada_auth_api] <String>] [[-region] <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Given the user defined External ID or Verkada defined User ID (but not both), set the start date for an access users credentials to become valid.
Before this time, all methods of access specified for this access user will invalid.
Start date value will be passed as a parameter in a json payload.
Returns the updated Access Information Object.
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaAccessUserStartDate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -startDate '1/28/2022 08:00 AM'
This sets the Access user's access to start at 8am on Jan 28, 2022 with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaAccessUserStartDate -externalId 'newUserUPN@contoso.com' -startDate (Get-Date) -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This sets the Access user's access to start immediately since you are specifiying the current date and time with externalId newUserUPN@contoso.com.  The token is submitted as a parameter in the call.
```

## PARAMETERS

### -userId
The UUID of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: user_id

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -externalId
unique identifier managed externally provided by the consumer

```yaml
Type: String
Parameter Sets: (All)
Aliases: external_id

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -startDate
The Date/Time the user's Access starts

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: start_date

Required: False
Position: 3
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
Position: 4
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
Position: 5
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserStartDate.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserStartDate.md)

