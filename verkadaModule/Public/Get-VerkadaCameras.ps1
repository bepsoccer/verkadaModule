function Get-VerkadaCameras{
	<#
		.SYNOPSIS
		Gets all the cameras and their details using https://apidocs.verkada.com/reference/getcamerainfoviewv1

		.DESCRIPTION
		Returns details of all cameras within the organization. Details returned per camera are name, site, location, model, serial number, camera ID, MAC address, local IP, device retention, extended cloud retention (if any), date camera added to command, firmware update status, camera status, location latitude, location longitude, and location angle (in degrees).
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCameras.md

		.EXAMPLE
		Get-VerkadaCameras
		This will return all the cameras in the org.  The token will be populated from the cache created by Connect-Verkada.
		
		.EXAMPLE
		Get-VerkadaCameras -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will return all the cameras in the org.  The token is submitted as a parameter in the call.
		
		.EXAMPLE
		Get-VerkadaCameras -serial
		This will return the camera information using the serial.  The token will be populated from the cache created by Connect-Verkada.
		
		.EXAMPLE
		Get-VerkadaCameras -refresh
		This will return all the cameras in the org with the most recent data available from Command.  The token will be populated from the cache created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Get-VrkdaCams","gt-VrkdaCams","Read-VerkadaCameras","Read-VrkdaCams","rd-VrkdaCams")]
	param (
		#The serial of the camera you are querying
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$serial,
		#Switch to force a refreshed list of cameras from Command
		[Parameter()]
		[switch]$refresh,
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
		$url = "https://$($region).verkada.com/cameras/v1/devices"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()

		$page_size = 200
		$propertyName = 'cameras'
		$response = @()
	} #end begin
	
	process {
		$body_params = @{}
		$query_params = @{}
		
		try {
			if ((!([string]::IsNullOrEmpty($global:verkadaCameras))) -and (!($refresh.IsPresent))) { 
				$cameras = $Global:verkadaCameras
			} else {
				$cameras = Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -pagination -page_size $page_size -propertyName $propertyName
				$Global:verkadaCameras = $cameras
			}

			if ($serial) {
				$response += $cameras | Where-Object {$_.serial -eq $serial}
			} else {
				$response += $cameras
		}
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
		return $response
	} #end end
} #end function