---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Connect-Verkada.md
schema: 2.0.0
---

# Connect-Verkada

## SYNOPSIS
Gathers needed credentials for Verkada's API Endpoints

## SYNTAX

### apiToken (Default)
```
Connect-Verkada [-org_id] <String> [-x_api_key] <String> [-region <String>] [-noOutput]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ManualTokens
```
Connect-Verkada [-org_id] <String> [[-x_api_key] <String>] [-region <String>] [-userToken] <String>
 [-csrfToken] <String> [-usr] <String> [-manual] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### UnPwd
```
Connect-Verkada [-org_id] <String> [[-x_api_key] <String>] [-region <String>] -userName <String> [-Password]
 [-MyPwd <SecureString>] [-otp <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to authenticate a session and store the needed tokens and org_id for other functions in this module.

## EXAMPLES

### EXAMPLE 1
```
Connect-Verkada '7cd47706-f51b-4419-8675-3b9f0ce7c12d' 'myapiKey-dcwdskjnlnlkj'
This will store the org_id 7cd47706-f51b-4419-8675-3b9f0ce7c12d with the public API key myapiKey-dcwdskjnlnlkj.
```

### EXAMPLE 2
```
Connect-Verkada '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -userName "admin.user@contoso.com" -otp (Get-Otp (Get-Secret -Name myVerkadaOtp -AsPlainText)) -MyPwd (Get-Secret -Name myVerkadaPassword) -x_api_key 'myapiKey-dcwdskjnlnlkj'
This will authenticate user admin.user@contoso.com with a otp token and a secure string variable stored password([secureString]$yourPwd) and upon success store the org_id 7cd47706-f51b-4419-8675-3b9f0ce7c12d and the returned tokens.  This will also store the org_id 7cd47706-f51b-4419-8675-3b9f0ce7c12d with the public API key myapiKey-dcwdskjnlnlkj
```

### EXAMPLE 3
```
Connect-Verkada '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -userName "admin.user@contoso.com" -Password
This will authenticate user admin.user@contoso.com by prompting for the password(stored as a secure string) and upon success store the org_id 7cd47706-f51b-4419-8675-3b9f0ce7c12d and the returned tokens.  This will no longer work for OrgAdmins due to the MFA requirement.
```

### EXAMPLE 4
```
Connect-Verkada '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -userName "admin.user@contoso.com" -otp '123456' -MyPwd $yourPwd(seure string)
This will authenticate user admin.user@contoso.com with a otp token and a secure string variable stored password([secureString]$yourPwd) and upon success store the org_id 7cd47706-f51b-4419-8675-3b9f0ce7c12d and the returned tokens.  This will no longer work for OrgAdmins due to the MFA requirement.
```

### EXAMPLE 5
```
Connect-Verkada '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'myapiKey-dcwdskjnlnlkj' -userName "admin.user@contoso.com" -Password
This will store the org_id 7cd47706-f51b-4419-8675-3b9f0ce7c12d with the public API key myapiKey-dcwdskjnlnlkj and will authenticate user admin.user@contoso.com by prompting for the password(stored as a secure string) and storing the returned tokens.  This will no longer work for OrgAdmins due to the MFA requirement.
```

## PARAMETERS

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: apiToken, ManualTokens
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: UnPwd
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -x_api_key
The public API key to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: apiToken
Aliases: token

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ManualTokens
Aliases: token

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: UnPwd
Aliases: token

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -region
The region of the public API to be used

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Api
Accept pipeline input: False
Accept wildcard characters: False
```

### -userName
The admin user name to be used to obtain needed session and auth tokens

```yaml
Type: String
Parameter Sets: UnPwd
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The switch needed to prompt for admin password to be used to obtain needed session and auth tokens

```yaml
Type: SwitchParameter
Parameter Sets: UnPwd
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MyPwd
The secureString admin password to be used to obtain needed session and auth tokens

```yaml
Type: SecureString
Parameter Sets: UnPwd
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -userToken
The userToken retrieved from Command login

```yaml
Type: String
Parameter Sets: ManualTokens
Aliases: x_verkada_auth

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -csrfToken
The csrfToken retrieved from Command login

```yaml
Type: String
Parameter Sets: ManualTokens
Aliases: x_verkada_token

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -usr
The usr ID retrieved from Command login

```yaml
Type: String
Parameter Sets: ManualTokens
Aliases: x-verkada-user-id

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -manual
The switch to indicate manual token auth

```yaml
Type: SwitchParameter
Parameter Sets: ManualTokens
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -otp
The One Time Password if using 2FA

```yaml
Type: String
Parameter Sets: UnPwd
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -noOutput
The switch to supress output

```yaml
Type: SwitchParameter
Parameter Sets: apiToken
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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Connect-Verkada.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Connect-Verkada.md)

