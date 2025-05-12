---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Test-VerkadaAccessProfilePictureUrl.md
schema: 2.0.0
---

# Test-VerkadaAccessProfilePictureUrl

## SYNOPSIS
Tests to see if the user profile picture URL is valid; i.e.
does the user have a profile picture.

## SYNTAX

```
Test-VerkadaAccessProfilePictureUrl [[-userId] <String>] [[-email] <String>] [[-firstName] <String>]
 [[-lastName] <String>] [[-org_id] <String>] [[-x_verkada_token] <String>] [[-x_verkada_auth] <String>]
 [[-usr] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function will test to see if the user profile picture url returns a 200 or a 404 to determine if the user specified has a profile picture.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Test-VerkadaAccessProfilePictureUrl -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will test to see if a profile picture for the user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 exists.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 2
```
Read-VerkadaCommandUsers | Test-VerkadaAccessProfilePictureUrl 
This will test to see if a profile picture for all the users in a organization exists.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
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

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Test-VerkadaAccessProfilePictureUrl.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Test-VerkadaAccessProfilePictureUrl.md)

