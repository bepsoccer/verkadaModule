function Add-VerkadaHelixEvent{
	<#
		.SYNOPSIS
		Creates a Helix event in Commadn using https://apidocs.verkada.com/reference/postvideotaggingeventviewv1

		.DESCRIPTION
		This method can be used to generate a Helix Event in Command. Users will be able to specify the attribute values for each attribute key that was previously defined in the Event Type creation process. To successfully create a Helix Event, users will need to input the associated Camera ID, API Token with Helix permissions, Event Type UID, and the exact event epoch timestamp in milliseconds.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaHelixEvent.md

		.EXAMPLE
		Add-VerkadaHelixEvent -camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc -event_type_uid cf918b16-26cd-4c01-a672-5a91b79311e1 -timeStamp (get-date) -attributes $attributes 
		This will add a new helix event for the current time for the sepcified camera, event ID, and submitted attributes. The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaHelixEvent -camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc -event_type_uid cf918b16-26cd-4c01-a672-5a91b79311e1 -timeStamp '1/1/2025 08:35:00 -06' -attributes $attributes -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will add a new helix event for Jan 1, 2025 at 8:35 AM CST for the sepcified camera, event ID, and submitted attributes. The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Add-VrkdaHlxEvt","a-VrkdaHlxEvt")]
	param (
		#The UUID of the camera who's name is being changed
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias("cameraId")]
		[String]$camera_id,
		#The UID of the event type to be used when creating the event
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$event_type_uid,
		#The the timestamp of the event
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[datetime]$timeStamp,
		#The the epoch time of the event in milliseconds
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias("time_ms")]
		[Int64]$epoch_time,
		#The parameters to be submitted for the event
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[object]$attributes,
		#Boolean if the event should be flagged
		[bool]$flagged=$false,
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
		$url = "https://$($region).verkada.com/cameras/v1/video_tagging/event"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		if ($PSBoundParameters.ContainsKey('epoch_time')){

		} elseif ($PSBoundParameters.ContainsKey('timeStamp')){
			$epoch_time = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $timeStamp.ToUniversalTime()).TotalMilliseconds
		} else {
			throw "timestamp or epoch_time (time_ms) are required"
		}
		$body_params = @{
			'camera_id'				= $camera_id
			'event_type_uid'	= $event_type_uid
			'time_ms'					= $epoch_time
			'attributes'			= $attributes
			'flagged'					= $flagged
		}
		
		$query_params = @{}
		
		try {
			Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method POST
			return "Event created successfully"
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