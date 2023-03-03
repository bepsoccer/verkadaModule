---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version:
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

### -userId
{{ Fill userId Description }}

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
{{ Fill groupId Description }}

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
{{ Fill groupName Description }}

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
{{ Fill x_verkada_token Description }}

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
{{ Fill x_verkada_auth Description }}

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
