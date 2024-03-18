---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaWorkplaceEmployee.md
schema: 2.0.0
---

# Set-VerkadaWorkplaceEmployee

## SYNOPSIS
Sets the properties of a Verkada Workplace employee in an org and/or a specific site.

## SYNTAX

```
Set-VerkadaWorkplaceEmployee [[-hostId] <String>] [[-firstName] <String>] [[-lastName] <String>]
 [[-phoneNumber] <String>] [[-siteId] <String>] [[-siteName] <String>] [[-org_id] <String>]
 [[-x_verkada_token] <String>] [[-x_verkada_auth] <String>] [[-usr] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Used to set the properties of a Verkada Workplace employee in the root org and/or specific sites. 
Specificying the siteId or siteName will set the properties of the employee in that site. 
These paramteres are mutally exclusive. 
Omitting siteId or siteName will set the properties of the employee in the root org.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaWorkplaceEmployee -hostId 8b6e9c59-ffff-4f89-9367-7e6786346f29 -firstName 'New' -lastName 'User' -phoneNumber '+15551239876'
This will set a Workplace employee's, with the hostId '8b6e9c59-ffff-4f89-9367-7e6786346f29', name to "New User" and the phone number to +15551239876 in the organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaWorkplaceEmployee -hostId 8b6e9c59-ffff-4f89-9367-7e6786346f29 -siteId '21efb7f-8329-4886-a89d-d2cc482b01d0' -firstName 'New' -lastName 'Username'
This will set a Workplace employee's, with the hostId '8b6e9c59-ffff-4f89-9367-7e6786346f29', name to "New Username" in the site with the id 'c21efb7f-8329-4886-a89d-d2cc482b01d0' in the organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 3
```
Set-VerkadaWorkplaceEmployee -siteName 'My Guest Site' -phoneNumber '+15551239876' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will set a Workplace employee's, with the hostId '8b6e9c59-ffff-4f89-9367-7e6786346f29', phone number to +15551239876 in the site named 'My Guest Site' in the organization.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 4
```
Get-VerkadaWorkplaceEmployee -siteName 'My Guest Site' -email "new.user@contoso.com" | Set-VerkadaWorkplaceEmployee -phoneNumber '+15551239876'
This will set a Workplace employee's, who's email is new.user@contoso.com, phone number to +15551239876 in the site named 'My Guest Site' in the organization.   The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

### -hostId
The UUID of the employee

```yaml
Type: String
Parameter Sets: (All)
Aliases: employeeId

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -firstName
The first name of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: first_name

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -lastName
The last name of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: last_name

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -phoneNumber
The phone number of the user, E.164 format preferred

```yaml
Type: String
Parameter Sets: (All)
Aliases: phone

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -siteId
The UUID of the site

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -siteName
The siteName if siteId is unknown

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
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
Position: 10
Default value: $Global:verkadaConnection.usr
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaWorkplaceEmployee.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaWorkplaceEmployee.md)

