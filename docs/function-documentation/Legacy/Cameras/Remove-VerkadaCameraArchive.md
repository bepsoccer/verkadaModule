---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaCameraArchive.md
schema: 2.0.0
---

# Remove-VerkadaCameraArchive

## SYNOPSIS
Deletes a camera archive from Command in an organization

## SYNTAX

```
Remove-VerkadaCameraArchive [[-videoExportId] <String>] [[-org_id] <String>] [[-x_verkada_token] <String>]
 [[-x_verkada_auth] <String>] [[-usr] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Deletes a camera archive from Command for the provided organization using the videoExportId.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Remove-VerkadaCameraArchive -videoExportId 'ef31d7b6-ded4-4629-879a-fcdee3b20cd0|1705854973|1705855033|19f5fd45-7845-4852-bff8-82cf62e143a9' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will delete the archive with exportVideoId 'ef31d7b6-ded4-4629-879a-fcdee3b20cd0|1705854973|1705855033|19f5fd45-7845-4852-bff8-82cf62e143a9'.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 2
```
Read-VerkadaCameraArchives | ?{$_.tags -contains "Test"} | Remove-VerkadaCameraArchive
This will delete all the archives that have the "Test" tag applied.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

### -videoExportId
The ID of the archive

```yaml
Type: String
Parameter Sets: (All)
Aliases: archiveId

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

### -x_verkada_token
The Verkada(CSRF) token of the user running the command

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
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
Position: 5
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaCameraArchive.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaCameraArchive.md)

