---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Unlock-VerkadaAccessDoor.md
schema: 2.0.0
---

# Unlock-VerkadaAccessDoor

## SYNOPSIS
This function unlocks a Verkada Access door

## SYNTAX

```
Unlock-VerkadaAccessDoor [-doorId] <String> [-org_id <String>] [-x_verkada_token <String>]
 [-x_verkada_auth <String>] [-usr <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This will unlock a Verkada Access door using the provided doorId for the unlock period of time defined on the door.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Unlock-VerkadaAccessDoor -doorId '0c81dca6-8fe9-40fa-b924-f3d07e920b6b'
Unlocks the door with ID 0c81dca6-8fe9-40fa-b924-f3d07e920b6b.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Unlock-VerkadaAccessDoor -doorId '0c81dca6-8fe9-40fa-b924-f3d07e920b6b' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
Unlocks the door with ID 0c81dca6-8fe9-40fa-b924-f3d07e920b6b.  The org_id and tokens are submitted as parameters in the call.
```

## PARAMETERS

### -doorId
The UUID of the door being unlocked

```yaml
Type: String
Parameter Sets: (All)
Aliases: door_id

Required: True
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
Position: Named
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Unlock-VerkadaAccessDoor.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Unlock-VerkadaAccessDoor.md)

