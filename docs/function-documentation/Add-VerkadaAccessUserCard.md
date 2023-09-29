---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUserCard.md
schema: 2.0.0
---

# Add-VerkadaAccessUserCard

## SYNOPSIS
Creates and adds an Access credential to an Access user in an organization using https://apidocs.verkada.com/reference/postaccesscardviewv1

## SYNTAX

### cardNumber (Default)
```
Add-VerkadaAccessUserCard [-userId <String>] [-externalId <String>] -cardType <String> -cardNumber <String>
 [-facilityCode <String>] [-active <Boolean>] [-org_id <String>] [-x_api_key <String>] [-errorsToFile]
 [<CommonParameters>]
```

### cardNumberHex
```
Add-VerkadaAccessUserCard [-userId <String>] [-externalId <String>] -cardType <String> -cardNumberHex <String>
 [-facilityCode <String>] [-active <Boolean>] [-org_id <String>] [-x_api_key <String>] [-errorsToFile]
 [<CommonParameters>]
```

### cardNumberBase36
```
Add-VerkadaAccessUserCard [-userId <String>] [-externalId <String>] -cardType <String>
 -cardNumberBase36 <String> [-facilityCode <String>] [-active <Boolean>] [-org_id <String>]
 [-x_api_key <String>] [-errorsToFile] [<CommonParameters>]
```

## DESCRIPTION
Create and add an access card for a specified user_id or external_id and org_id.
Card object will be passed in the body of the request as a json.
We require facility code and card number OR card_number_hex OR card_number_base36.
The successful repsonse will be the created credential information.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Add-VerkadaAccessUserCard -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -type 'HID' -facilityCode 111 -cardNumber 55555
This will add a badge in the HID format with facility code 111 and card number 55555 to the user specified.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Add-VerkadaAccessUserCard -externalId 'newUserUPN@contoso.com' -type 'HID' -facilityCode 111 -cardNumber 55555 -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_api_key 'sd78ds-uuid-of-verkada-token'
This will add an Access credential in the HID format with facility code 111 and card number 55555 to the user specified.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Import-Csv ./myUserBadges.csv |  Add-VerkadaAccessUserCard
This will add an Access credential for every row in the csv file which contains userId, type, cardNumber(or cardNumberHex or cardNumberBase36), and facilityCode(optional).  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

### -userId
The UUID of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: user_id

Required: False
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardType
The card type of the credential

```yaml
Type: String
Parameter Sets: (All)
Aliases: type

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardNumber
The card number of the credential

```yaml
Type: String
Parameter Sets: cardNumber
Aliases: card_number

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardNumberHex
The card Number Hex of the credential

```yaml
Type: String
Parameter Sets: cardNumberHex
Aliases: card_number_hex

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardNumberBase36
The card Number in base36 of the credential

```yaml
Type: String
Parameter Sets: cardNumberBase36
Aliases: card_number_base36

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -facilityCode
The facility code of the credential

```yaml
Type: String
Parameter Sets: (All)
Aliases: facility_code

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -active
Bool value specifying if the credential is currently active.
Default value is False.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
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

### -x_api_key
The public API key to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUserCard.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUserCard.md)

