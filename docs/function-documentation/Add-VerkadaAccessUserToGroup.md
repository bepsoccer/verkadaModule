---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUserToGroup.md
schema: 2.0.0
---

# Add-VerkadaAccessUserToGroup

## SYNOPSIS
Adds an Access User to an Access Group in an organization

## SYNTAX

### email (Default)
```
Add-VerkadaAccessUserToGroup [-org_id <String>] -userId <String[]> [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [-threads <Int32>] [<CommonParameters>]
```

### groupId
```
Add-VerkadaAccessUserToGroup [-org_id <String>] -userId <String[]> -groupId <String[]>
 [-x_verkada_token <String>] [-x_verkada_auth <String>] [-threads <Int32>] [<CommonParameters>]
```

### groupName
```
Add-VerkadaAccessUserToGroup [-org_id <String>] -userId <String[]> -groupName <String[]>
 [-x_verkada_token <String>] [-x_verkada_auth <String>] [-threads <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to add a Verkada Access user to a group or groups.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaAccessUserToGroup -userid 'dcscsdc-dsc-user1' -groupId 'df76sd-dsc-group1','dsf987-daf-group2'
This will add the userid dcscsdc-dsc-user1 to access groups df76sd-dsc-group1 and dsf987-daf-group2.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaAccessUserToGroup -userid 'dcscsdc-dsc-user1' -groupId 'df76sd-dsc-group1','dsf987-daf-group2' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc'
This will add the userid dcscsdc-dsc-user1 to access groups df76sd-dsc-group1 and dsf987-daf-group2.  The org_id and tokens are submitted as parameters in the call.
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
The UUID of the user the badge is being added to

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -groupId
The UUID of the group or groups the user should be added to

```yaml
Type: String[]
Parameter Sets: groupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -groupName
The name of the group or groups the user should be added to on creation(not currently implemented)

```yaml
Type: String[]
Parameter Sets: groupName
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUserToGroup.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUserToGroup.md)

