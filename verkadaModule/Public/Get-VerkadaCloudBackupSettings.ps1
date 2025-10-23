function Get-VerkadaCloudBackupSettings
{
	<#
		.SYNOPSIS
		Gets a camera's cloud backup settings
		
		.DESCRIPTION
		This function will retrieve the cloud backup settings of the camera requested.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCloudBackupSettings.md

		.EXAMPLE
		Get-VerkadaCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId"
		This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId.  The token will be populated from the cache created by Connect-Verkada.
		
		.EXAMPLE
		Get-VerkadaCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId" -org_id 'deds343-uuid-of-org' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId.  The token is submitted as a parameter in the call.
		
		.EXAMPLE
		Get-VerkadaCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId" -backup
		This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId and write it to a csv.  The token will be populated from the cache created by Connect-Verkada.
	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		#The UUID of the camera who's cloud backup seetings are being retrieved
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$camera_id,
		#Switch used to write the retrieved cloud backup settings to a csv.  This will prompt for the path and file name for the output csv when the backup switch is used
		[Parameter()]
		[Switch]$backup,
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter(Position = 2)]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api,
		#The region of the public API to be used
		[Parameter()]
		[ValidateSet('api','api.eu','api.au')]
		[String]$region='api',
		#Switch to write errors to file
		[Parameter()]
		[Switch]$backup
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
	
		$url = "https://$($region).verkada.com/cameras/v1/cloud_backup/settings"
		$response = @()
	} #end beging
	
	Process {
		$query_params = @{
			'camera_id' = $camera_id
		}

		$response += Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params
	} #end process

	End {
		if ($backup){
			try {
				$response | Export-Csv -Path (Read-Host 'Enter full path where CSV should be saved with filename')
			} catch {
				Write-Warning 'A valid path and file name is required so the command will now terminate'
				exit
			}
		}
		return $response
	} #end end
} #end function