---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessBadgeToUser.md
schema: 2.0.0
---

# Add-VerkadaAccessBadgeToUser

## SYNOPSIS
Adds a badge to an Access User in an organization

## SYNTAX

### cardNumber (Default)
```
Add-VerkadaAccessBadgeToUser [-org_id <String>] -userId <String> -cardType <String> -cardNumber <String>
 [-facilityCode <String>] [-x_verkada_token <String>] [-x_verkada_auth <String>] [-threads <Int32>]
 [<CommonParameters>]
```

### cardNumberHex
```
Add-VerkadaAccessBadgeToUser [-org_id <String>] -userId <String> -cardType <String> -cardNumberHex <String>
 [-facilityCode <String>] [-x_verkada_token <String>] [-x_verkada_auth <String>] [-threads <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to add a badge to a Verkada access user.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaAccessBadgeToUser -userId 'gjg547-uuid-of-user' -cardType 'HID' -facilityCode 111 -cardNumber 55555
This will add a badge in the HID format with facility code 111 and card number 55555 to the user specified.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaAccessBadgeToUser -userId 'gjg547-uuid-of-user' -cardType 'HID' -facilityCode 111 -cardNumber 55555 -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
This will add a badge in the HID format with facility code 111 and card number 55555 to the user specified.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Import-Csv ./myUserBadges.csv |  Add-VerkadaAccessBadgeToUser
This will add a badge for every row in the csv file which contains userId, cardType, cardNumber(or cardNumberHex), and facilityCode(optional).  The org_id and tokens will be populated from the cached created by Connect-Verkada.
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
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardType
The card type of the card being added

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardNumber
The card number of the card being added

```yaml
Type: String
Parameter Sets: cardNumber
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardNumberHex
The card Number Hex of the card being added

```yaml
Type: String
Parameter Sets: cardNumberHex
Aliases:

Required: True
Position: Named
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessBadgeToUser.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessBadgeToUser.md)

