function Set-VerkadaHelixEvent{
	<#
		.SYNOPSIS
		Updates a Helix event using https://apidocs.verkada.com/reference/patchvideotaggingeventviewv1

		.DESCRIPTION
		This method can be used to update a Helix Event that has already been posted to Command. This is especially useful if a user needs to add an additional attribute key to the existing event, along with its new corresponding value. To successfully update a Helix Event, users will need to input the associated Camera ID, API Token with Helix permissions, Event Type UID, exact event epoch time in milliseconds, as well as the new attribute key and attribute value that is being updated.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaHelixEvent.md

		.EXAMPLE
		Get-VerkadaHelixEvent -camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc -event_type_uid cf918b16-26cd-4c01-a672-5a91b79311e1 -timeStamp '1/1/2025 08:35:00 -06' -attributes $attributes
		This will get the helix event for Jan 1, 2025 at 8:35 AM CST for the sepcified camera, event ID, and submitted attributes. The org_id and token will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaHelixEvent -camera_id 6b8731d7-d991-4206-ba71-b5446fa617fc -event_type_uid cf918b16-26cd-4c01-a672-5a91b79311e1 -timeStamp '1/1/2025 08:35:00 -06' -attributes $attributes -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will get the helix event for Jan 1, 2025 at 8:35 AM CST for the sepcified camera, event ID, and submitted attributes. The org_id and token are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Set-VrkdaHlxEvt","st-VrkdaHlxEvt")]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The UUID of the camera who's name is being changed
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias("cameraId")]
		[String]$camera_id,
		#The UID of the event type to be used when creating the event
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$event_type_uid,
		#The the epoch time of the event
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[datetime]$timeStamp,
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
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		$epoch_time = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $timeStamp.ToUniversalTime()).TotalMilliseconds
		$body_params = @{
			'attributes'			= $attributes
			'flagged'					= $flagged
		}
		
		$query_params = @{
			'camera_id'				= $camera_id
			'event_type_uid'	= $event_type_uid
			'time_ms'					= $epoch_time
		}
		
		try {
			Invoke-VerkadaRestMethod $url $org_id $x_verkada_auth_api $query_params -body_params $body_params -method PATCH
			return return "Event updated successfully"
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