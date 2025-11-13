function Set-VerkadaCameraCloudBackupSettings{
	<#
		.SYNOPSIS
		This updates the cloud backup settings for a camera using https://apidocs.verkada.com/reference/postcloudbackupviewv1

		.DESCRIPTION
		This function set the cloud back settings for a camera or cameras.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraCloudBackupSettings.md

		.EXAMPLE
		Set-VerkadaCameraCloudBackupSettings -enabled 1 -upload_timeslot '0,86400' -time_to_preserve '25200,68400' -days_to_preserve '1,1,1,1,1,1,1'  -video_to_upload 'ALL' -video_quality 'STANDARD_QUALITY' -camera_id 'cwdfwfw-3f3-cwdf2-cameraId'
		This will set the camera cwdfwfw-3f3-cwdf2-cameraId to use cloud backup with the submitted settings.  The token will be populated from the cache created by Connect-Verkada.
		
		.EXAMPLE
		Set-VerkadaCameraCloudBackupSettings -enabled 1 -upload_timeslot '0,86400' -time_to_preserve '25200,68400' -days_to_preserve '1,1,1,1,1,1,1'  -video_to_upload 'ALL' -video_quality 'STANDARD_QUALITY' -camera_id 'cwdfwfw-3f3-cwdf2-cameraId' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will set the camera cwdfwfw-3f3-cwdf2-cameraId to use cloud backup with the submitted settings.  The token is submitted as a parameter in the call.
		
		.EXAMPLE
		import-Csv ./cameras.csv | Set-VerkadaCameraCloudBackupSettings
		This will set the camera cloud backup settings for all the rows in the CSV which contains all needed params.  The token will be populated from the cache created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Set-VerkadaCloudBackupSettings","Set-VrkdaCamCbStngs","s-VrkdaCamCbStngs")]
	param (
		#The UUID of the camera who's cloud backup seetings are being changed
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$camera_id,
		#Delimited list of booleans indicating which days footage should be uploaded. The elements in the array indicate the following days in order: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday. If value is 1, cloud backup is on for that day. If value is 0, cloud backup is off for that day. For example, 0,1,1,1,1,1,0 means only backup on weekdays.
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidatePattern("[0-1],[0-1],[0-1],[0-1],[0-1],[0-1],[0-1]")]
		[String]$days_to_preserve,
		#Status of cloud backup for a camera. If value is 1, cloud backup is enabled. If value is 0, cloud backup is disabled.
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidatePattern("[0-1]")]
		[int]$enabled,
		#Delimited list of start_time, end_time as timeslot for which a user wants footage to be backed up to the cloud, start_time and end_time are integers indicating seconds to midnight, i.e, 3600,7200 means 1am - 2am
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidatePattern("^(\d|[1-9]\d{1,3}|[1-7]\d{4}|8[0-3]\d{3}|84[0-5]\d{2}|86400),(\d|[1-9]\d{1,3}|[1-7]\d{4}|8[0-3]\d{3}|84[0-5]\d{2}|86400)$")]
		[String]$time_to_preserve,
		#Delimited list of start_time, end_time as timeslot for scheduled time for footage upload, start_time and end_time are integers indicating seconds to midnight, i.e, 3600,7200 means 1am - 2am
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidatePattern("^(\d|[1-9]\d{1,3}|[1-7]\d{4}|8[0-3]\d{3}|84[0-5]\d{2}|86400),(\d|[1-9]\d{1,3}|[1-7]\d{4}|8[0-3]\d{3}|84[0-5]\d{2}|86400)$")]
		[String]$upload_timeslot,
		#Quality of the uploaded video. Two values are possible: STANDARD_QUALITY and HIGH_QUALITY.
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateSet("STANDARD_QUALITY","HIGH_QUALITY")]
		[String]$video_quality,
		#The type of video that is backed-up. Two values are possible: MOTION and ALL.
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateSet("MOTION","ALL")]
		[String]$video_to_upload,
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api,
		#The region of the public API to be used
		[Parameter()]
		[ValidateSet('api','api.eu','api.au')]
		[String]$region='api',
		#Switch to write errors to file
		[Parameter()]
		[switch]$errorsToFile
	)
	
	begin {
		$url = "https://$($region).verkada.com/cameras/v1/cloud_backup/settings"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()

		Write-Warning "Have you backed up your configs first? If not, consider halting and running Get-VerkadaCloudBackupSettings -backup" -WarningAction Inquire
	} #end begin
	
	process {
		$body_params = @{
			'camera_id'					= $camera_id
			'days_to_preserve'	= $days_to_preserve
			'enabled'						= $enabled
			'time_to_preserve'	= $time_to_preserve
			'upload_timeslot'		= $upload_timeslot
			'video_quality'			= $video_quality
			'video_to_upload'		= $video_to_upload
		}

		$query_params = @{
			'camera_id'					= $camera_id
		}
		
		try {
			Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method POST
			return ($body_params | ConvertTo-Json | ConvertFrom-Json)
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force
			$msg = "$($err.StatusCode) - $($err.message)"
			$msg += ": $(($query_params + $body_params) | ConvertTo-Json -Compress)"
			Write-Error $msg
			$myErrors += $msg
			$msg = $null
		}
		catch [VerkadaRestMethodException] {
			$msg = $_.ToString()
			$msg += ": $(($query_params + $body_params) | ConvertTo-Json -Compress)"
			Write-Error $msg
			$myErrors += $msg
			$msg = $null
		}
	} #end process
	
	end {
		if ($errorsToFile.IsPresent){
			if (![string]::IsNullOrEmpty($myErrors)){
				Get-Date | Out-File ./errors.txt -Append
				$myErrors | Out-File ./errors.txt -Append
			}
		}
	} #end end
} #end function