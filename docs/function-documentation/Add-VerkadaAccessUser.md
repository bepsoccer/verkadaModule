---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version:
schema: 2.0.0
---

# Add-VerkadaAccessUser

## SYNOPSIS
Adds an Access User in an organization

## SYNTAX

### email (Default)
```
Add-VerkadaAccessUser [-org_id <String>] -email <String> [-x_verkada_token <String>] [-x_verkada_auth <String>]
 [-phone <String>] [-role <String>] [-start <DateTime>] [-expiration <DateTime>] [-sendInviteEmail <Boolean>]
 [-groupId <String[]>] [-groupName <String[]>] [-threads <Int32>] [<CommonParameters>]
```

### emailAndNameWithBadge
```
Add-VerkadaAccessUser [-org_id <String>] -email <String> -firstName <String> -lastName <String>
 [-x_verkada_token <String>] [-x_verkada_auth <String>] [-phone <String>] [-role <String>] [-start <DateTime>]
 [-expiration <DateTime>] [-sendInviteEmail <Boolean>] -cardType <String> [-cardNumber <String>]
 [-cardNumberHex <String>] [-facilityCode <String>] [-groupId <String[]>] [-groupName <String[]>]
 [-includeBadge] [-threads <Int32>] [<CommonParameters>]
```

### emailAndName
```
Add-VerkadaAccessUser [-org_id <String>] -email <String> -firstName <String> -lastName <String>
 [-x_verkada_token <String>] [-x_verkada_auth <String>] [-phone <String>] [-role <String>] [-start <DateTime>]
 [-expiration <DateTime>] [-sendInviteEmail <Boolean>] [-groupId <String[]>] [-groupName <String[]>]
 [-threads <Int32>] [<CommonParameters>]
```

### emailWithBadge
```
Add-VerkadaAccessUser [-org_id <String>] -email <String> [-x_verkada_token <String>] [-x_verkada_auth <String>]
 [-phone <String>] [-role <String>] [-start <DateTime>] [-expiration <DateTime>] [-sendInviteEmail <Boolean>]
 -cardType <String> [-cardNumber <String>] [-cardNumberHex <String>] [-facilityCode <String>]
 [-groupId <String[]>] [-groupName <String[]>] [-includeBadge] [-threads <Int32>] [<CommonParameters>]
```

### nameWithBadge
```
Add-VerkadaAccessUser [-org_id <String>] -firstName <String> -lastName <String> [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [-phone <String>] [-role <String>] [-start <DateTime>] [-expiration <DateTime>]
 [-sendInviteEmail <Boolean>] -cardType <String> [-cardNumber <String>] [-cardNumberHex <String>]
 [-facilityCode <String>] [-groupId <String[]>] [-groupName <String[]>] [-includeBadge] [-threads <Int32>]
 [<CommonParameters>]
```

### name
```
Add-VerkadaAccessUser [-org_id <String>] -firstName <String> -lastName <String> [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [-phone <String>] [-role <String>] [-start <DateTime>] [-expiration <DateTime>]
 [-sendInviteEmail <Boolean>] [-groupId <String[]>] [-groupName <String[]>] [-threads <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to add a Verkaka Access user or users to a Verkada Command Organization. 
As part of the user creation you can optionally add a badge and/or add the user to groups.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaAccessUser -email 'newUser@contoso.com' 
This will add the access user with email address newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaAccessUser -email 'newUser@contoso.com' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
This will add the access user with email address newUser@contoso.com.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Add-VerkadaAccessUser -firstName 'New' -lastName 'User'
This will add the access user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 4
```
Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' 
This will add the access user with the name "New User" and email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 5
```
Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -includeBadge -cardType 'HID' -facilityCode 111 -cardNumber 55555
This will add the access user with the name "New User" and email newUser@contoso.com with an HID badge 111-55555.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 6
```
Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -includeBadge -cardType 'HID' -facilityCode 111 -cardNumber 55555 -groupId 'df76sd-dsc-group1','dsf987-daf-group2'
This will add the access user with the name "New User" and email newUser@contoso.com with an HID badge 111-55555 and in groups df76sd-dsc-group1 and dsf987-daf-group2.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
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
The email address of the user being added
\[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'name')\]
\[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'nameWithBadge')\]

```yaml
Type: String
Parameter Sets: email, emailAndNameWithBadge, emailAndName, emailWithBadge
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -firstName
The first name of the user being added
\[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'email')\]
\[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailWithBadge')\]

```yaml
Type: String
Parameter Sets: emailAndNameWithBadge, emailAndName, nameWithBadge, name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -lastName
The last name of the user being added
\[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'email')\]
\[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailWithBadge')\]

```yaml
Type: String
Parameter Sets: emailAndNameWithBadge, emailAndName, nameWithBadge, name
Aliases:

Required: True
Position: Named
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

### -phone
The phone number of the user being added

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -role
The role of the user being added.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ORG_MEMBER
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -start
Start date/time of the user being added

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -expiration
End date/time of the user being added

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sendInviteEmail
Boolean on whether to send invite email to newly created user

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardType
The card type of the card being added

```yaml
Type: String
Parameter Sets: emailAndNameWithBadge, emailWithBadge, nameWithBadge
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardNumber
The card number of the card being added (Mutually exclusive with CardHex)

```yaml
Type: String
Parameter Sets: emailAndNameWithBadge, emailWithBadge, nameWithBadge
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardNumberHex
The card Number Hex of the card being added (Mutually exclusive with Card Number)

```yaml
Type: String
Parameter Sets: emailAndNameWithBadge, emailWithBadge, nameWithBadge
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -facilityCode
The facility code of the card being added

```yaml
Type: String
Parameter Sets: emailAndNameWithBadge, emailWithBadge, nameWithBadge
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -groupId
The UUID of the group or groups the user should be added to on creation

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -groupName
The name of the group or groups the user should be added to on creation(not currently implemented)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -includeBadge
Switch to create badge or not upon user creation

```yaml
Type: SwitchParameter
Parameter Sets: emailAndNameWithBadge, emailWithBadge, nameWithBadge
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -threads
Number of threads allowed to multi-thread the task

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

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
