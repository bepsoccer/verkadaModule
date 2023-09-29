---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCommandUser.md
schema: 2.0.0
---

# Set-VerkadaCommandUser

## SYNOPSIS
Sets the user details for a Command User in an organization using https://apidocs.verkada.com/reference/putuserviewv1

## SYNTAX

```
Set-VerkadaCommandUser [[-userId] <String>] [[-email] <String>] [[-firstName] <String>]
 [[-middleName] <String>] [[-lastName] <String>] [[-externalId] <String>] [[-companyName] <String>]
 [[-department] <String>] [[-departmentId] <String>] [[-employeeId] <String>] [[-employeeType] <String>]
 [[-employeeTitle] <String>] [[-phone] <String>] [[-org_id] <String>] [[-x_api_key] <String>] [-errorsToFile]
 [<CommonParameters>]
```

## DESCRIPTION
Updates a user's metadata for an organization based on either provided user ID or an external ID set during creation.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaCommandUser -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -firstName 'New' -lastName 'User'
This will update the Command user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaCommandUser -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -firstName 'New' -lastName 'User' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_api_key 'sd78ds-uuid-of-verkada-token'
This will update the Command user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 with the name "New User".  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Set-VerkadaCommandUser -externalId 'newUserUPN@contoso.com' -email 'newUser@contoso.com' 
This will update the Command user with externalId newUserUPN@contoso.com with the email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 4
```
Set-VerkadaCommandUser -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -externalId 'newUserUPN@contoso.com' 
This will update the Command user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 to have the new externalId newUPN@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 5
```
Set-VerkadaCommandUser -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -firstName 'New' -lastName 'User' -email 'newUser@contoso.com -companyName 'Contoso' -department 'sales' -departmentId 'US-Sales' -employeeId '12345' -employeeTitle 'The Closer' -employeeType 'Full Time' -phone '+18165556789'
This will update the Command user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 to the name "New User" and email newUser@contoso.com in department defined as sales with departmnetId of US-Sales with the appropriate companyName, employeeID, employeeTitle, employeeType and phone.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

### -userId
The UUID of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: user_id

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -email
The email address of the user

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
The first name of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: first_name

Required: False
Position: 3
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
Position: 4
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
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -externalId
unique identifier managed externally provided by the consumer

```yaml
Type: String
Parameter Sets: (All)
Aliases: external_id

Required: False
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
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
Position: 10
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
Position: 11
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
Position: 12
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
Position: 13
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
Position: 14
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
Position: 15
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCommandUser.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCommandUser.md)

