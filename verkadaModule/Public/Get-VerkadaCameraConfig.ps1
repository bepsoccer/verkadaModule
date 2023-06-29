function Get-VerkadaCameraConfig{
	<#
		.SYNOPSIS
		Retrieves the camera config and feature settings present in Command for the specified cameraId.

		.DESCRIPTION
		This function will use the front-end API to retieve the features enabled for a given cameraId, the config options present on the front-end, and any notes present on the camera.  An array of cameraId's can be piped to this command to facilitate faaster retrieval.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCameraConfig.md

		.EXAMPLE
		Get-VerkadaCameraConfig -cameraId '6fbdcd72-a2ec-4016-9c6f-21553a42c998'
		This will retieve the config information for the camera with Id 6fbdcd72-a2ec-4016-9c6f-21553a42c998.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaCameras | Get-VerkadaCameraConfig
		This will retieve the config information for all of the camerass present in the given organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Import-Csv ./cams.csv | Get-VerkadaCameraConfig
		This will retieve the config information for all of the cameraId's present in the given CSV.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaCameraConfig -cameraId '6fbdcd72-a2ec-4016-9c6f-21553a42c998' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_api_key 'sd78ds-uuid-of-verkada-token' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will retieve the config information for the camera with Id 6fbdcd72-a2ec-4016-9c6f-21553a42c998.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The UUID of the camera who's config seetings are being retrieved
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('camera_Id')]
		[String]$cameraId,
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
		[string]$usr = $Global:verkadaConnection.usr,
		#The public API key to be used for calls that hit the public API gateway
		[Parameter(Position = 1)]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key = $Global:verkadaConnection.token,
		#The size of the batch of camera Ids to process in a single call
		[Parameter()]
		[Int]$batchSize = 100
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_api_key)) {throw "x_api_key is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$configURL = 'https://vdeviceconfig.command.verkada.com/user/camera/config/get'
		$featureURL = 'https://vdeviceconfig.command.verkada.com/user/camera/feature/get'
		$cameraNotesURL = 'https://vprovision.command.verkada.com/device/notes/get'
		$lowBandURL = 'https://vprovision.command.verkada.com/camera/batch/get_low_bandwidth_mode'

		$cameraIds = @()
		$cameraConfigs = @()
	} #end begin
	
	process {
		$cameraIds += $cameraId
		
	} #end process
	
	end {
		if ($batchSize -gt $cameraIds.count){
			$batchSize = $cameraIds.count
		}
		$batches = [System.Collections.ArrayList]::new()
		for ($i = 0; $i -lt $cameraIds.Count; $i += $batchSize) {
				if (($cameraIds.Count - $i) -gt ($batchSize - 1)) {
						$batches.add($cameraIds[$i..($i + ($batchSize - 1))]) | Out-Null
				}
				else {
						$batches.add($cameraIds[$i..($cameraIds.Count - ($batchSize - 1))]) | Out-Null
				}
		}

		foreach ($batch in $batches){
			$configBody = @{
				"cameraIds"		= $batch
				"params"			= @("static-ip.enabled","static-ip.gateway","static-ip.ip","static-ip.netmask","static-ip.primary-dns","static-ip.secondary-dns","stream-configs.vda.person-crowd-detection-threshold","stream-configs.vda.vehicle-crowd-detection-threshold","accelerometer-config.tamper-low-sensitivity","accelerometer-config.enable-tamper-detect","system-config.update-window-schedule","camera-config.privacy-mask-enable", "camera-config.privacy-mask", "storage-manager.highres-jpeg", "stream-configs.vda.person-crowd-detection-threshold","stream-configs.vda.vehicle-crowd-detection-threshold")
			}

			$featureBody = @{
				"cameraIds"		= $batch
				"params"			= @("people-history","person-attributes","face-detection","object-tracking","vehicle-history","license-plate-recognition")
			}
			$cameraNotesBody = @{
				"deviceIds"		= $batch
			}
			$lowBandBody = @{
				"cameraIds"		= $batch
			}

			try {
				$configs = Invoke-VerkadaCommandCall $configURL $org_id $configBody -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
				$features = Invoke-VerkadaCommandCall $featureURL $org_id $featureBody -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
				$cameraNotes = Invoke-VerkadaCommandCall $cameraNotesURL $org_id $cameraNotesBody -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
				$lowBand = Invoke-VerkadaCommandCall $lowBandURL $org_id $lowBandBody -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'

				$configs = ConvertFrom-PropertylessJson $configs 'cameraId'
				$features = ConvertFrom-PropertylessJson $features 'cameraId'
				$lowBand = ConvertFrom-PropertylessJson $lowBand 'cameraId'

				$combined = @()
				foreach ($feature in $features){
					$config = $configs | Where-Object {$_.cameraId -eq $feature.cameraId}
					$temp = Merge-Objects $config $feature
					$temp | Add-Member -NotePropertyName 'system-config.low-bandwidth-mode' -NotePropertyValue ($lowBand | Where-Object {$_.cameraId -eq $temp.cameraId}).'system-config.low-bandwidth-mode'
					$temp | Add-Member -NotePropertyName 'notes' -NotePropertyValue $cameraNotes.($temp.cameraId)
					$temp | Add-Member -NotePropertyName 'name' -NotePropertyValue (Get-VerkadaCameras | Where-Object {$_.camera_id -eq $temp.cameraId} | Select-Object -ExpandProperty 'name')
					$combined += $temp
				}
				$cameraConfigs += $combined
			}
			catch [Microsoft.PowerShell.Commands.HttpResponseException] {
				$err = $_.ErrorDetails | ConvertFrom-Json
				$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
				$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

				Write-Host "$($err.StatusCode) - $($err.message)" -ForegroundColor Red
				Return
			}
		}

		return $cameraConfigs
	} #end end
} #end function