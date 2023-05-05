---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Find-VerkadaUserId.md
schema: 2.0.0
---

# Find-VerkadaUserId

## SYNOPSIS
Finds the userID of a user in an organization

## SYNTAX

### email (Default)
```
Find-VerkadaUserId [-org_id <String>] -email <String> [-x_verkada_token <String>] [-x_verkada_auth <String>]
 [<CommonParameters>]
```

### name
```
Find-VerkadaUserId [-org_id <String>] -firstName <String> -lastName <String> [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to find a Verkaka userId using firstName/lastName or email address.
 
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Find-VerkadaUserId -email 'newUser@contoso.com' 
This will attempt to find theuserId of the user with email address newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Find-VerkadaUserId -email 'newUser@contoso.com' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc'
This will attempt to find theuserId of the user with email address newUser@contoso.com.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Find-VerkadaUserId -firstName 'New' -lastName 'User'
This will attempt to find theuserId of the user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 4
```
Find-VerkadaUserId -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' 
This will attempt to find theuserId of the user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

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

### -email
The email address of the user being searched for

```yaml
Type: String
Parameter Sets: email
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -firstName
The first name of the user being searched for

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -lastName
The last name of the user being searched for

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: True
Position: Named
Default value: None
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Find-VerkadaUserId.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Find-VerkadaUserId.md)

