---
external help file: verkadaModule-help.xml
Module Name: verkadaModule
online version: https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCloudBackupSettings.md
schema: 2.0.0
---

# Get-VerkadaCloudBackupSettings

## SYNOPSIS
Gets a camera's cloud backup settings

## SYNTAX

```
Get-VerkadaCloudBackupSettings [-camera_id] <String> [[-org_id] <String>] [[-x_api_key] <String>] [-backup]
 [<CommonParameters>]
```

## DESCRIPTION
This function will retrieve the cloud backup settings of the camera requested.
The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

## EXAMPLES

### EXAMPLE 1
```
Get-VerkadaCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId"
This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

### EXAMPLE 2
```
Get-VerkadaCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId" -org_id 'deds343-uuid-of-org' -x_api_key 'sd78ds-uuid-of-verkada-token'
This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId.  The org_id and tokens are submitted as parameters in the call.
```

### EXAMPLE 3
```
Get-VerkadaCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId" -backup
This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId and write it to a csv.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
```

## PARAMETERS

### -camera_id
The UUID of the camera who's cloud backup seetings are being retrieved

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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
Position: 2
Default value: $Global:verkadaConnection.org_id
Accept pipeline input: False
Accept wildcard characters: False
```

### -x_api_key
The public API key to be used for calls that hit the public API gateway

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Global:verkadaConnection.token
Accept pipeline input: False
Accept wildcard characters: False
```

### -backup
Switch used to write the retrieved cloud backup settings to a csv. 
This will prompt for the path and file name for the output csv when the backup switch is used

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

[https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCloudBackupSettings.md](https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCloudBackupSettings.md)

