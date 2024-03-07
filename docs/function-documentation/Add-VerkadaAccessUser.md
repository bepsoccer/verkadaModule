---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUser.md
schema: 2.0.0
---

# Add-VerkadaAccessUser

## SYNOPSIS
Adds an Access User in an organization

## SYNTAX

```
Add-VerkadaAccessUser [[-org_id] <String>] [[-email] <String>] [[-firstName] <String>] [[-lastName] <String>]
 [[-x_verkada_token] <String>] [[-x_verkada_auth] <String>] [[-phone] <String>] [[-role] <String>]
 [[-start] <DateTime>] [[-expiration] <DateTime>] [[-sendInviteEmail] <Boolean>] [[-cardType] <String>]
 [[-cardNumber] <String>] [[-cardNumberHex] <String>] [[-facilityCode] <String>] [[-pinCode] <String>]
 [[-groupId] <String[]>] [[-groupName] <String[]>] [[-employeeId] <String>] [[-employeeTitle] <String>]
 [[-department] <String>] [[-departmentId] <String>] [[-companyName] <String>] [[-usr] <String>]
 [[-threads] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to add a Verkaka Access user or users to a Verkada Command Organization. 
As part of the user creation you can optionally add a badge and/or add the user to groups.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaAccessUser -firstName 'New' -lastName 'User'
This will add the access user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will add the access user with the name "New User".  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' 
This will add the access user with the name "New User" and email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 4
```
Add-VerkadaAccessUser -email 'newUser@contoso.com' 
This will add the access user with the email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 5
```
Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com -department 'sales' -departmentId 'US-Sales' -employeeId '12345' -employeeTitle 'The Closer' -companyName 'Contoso' 
This will add the access user with the name "New User" and email newUser@contoso.com in department defined as sales with departmnetId of US-Sales with the appropriate employeeID, Title, and Company.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 6
```
Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -cardType 'HID' -facilityCode 111 -cardNumber 55555 -pinCode '12345'
This will add the access user with the name "New User" and email newUser@contoso.com with an HID badge 111-55555 and a pin code of 12345.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 7
```
Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -cardType 'HID' -facilityCode 111 -cardNumber 55555 -groupId 'df76sd-dsc-group1','dsf987-daf-group2'
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
Position: 1
Default value: $Global:verkadaConnection.org_id
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -email
The email address of the user being added

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

### -firstName
The first name of the user being added

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

### -lastName
The last name of the user being added

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
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
Position: 10
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
Position: 11
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardType
The card type of the card being added

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardNumber
The card number of the card being added (Mutually exclusive with CardHex)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardNumberHex
The card Number Hex of the card being added (Mutually exclusive with Card Number)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -facilityCode
The facility code of the card being added

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -pinCode
The pin code being added

```yaml
Type: String
Parameter Sets: (All)
Aliases: pin

Required: False
Position: 16
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
Position: 17
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
Position: 18
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -employeeId
The employee ID of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -employeeTitle
The title of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -department
The department of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -departmentId
The departmentId of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -companyName
The company name of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 23
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -usr
The UUID of the user account making the request

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 24
Default value: $Global:verkadaConnection.usr
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
Position: 25
Default value: 4
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUser.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUser.md)

