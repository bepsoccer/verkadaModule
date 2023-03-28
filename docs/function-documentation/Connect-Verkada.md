---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Connect-Verkada.md
schema: 2.0.0
---

# Connect-Verkada

## SYNOPSIS
Gathers needed credentials for Verkada's API Endpoints

## SYNTAX

### apiToken (Default)
```
Connect-Verkada [-org_id] <String> [-x_api_key] <String> [<CommonParameters>]
```

### UnPwd
```
Connect-Verkada [-org_id] <String> [[-x_api_key] <String>] -userName <String> [-Password] [<CommonParameters>]
```

## DESCRIPTION
This function is used to authenticate a session and store the needed tokens and org_id for other functions in this module.

## EXAMPLES

### EXAMPLE 1
```
Connect-Verkada 'dsfwfd-wdf-orgId' 'myapiKey-dcwdskjnlnlkj'
This will store the org_id dsfwfd-wdf-orgId with the public API key myapiKey-dcwdskjnlnlkj.
```

### EXAMPLE 2
```
Connect-Verkada 'dsfwfd-wdf-orgId' -userName "admin.user@contoso.com" -Password
This will authenticate user admin.user@contoso.com by prompting for the password(stored as a secure string) and upon success store the org_id dsfwfd-wdf-orgId and the returned tokens.
```

### EXAMPLE 3
```
Connect-Verkada 'dsfwfd-wdf-orgId' -x_api_key 'myapiKey-dcwdskjnlnlkj' -userName "admin.user@contoso.com" -Password
This will store the org_id dsfwfd-wdf-orgId with the public API key myapiKey-dcwdskjnlnlkj and will authenticate user admin.user@contoso.com by prompting for the password(stored as a secure string) and storing the returned tokens.
```

## PARAMETERS

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -x_api_key
The public API key to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: apiToken
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: UnPwd
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -userName
The admin user name to be used to obtain needed session and auth tokens

```yaml
Type: String
Parameter Sets: UnPwd
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The switch needed to prompt for admin password to be used to obtain needed session and auth tokens

```yaml
Type: SwitchParameter
Parameter Sets: UnPwd
Aliases:

Required: True
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Connect-Verkada.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Connect-Verkada.md)

