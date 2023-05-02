---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessDoorSchedules.md
schema: 2.0.0
---

# Get-VerkadaAccessDoorSchedules

## SYNOPSIS
Get's all Door Schedules configured in the organization

## SYNTAX

```
Get-VerkadaAccessDoorSchedules [[-org_id] <String>] [[-x_verkada_token] <String>] [[-x_verkada_auth] <String>]
 [[-usr] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function will return all the Access Door Schedules in an organization.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaAccessDoorSchedules
This function will return all the Access Door Schedules in an organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaAccessDoorSchedules -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
This function will return all the Access Door Schedules in an organization.  The org_id and tokens are submitted as parameters in the call.
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

### -x_verkada_token
The Verkada(CSRF) token of the user running the command

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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
Position: 4
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessDoorSchedules.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessDoorSchedules.md)

