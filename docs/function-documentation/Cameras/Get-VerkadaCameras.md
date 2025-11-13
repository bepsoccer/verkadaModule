---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCameras.md
schema: 2.0.0
---

# Get-VerkadaCameras

## SYNOPSIS
Gets all the cameras and their details using https://apidocs.verkada.com/reference/getcamerainfoviewv1

## SYNTAX

```
Get-VerkadaCameras [[-serial] <String>] [-refresh] [[-x_verkada_auth_api] <String>] [[-region] <String>]
 [-errorsToFile] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns details of all cameras within the organization.
Details returned per camera are name, site, location, model, serial number, camera ID, MAC address, local IP, device retention, extended cloud retention (if any), date camera added to command, firmware update status, camera status, location latitude, location longitude, and location angle (in degrees).
The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaCameras
This will return all the cameras in the org.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaCameras -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will return all the cameras in the org.  The token is submitted as a parameter in the call.
```

### EXAMPLE 3
```
Get-VerkadaCameras -serial
This will return the camera information using the serial.  The token will be populated from the cache created by Connect-Verkada.
```

### EXAMPLE 4
```
Get-VerkadaCameras -refresh
This will return all the cameras in the org with the most recent data available from Command.  The token will be populated from the cache created by Connect-Verkada.
```

## PARAMETERS

### -serial
The serial of the camera you are querying

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -refresh
Switch to force a refreshed list of cameras from Command

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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCameras.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCameras.md)

