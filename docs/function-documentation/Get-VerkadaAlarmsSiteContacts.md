---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAlarmsSiteContacts.md
schema: 2.0.0
---

# Get-VerkadaAlarmsSiteContacts

## SYNOPSIS
Returns the configured contacts of a Verkada Alarms site in an organization.

## SYNTAX

```
Get-VerkadaAlarmsSiteContacts [-org_id <String>] [-zoneId] <String> [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [-usr <String>] [<CommonParameters>]
```

## DESCRIPTION
This function will return the configured contacts of a Verkada Alarms site in an organization using the UUID(zoneId) of the site. 
This function take a pipeline input if you want to gather the contacts from multiple sites.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaAlarmsSiteContacts -zoneId 'cd611c9f-fa2b-4b5e-b194-f0ea296702c3'
This will return the Alarms configured contacts for the site with the zoneId cd611c9f-fa2b-4b5e-b194-f0ea296702c3.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Read-VerkadaAlarmsSites | Get-VerkadaAlarmsSiteContacts
This will return the Alarms configured contacts for every site in the org.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 3
```
Get-VerkadaAlarmsSiteContacts -zoneId 'cd611c9f-fa2b-4b5e-b194-f0ea296702c3' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will return the Alarms configured contacts for the site with the siteId cd611c9f-fa2b-4b5e-b194-f0ea296702c3.  The org_id and tokens are submitted as parameters in the call.
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

### -zoneId
The UUID of the site

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAlarmsSiteContacts.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAlarmsSiteContacts.md)

