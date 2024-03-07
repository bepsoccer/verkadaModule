---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCommandUser.md
schema: 2.0.0
---

# Add-VerkadaCommandUser

## SYNOPSIS
Adds a user to Verkada Command using https://apidocs.verkada.com/reference/postuserviewv1

## SYNTAX

```
Add-VerkadaCommandUser [[-email] <String>] [[-firstName] <String>] [[-middleName] <String>]
 [[-lastName] <String>] [[-externalId] <String>] [[-companyName] <String>] [[-department] <String>]
 [[-departmentId] <String>] [[-employeeId] <String>] [[-employeeType] <String>] [[-employeeTitle] <String>]
 [[-phone] <String>] [[-org_id] <String>] [[-x_api_key] <String>] [-errorsToFile]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a user in an organization.
External ID required.
Otherwise, the newly created user will contain a user ID which can be used for identification.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaCommandUser -firstName 'New' -lastName 'User'
This will add the Command user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaCommandUser -firstName 'New' -lastName 'User' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_api_key 'sd78ds-uuid-of-verkada-token'
This will add the Command user with the name "New User".  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Add-VerkadaCommandUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' 
This will add the Command user with the name "New User" and email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 4
```
Add-VerkadaCommandUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -externalId 'newUserUPN@contoso.com'
This will add the Command user with the name "New User", email newUser@contoso.com, and externalId newUserUPN@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 5
```
Add-VerkadaCommandUser -email 'newUser@contoso.com' 
This will add the Command user with the email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 6
```
Add-VerkadaCommandUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com -companyName 'Contoso' -department 'sales' -departmentId 'US-Sales' -employeeId '12345' -employeeTitle 'The Closer' -employeeType 'Full Time' -phone '+18165556789'
This will add the Command user with the name "New User" and email newUser@contoso.com in department defined as sales with departmnetId of US-Sales with the appropriate companyName, employeeID, employeeTitle, employeeType and phone.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

### -email
The email address of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

### -middleName
The middle name of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: middle_name

Required: False
Position: 3
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
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -externalId
unique identifier managed externally provided by the consumer. 
This will default to email if omitted

```yaml
Type: String
Parameter Sets: (All)
Aliases: external_id

Required: False
Position: 5
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
Position: 6
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
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -departmentId
The departmentId of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: department_id

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -employeeId
The employee ID of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: employee_id

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -employeeType
The employee type of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: employee_type

Required: False
Position: 10
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
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -phone
The main phone number of the user, E.164 format preferred

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

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: $Global:verkadaConnection.org_id
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -x_api_key
The public API key to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: $Global:verkadaConnection.token
Accept pipeline input: False
Accept wildcard characters: False
```

### -errorsToFile
Switch to write errors to file

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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCommandUser.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCommandUser.md)

