---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserReport.md
schema: 2.0.0
---

# Get-VerkadaAccessUserReport

## SYNOPSIS
Returns a report of all doors a user has access to and by what means.

## SYNTAX

```
Get-VerkadaAccessUserReport [[-user] <Object>] [-org_id <String>] [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [-usr <String>] [<CommonParameters>]
```

## DESCRIPTION
This function will return all the doors the user/s have access to, the credentials assigned to the user, the last time they accessed a door, and their group membership. 
This function requires that a valid Verkada Access User object be submitted.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaAccessUser -userId 'c1cb427f-9ef4-4800-95ec-4a580bfa2bf1' | Get-VerkadaAccessUserReport.	The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Read-VerkadaAccessUsers | Get-VerkadaAccessUserReport -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'.	The org_id and tokens are submitted as parameters in the call.
```

## PARAMETERS

### -user
The Access user object the report will run against

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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
Accept pipeline input: False
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserReport.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserReport.md)

