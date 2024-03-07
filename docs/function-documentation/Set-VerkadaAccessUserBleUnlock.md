---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserBleUnlock.md
schema: 2.0.0
---

# Set-VerkadaAccessUserBleUnlock

## SYNOPSIS
Activates an Access User's ability to use Bluetooth Unlock using https://apidocs.verkada.com/reference/putactivateblemethodviewv1

## SYNTAX

```
Set-VerkadaAccessUserBleUnlock [[-userId] <String>] [[-externalId] <String>] [-sendPassInvite]
 [[-org_id] <String>] [[-x_api_key] <String>] [-errorsToFile] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Given the user defined External ID or Verkada defined User ID (but not both), activate bluetooth unlock capability for a user.
Response is updated Access Information Object.
The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Set-VerkadaAccessUserBleUnlock -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3'
This will activate the Access user's Bluetooth unlock ability with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Set-VerkadaAccessUserBleUnlock -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -sendPassInvite
This will activate the Access user's Bluetooth unlock ability with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 and send an email invite for the Pass app.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 3
```
Set-VerkadaAccessUserBleUnlock -externalId 'newUserUPN@contoso.com' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_api_key 'sd78ds-uuid-of-verkada-token'
This will activate the Access user's Bluetooth unlock ability with externalId newUserUPN@contoso.com.  The org_id and tokens are submitted as parameters in the call.
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

### -externalId
unique identifier managed externally provided by the consumer

```yaml
Type: String
Parameter Sets: (All)
Aliases: external_id

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sendPassInvite
Switch to also send Pass invite

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
Position: 3
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
Position: 4
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserBleUnlock.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserBleUnlock.md)

