---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaWorkplaceEmployee.md
schema: 2.0.0
---

# Invoke-VerkadaRestMethod

## SYNOPSIS
Used to build an Invoke-RestMethod call for Verkada's private API enpoints

## SYNTAX

### Default (Default)
```
Invoke-VerkadaRestMethod [-url] <String> [-org_id] <String> [-x_api_key] <String> [[-query_params] <Object>]
 [[-body_params] <Object>] [-method <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### UnPwd
```
Invoke-VerkadaRestMethod [-url] <String> [-org_id] <String> [[-body_params] <Object>] [-method <String>]
 -x_verkada_token <String> -x_verkada_auth <String> [-UnPwd] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Pagination
```
Invoke-VerkadaRestMethod [-url] <String> [-org_id] <String> [-x_api_key] <String> [[-query_params] <Object>]
 [[-body_params] <Object>] [-method <String>] [-pagination] -page_size <String> -propertyName <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Private function to build Invoke-RestMethod calls for Verkada's private API enpoints

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -url
The url for the enpoint to be used

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -org_id
The UUID of the organization the user belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -x_api_key
The public API key to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: Default, Pagination
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -query_params
Object containing the query parameters need that will be put into the query string of the uri

```yaml
Type: Object
Parameter Sets: Default, Pagination
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -body_params
The body of the REST call

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -method
HTTP method required

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### -pagination
Switch to enable pagination through records

```yaml
Type: SwitchParameter
Parameter Sets: Pagination
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_size
The page size used for pagination

```yaml
Type: String
Parameter Sets: Pagination
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -propertyName
The property to be used from the returned payload

```yaml
Type: String
Parameter Sets: Pagination
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -x_verkada_token
The Verkada(CSRF) token of the user running the command

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

### -x_verkada_auth
The Verkada Auth(session auth) token of the user running the command

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

### -UnPwd
Switch to indicate username/password auth is required

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
