---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessGroup.md
schema: 2.0.0
---

# Get-VerkadaAccessGroup

## SYNOPSIS
Gets all Access groups in an organization or a specific Access Group.

## SYNTAX

```
Get-VerkadaAccessGroup [[-org_id] <String>] [[-Name] <String>] [[-groupId] <String>]
 [[-x_verkada_token] <String>] [[-x_verkada_auth] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function will return all the Access Groups in an organization if no parameters are specified. 
If the name parameter is specified, it will attempt to retrieve the group matching the name. 
If the groupId parameter is specified, it will attempt to retrieve the group matching the groupId.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaAccessGroup.	The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaAccessGroup -name "Executive Access".	The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 3
```
Get-VerkadaAccessGroup -groupId "7858d17a-3f72-4506-8532-a4b6ba233c5e".	The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 4
```
Get-VerkadaAccessGroup -name "Executive Access" -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'.	The org_id and tokens are submitted as parameters in the call.
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

### -Name
The name of the group being retrieved

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

### -groupId
The UUID of the group being retrieved

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
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
Position: 4
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
Position: 5
Default value: $Global:verkadaConnection.userToken
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessGroup.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessGroup.md)

