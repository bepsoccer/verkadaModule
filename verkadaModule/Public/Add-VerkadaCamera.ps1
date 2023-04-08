function Add-VerkadaCamera {
	<#
		.SYNOPSIS
		Adds a camera to an organization
		
		.DESCRIPTION
		Add

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCamera.md

		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User'
		This will add the access user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will add the access user with the name "New User".  The org_id and tokens are submitted as parameters in the call.
	#>

	[CmdletBinding()]
	Param (
		#The serial of the camera being added
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[String]$serial,
		#The name of the camera being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias("serialNumber")]
		[String]$name,
		#The siteId(camerGroupId) of the site the camera will be added to
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias("cameraGroupId")]
		[String]$siteId,
		#The location(address) of the camera being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias("address")]
		[String]$location,
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		#The UUID of the user account making the request
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$usr = $Global:verkadaConnection.usr
	)
	
	begin {
		$batch = @()
		$batches = @()
	} #end begin
	
	process {
		#get location fields
		$loc = @{}
		#test submitted address and retrieve lat/lon
		if ([string]::IsNullOrEmpty($location)){
			$location = '405 E 4th Ave, San Mateo, CA 94401, USA'
		}
		$addr = Get-AddressCheck $location
		if ([string]::IsNullOrEmpty($addr)){
			$addr = Get-AddressCheck '405 E 4th Ave, San Mateo, CA 94401, USA'
		}
		$loc.label = $addr.formatted_address
		$loc.lat = $addr.geometry.location.lat
		$loc.lon = $addr.geometry.location.lng
		$loc = $loc | ConvertTo-Json -Depth 10 | ConvertFrom-Json
		Remove-Variable -Name 'addr' -ErrorAction SilentlyContinue

		#test camera serial
		$batchInfoUri = "https://vnetsuite.command.verkada.com/device/batch/information"
		$batchInfoSerial = @($serial)
		$batchInfoBody = @{'serialNumbers'	= $batchInfoSerial} | ConvertTo-Json | ConvertFrom-Json
		try {
			$batchInfo = Invoke-VerkadaCommandCall $batchInfoUri $org_id $batchInfoBody -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			if ($err.message -eq 'Error looking up serials in vProvision: Unknown error') {
				Write-Host "Camera($serial) is already claimed so it can't be added" -ForegroundColor Red
				Return
			} else {
				Write-Host "$($err.StatusCode) - $($err.message)" -ForegroundColor Red
				Return
			}
		}
		if ($batchInfo.devices[0].registered){
			Write-Host "Camera($serial) is already claimed so it can't be added" -ForegroundColor Red
			Return
		}
		if ($batchInfo.devices[0].deviceType -ne 'camera'){
			Write-Host "Serial($serial) is type:$($batchInfo.devices[0].deviceType) so it can't be added with this function" -ForegroundColor Red
			Return
		}
		#get all the camera fields
		$b = @{}
		$b.serialNumber = $serial
		if ([string]::IsNullOrEmpty($name)){
			$name = "New Camera($serial)"
		}
		$b.name = $name
		$b.cameraGroupId = $siteId
		$b.location = $loc
		$b.deferUpdate = $false
		$b = $b | ConvertTo-Json -Depth 10 | ConvertFrom-Json

		#add cameras to batches
		if ($batch.count -lt 10) {
			$batch += $b
		} else {
			$a = @{}
			$a.cameras = $batch
			$a = $a | ConvertTo-Json -Depth 10 | ConvertFrom-Json
			$batches += $a
			$batch = @()
			$batch += $b
		}
	} #end process
	
	end {
		#add cameras to final batch
		$a = @{}
		$a.cameras = $batch
		$a = $a | ConvertTo-Json -Depth 10 | ConvertFrom-Json
		$batches += $a
		
		#Write-Warning "There are $($batches.count) batches"
		#iterate through batches
		foreach ($batch in $batches) {
			#create JSON payload for batch
			$c = @{}
			$c.organizationId = $org_id
			$c.cameras = $batch.cameras
			$body = $c | ConvertTo-Json -Depth 10 | ConvertFrom-Json

			#send camera creation call
			$url = 'https://vprovision.command.verkada.com/camera/init/batch'
			try {
				$response = Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
				$response
			}
			catch [Microsoft.PowerShell.Commands.HttpResponseException] {
				$err = $_.ErrorDetails | ConvertFrom-Json
				$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
				$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

				Write-Host "$($c.cameras)" -ForegroundColor Red
				Write-Host "Cameras not added because:  $($err.StatusCode) - $($err.message)" -ForegroundColor Red
				Return
			}
		}
	} #end end
} #end function