---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version:
schema: 2.0.0
---

# Add-VerkadaAccessUser

## SYNOPSIS
Adds an Access User in an organization

## SYNTAX

### email (Default)
```
Add-VerkadaAccessUser [-org_id <String>] -email <String> [-firstName <String>] [-lastName <String>]
 [-phone <String>] [-role <String>] [-start <DateTime>] [-expiration <DateTime>] [-sendInviteEmail <Boolean>]
 [-cardType <String>] [-cardNumber <String>] [-cardNumberHex <String>] [-facilityCode <String>]
 [-groupId <String[]>] [-groupName <String[]>] [-includeBadge] [-threads <Int32>] [<CommonParameters>]
```

### name
```
Add-VerkadaAccessUser [-org_id <String>] [-email <String>] -firstName <String> -lastName <String>
 [-phone <String>] [-role <String>] [-start <DateTime>] [-expiration <DateTime>] [-sendInviteEmail <Boolean>]
 [-cardType <String>] [-cardNumber <String>] [-cardNumberHex <String>] [-facilityCode <String>]
 [-groupId <String[]>] [-groupName <String[]>] [-includeBadge] [-threads <Int32>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -org_id
{{ Fill org_id Description }}

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

### -email
{{ Fill email Description }}

```yaml
Type: String
Parameter Sets: email
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -firstName
{{ Fill firstName Description }}

```yaml
Type: String
Parameter Sets: email
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -lastName
{{ Fill lastName Description }}

```yaml
Type: String
Parameter Sets: email
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -phone
{{ Fill phone Description }}

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

### -role
{{ Fill role Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ORG_MEMBER
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -start
{{ Fill start Description }}

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -expiration
{{ Fill expiration Description }}

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sendInviteEmail
{{ Fill sendInviteEmail Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cardType
{{ Fill cardType Description }}

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

### -cardNumber
{{ Fill cardNumber Description }}

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

### -cardNumberHex
{{ Fill cardNumberHex Description }}

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

### -facilityCode
{{ Fill facilityCode Description }}

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

### -groupId
{{ Fill groupId Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -groupName
{{ Fill groupName Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -includeBadge
{{ Fill includeBadge Description }}

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

### -threads
{{ Fill threads Description }}

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
