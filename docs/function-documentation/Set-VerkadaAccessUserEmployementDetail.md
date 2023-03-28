---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version:
schema: 2.0.0
---

# Set-VerkadaAccessUserEmployementDetail

## SYNOPSIS
Sets the employment details for an Access User in an organization

## SYNTAX

### search (Default)
```
Set-VerkadaAccessUserEmployementDetail [-org_id <String>] [-email <String>] [-firstName <String>]
 [-lastName <String>] [-employeeId <String>] [-employeeTitle <String>] [-department <String>]
 [-departmentId <String>] [-companyName <String>] [-usr <String>] [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [<CommonParameters>]
```

### userId
```
Set-VerkadaAccessUserEmployementDetail [-org_id <String>] -userId <String> [-employeeId <String>]
 [-employeeTitle <String>] [-department <String>] [-departmentId <String>] [-companyName <String>]
 [-usr <String>] [-x_verkada_token <String>] [-x_verkada_auth <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to set the employment details for an Access User in an organization. 
While userId is preferable to use this function, email or firstName/lastName can be used to set the details as it will attempt to use the Find-VerkadaUserId function to lookup the userId.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaAccessUserEmployementDetail -userId 'gjg547-uuid-of-user' -employeeId '9999sd' -department 'sales' -departmentId 'salesUS' -employeeTitle 'Account Executive' -companyName 'Contoso'
This will set the employment details specified in the parameters for the user specified.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaAccessUserEmployementDetail -userId 'gjg547-uuid-of-user' -employeeId '9999sd' -department 'sales' -departmentId 'salesUS' -employeeTitle 'Account Executive' -companyName 'Contoso' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
This will set the employment details specified in the parameters for the user specified.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Import-Csv ./myUsers.csv |  Set-VerkadaAccessUserEmployementDetail
This will set the employment details for every row in the csv file which contains userId, employeeId, employeeTitle, department, departmentId, and companyName.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
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

### -userId
The UUID of the user

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
The email address of the user being updated

```yaml
Type: String
Parameter Sets: search
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -firstName
The first name of the user being updated

```yaml
Type: String
Parameter Sets: search
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -lastName
The last name of the user being updated

```yaml
Type: String
Parameter Sets: search
Aliases:

Required: False
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
Default value: $Global:verkadaConnection.usr
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
