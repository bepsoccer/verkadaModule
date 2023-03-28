---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Read-VerkadaCommandUsers.md
schema: 2.0.0
---

# Read-VerkadaCommandUsers

## SYNOPSIS
Gathers all Command Users in an organization

## SYNTAX

```
Read-VerkadaCommandUsers [[-org_id] <String>] [[-query] <Object>] [[-variables] <Object>] [-withGroups]
 [-x_verkada_token <String>] [-x_verkada_auth <String>] [-usr <String>] [-refresh] [<CommonParameters>]
```

## DESCRIPTION
This function will return all the active Command users in an organization.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Read-VerkadaCommandUsers
This will return all the active users in an organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Read-VerkadaCommandUsers -userId 'aefrfefb-3429-39ec-b042-userAC' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
This will return all the active users in an organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 3
```
Read-VerkadaCommandUsers -refresh
This will return all the active users in an organization with the most recent data available from Command.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -query
This is the graphql query to be submitted (do not use unless you know what you are doing)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -variables
This is the graphql variables to be submitted (do not use unless you know what you are doing)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -withGroups
Switch to include retrieving group membership (not currently implemented)

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

### -refresh
Switch to force a refreshed list of cameras from Command (not currently implemented)

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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Read-VerkadaCommandUsers.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Read-VerkadaCommandUsers.md)

