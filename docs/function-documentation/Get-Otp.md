---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-Otp.md
schema: 2.0.0
---

# Get-Otp

## SYNOPSIS
Time-base One-Time Password Algorithm (RFC 6238)

## SYNTAX

```
Get-Otp [-SECRET] <Object> [[-LENGTH] <Object>] [[-WINDOW] <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This is an implementation of the RFC 6238 Time-Based One-Time Password Algorithm draft based upon the HMAC-based One-Time Password (HOTP) algorithm (RFC 4226).
This is a time based variant of the HOTP algorithm providing short-lived OTP values.

## EXAMPLES

### EXAMPLE 1
```
Get-Otp MySecretTotpKey
```

## PARAMETERS

### -SECRET
{{ Fill SECRET Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LENGTH
{{ Fill LENGTH Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 6
Accept pipeline input: False
Accept wildcard characters: False
```

### -WINDOW
{{ Fill WINDOW Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 30
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
Version:        1.0
Author:         Jon Friesen
Creation Date:  May 7, 2015
Purpose/Change: Provide an easy way of generating OTPs

## RELATED LINKS

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-Otp.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-Otp.md)

