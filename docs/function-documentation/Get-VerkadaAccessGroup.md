---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessGroup.md
schema: 2.0.0
---

# Get-VerkadaAccessGroup

## SYNOPSIS
Gets an Access group in an organization using https://apidocs.verkada.com/reference/getaccessgroupviewv1

## SYNTAX

```
Get-VerkadaAccessGroup [[-groupId] <String>] [[-org_id] <String>] [[-x_verkada_auth_api] <String>]
 [[-region] <String>] [-errorsToFile] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves an access group specified by its Verkada-defined unique identifier(Group ID).
The response is the Access Group Metadata Object for the desired Access Group.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaAccessGroup -groupId '7858d17a-3f72-4506-8532-a4b6ba233c5e'
This will return the Access Group with userId "7858d17a-3f72-4506-8532-a4b6ba233c5e".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaAccessGroup -groupId '7858d17a-3f72-4506-8532-a4b6ba233c5e' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
This will return the Access Group with userId "7858d17a-3f72-4506-8532-a4b6ba233c5e".  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Read-VerkadaAccessGroups | Where-Object {$_.name -eq "Executive Access"} | Get-VerkadaAccessGroup
This will return the Access Group named "Executive Access".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

### -groupId
The UUID of the group

```yaml
Type: String
Parameter Sets: (All)
Aliases: group_id

Required: False
Position: 1
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
Position: 2
Default value: $Global:verkadaConnection.org_id
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -x_verkada_auth_api
The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Global:verkadaConnection.x_verkada_auth_api
Accept pipeline input: False
Accept wildcard characters: False
```

### -region
The region of the public API to be used

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Api
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessGroup.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessGroup.md)

