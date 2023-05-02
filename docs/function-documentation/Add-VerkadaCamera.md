---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCamera.md
schema: 2.0.0
---

# Add-VerkadaCamera

## SYNOPSIS
Adds a camera to an organization

## SYNTAX

```
Add-VerkadaCamera [-serial] <String> [[-name] <String>] [-siteId] <String> [[-location] <String>]
 [[-org_id] <String>] [[-x_verkada_token] <String>] [[-x_verkada_auth] <String>] [[-usr] <String>]
 [-skipSerialValidation] [<CommonParameters>]
```

## DESCRIPTION
Used to bulk add cameras to an organization with the desired name and location. 
This function takes pipeline paramters making it easy to add mulitple cameras via csv with the desired named out of the gate.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaCamera -serial 'ABCD-1234-EF56' -name 'My New Camera' -siteId '919dedeb-b3fe-420c-b663-ce44cbfd1c1e' -location '405 E 4th Ave, San Mateo, CA'
This will add the new camera using serial ABCD-1234-EF56 with the name "My New Camera".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaCamera -serial 'ABCD-1234-EF56' -name 'My New Camera' -siteId '919dedeb-b3fe-420c-b663-ce44cbfd1c1e' -location '405 E 4th Ave, San Mateo, CA' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
This will add the new camera using serial ABCD-1234-EF56 with the name "My New Camera".  The org_id and tokens are submitted as parameters in the call.
```

## PARAMETERS

### -serial
The serial of the camera being added

```yaml
Type: String
Parameter Sets: (All)
Aliases: serialNumber

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -name
The name of the camera being added

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

### -siteId
The siteId(camerGroupId) of the site the camera will be added to

```yaml
Type: String
Parameter Sets: (All)
Aliases: cameraGroupId

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -location
The location(address) of the camera being added

```yaml
Type: String
Parameter Sets: (All)
Aliases: address

Required: False
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
Default value: $Global:verkadaConnection.usr
Accept pipeline input: False
Accept wildcard characters: False
```

### -skipSerialValidation
Switch to skip serial validation

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCamera.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCamera.md)

