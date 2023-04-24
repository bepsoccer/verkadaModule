---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCommandUser.md
schema: 2.0.0
---

# Get-VerkadaCommandUser

## SYNOPSIS
Gets the Command users' details in an organization

## SYNTAX

### userId (Default)
```
Get-VerkadaCommandUser -userId <String> [-org_id <String>] [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [-usr <String>] [<CommonParameters>]
```

### email
```
Get-VerkadaCommandUser -email <String> [-org_id <String>] [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [-usr <String>] [<CommonParameters>]
```

### name
```
Get-VerkadaCommandUser -Name <String> [-org_id <String>] [-x_verkada_token <String>] [-x_verkada_auth <String>]
 [-usr <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used return all the details of Command users.
 
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaCommandUser -userId '3651fbcb-f8ba-4248-ad70-3f6512fd7b6c' 
This will attempt to get the user details of a user with the the userId of '3651fbcb-f8ba-4248-ad70-3f6512fd7b6c'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaCommandUser -email 'bob.smith@contoso.com' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
This will attempt to get the user details of a user with email address bob.smith@contoso.com.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Get-VerkadaCommandUser -Name 'Bob Smith'
This will attempt to get the user details of a user named "Bob Smith".  Depending of the name submitted, i.e. could just be a first or last name, multiple results could be returned.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

### -userId
The first name of the user being searched for

```yaml
Type: String
Parameter Sets: userId
Aliases:

Required: True
Position: Named
Default value: None
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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The last name of the user being searched for

```yaml
Type: String
Parameter Sets: name
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCommandUser.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCommandUser.md)

