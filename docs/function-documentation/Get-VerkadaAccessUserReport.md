---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserReport.md
schema: 2.0.0
---

# Get-VerkadaAccessUserReport

## SYNOPSIS
Returns a report of all doors a user has access to and by what means.

## SYNTAX

```
Get-VerkadaAccessUserReport [[-user] <Object>] [-org_id <String>] [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [-usr <String>] [-beautify] [-outReport] [-reportPath <String>] [-threads <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
This function will return all the doors the user/s have access to, the credentials assigned to the user, the last time they accessed a door, and their group membership. 
This function requires that a valid Verkada Access User object be submitted.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaAccessUserViaGraphql -userId 'c1cb427f-9ef4-4800-95ec-4a580bfa2bf1' | Get-VerkadaAccessUserReport
This will get the Acces user object for userId c1cb427f-9ef4-4800-95ec-4a580bfa2bf1 and return the access report for that user.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaAccessUserViaGraphql -userId 'c1cb427f-9ef4-4800-95ec-4a580bfa2bf1' | Get-VerkadaAccessUserReport -beautify | Export-Csv ~/Desktop.ACusersReport.csv -NoTypeInformation
This will get the Acces user object for userId c1cb427f-9ef4-4800-95ec-4a580bfa2bf1 and return the access report for that user in a consumeable way for a csv report.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 3
```
Get-VerkadaAccessUserViaGraphql -userId 'c1cb427f-9ef4-4800-95ec-4a580bfa2bf1' | Get-VerkadaAccessUserReport -outReport
This will get the Acces user object for userId c1cb427f-9ef4-4800-95ec-4a580bfa2bf1 and return the access report for that user in a pretty HTML file.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 4
```
Read-VerkadaAccessUsers | Get-VerkadaAccessUserReport -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will get all the Acces user objects in an organization and return the access report for that user.  The org_id and tokens are submitted as parameters in the call.
```

## PARAMETERS

### -user
The Access user object the report will run against

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### -beautify
This is a switch to indicate we're gonna try to make the report prettier

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

### -outReport
This is a switch to indicate we're gonna try to make the report a pretty html

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

### -reportPath
This is the path the pretty html report will attempt to be saved to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserReport.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserReport.md)

