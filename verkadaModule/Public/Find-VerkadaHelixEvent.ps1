function Find-VerkadaHelixEvent{
	<#
		.SYNOPSIS
		Finds Helix event using https://apidocs.verkada.com/reference/postvideotaggingeventsearchviewv1

		.DESCRIPTION
		This method can be used to search for either a single or multiple Helix Events that have already been posted to Command. In the return message, the users will be able to see the corresponding attribute keys and attribute values for those specific Helix Events.

		The only required parameters to search for Helix Events is a Verkada API Token with Helix permissions. Users will be returned a complete list of all Helix Events that are currently available in Command. Users can further narrow down their search by adding:

		Camera ID: returns all Helix Events linked to that specific camera or list of cameras.
		Event Type UID: returns all Helix Events that share that specific Event Type UID.
		Start and End Times: returns all Helix Events that have occurred during that time range.
		Attributes Keys and Values: returns all Helix Events that have attributes keys and values matching the user's entered parameters.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Find-VerkadaHelixEvent.md

		.EXAMPLE
		Find-VerkadaHelixEvent -camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc
		This will get the helix events for camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc. The org_id and token will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Find-VerkadaHelixEvent -event_type_uid cf918b16-26cd-4c01-a672-5a91b79311e1 -startTimeStamp '1/1/2025 08:35:00 -06' -endTimeStamp '1/7/2025 17:00:00 -06' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will find the helix events for from Jan 1, 2025 at 8:35 AM CST to Jan 7, 2025 at 5:00 APM CST for the sepcified event ID. The org_id and token are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Find-VrkdaHlxEvt","fd-VrkdaHlxEvt")]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The UUID of the camera who's name is being changed
		[Parameter()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias("cameraId","cameraIds","camera_id")]
		[String[]]$camera_ids,
		#The UID of the event type to be used when creating the event
		[Parameter()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$event_type_uid,
		#The the start timestamp of the events being serached
		[Parameter()]
		[datetime]$startTimeStamp,
		#The the epoch start time of the events being serached in milliseconds
		[Parameter()]
		[Alias("start_time_ms")]
		[Int64]$start_epoch_time,
		#The the end timestamp of the events being serached
		[Parameter()]
		[datetime]$endTimeStamp,
		#The the epoch end time of the events being serached in milliseconds
		[Parameter()]
		[Alias("end_time_ms")]
		[Int64]$end_epoch_time,
		#The attribute filters to be used in the search query
		[Parameter()]
		[object[]]$attribute_filters,
		#The keyword/s to be used in the search query
		[Parameter()]
		[Alias("keyword")]
		[string[]]$keywords,
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
		$url = "https://$($region).verkada.com/cameras/v1/video_tagging/event/search"
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		if (!($PSBoundParameters.ContainsKey('start_epoch_time')) -and $PSBoundParameters.ContainsKey('startTimeStamp')){
			$start_epoch_time = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $startTimeStamp.ToUniversalTime()).TotalMilliseconds
		}
		if (!($PSBoundParameters.ContainsKey('end_epoch_time')) -and $PSBoundParameters.ContainsKey('endTimeStamp')){
			$end_epoch_time = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $endTimeStamp.ToUniversalTime()).TotalMilliseconds
		}

		$body_params = @{
			'flagged'	= $flagged
		}
		
		$query_params = @{}

		#add any of the optional query parameters to the body
		if (!([string]::IsNullOrEmpty($keywords))){$body_params.keywords = $keywords}
		if ($PSBoundParameters.ContainsKey('start_epoch_time') -or $PSBoundParameters.ContainsKey('startTimeStamp')){
			$body_params.start_time_ms = $start_epoch_time
		}
		if ($PSBoundParameters.ContainsKey('end_epoch_time') -or $PSBoundParameters.ContainsKey('endTimeStamp')){
			$body_params.end_time_ms = $end_epoch_time
		}
		if (!([string]::IsNullOrEmpty($camera_ids))){$body_params.camera_ids = $camera_ids}
		if (!([string]::IsNullOrEmpty($event_type_uid))){$body_params.event_type_uid = $event_type_uid}
		if ($PSBoundParameters.ContainsKey('attribute_filters')){$body_params.attribute_filters = $attribute_filters}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $org_id $x_verkada_auth_api $query_params -body_params $body_params -pagination -propertyName events -page_size 100 -method POST 
			return $response
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