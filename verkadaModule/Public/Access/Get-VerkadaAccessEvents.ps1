function Get-VerkadaAccessEvents{
	<#
		.SYNOPSIS
		Returns Verkada Access Control events using https://apidocs.verkada.com/reference/geteventsviewv1

		.DESCRIPTION
		Returns events for an organization within a specified time range.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessEvents.md

		.EXAMPLE
		Get-VerkadaAccessEvents
		This will return all the access events from 1 hour in the past until present.  The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessEvents -start_time 'January 1, 2025 9:00:00AM' -end_time 'February 8, 2025 10:30:00PM' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will return all the access events from Jan 1 at 9am to Feb 8 at 10:30pm.  The token is submitted as parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Get-VrkdaAcEvnts","gt-VrkdaAcEvnts")]
	param (
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api,
		#The region of the public API to be used
		[Parameter()]
		[ValidateSet('api','api.eu','api.au')]
		[String]$region='api',
		#The optional start time for the date range of events
		[Parameter()]
		[datetime]$start_time,
		#The optional end time for the date range of events
		[Parameter()]
		[datetime]$end_time,
		#The optional event type/s for the events
		[Parameter()]
		[string[]]$event_type,
		#The optional site_id/s for the events
		[Parameter()]
		[string[]]$side_id,
		#The optional device_id/s for the events
		[Parameter()]
		[string[]]$device_id,
		#The optional user_id/s for the events
		[Parameter()]
		[string[]]$user_id,
		#Switch to convert timestamps to local time
		[Parameter()]
		[switch]$toLocalTime,
		#Switch to write errors to file
		[Parameter()]
		[switch]$errorsToFile
	)
	
	begin {
		$url = "https://$($region).verkada.com/events/v1/access"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		$body_params = @{}
		$query_params = @{}

		if (!([string]::IsNullOrEmpty($start_time))){
			$start_time_epoch = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $start_time.ToUniversalTime()).TotalSeconds
			$query_params.start_time = $start_time_epoch
		}
		if (!([string]::IsNullOrEmpty($end_time))){
			$end_time_epoch = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $end_time.ToUniversalTime()).TotalSeconds
			$query_params.end_time = $end_time_epoch
		}
		if (!([string]::IsNullOrEmpty($event_type))){$query_params.event_type = $event_type -join ','}
		if (!([string]::IsNullOrEmpty($site_id))){$query_params.site_ide = $site_id -join ','}
		if (!([string]::IsNullOrEmpty($device_id))){$query_params.device_id = $device_id -join ','}
		if (!([string]::IsNullOrEmpty($user_id))){$query_params.user_id = $user_id -join ','}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method GET -pagination -page_size 200 -propertyName 'events'
			if ($toLocalTime.IsPresent){
				foreach ($e in $response){
					$e.timestamp = (Get-Date -Date ($e.timestamp) -AsUTC).ToLocalTime()
				}
			}
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