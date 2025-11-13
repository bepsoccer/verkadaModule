function Get-VerkadaCameraCloudBackupSettings{
	<#
		.SYNOPSIS
		Gets a camera's cloud backup settings using https://apidocs.verkada.com/reference/getcloudbackupviewv1

		.DESCRIPTION
		This function will retrieve the cloud backup settings of the camera requested.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCameraCloudBackupSettings.md

		.EXAMPLE
		Get-VerkadaCameraCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId"
		This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId.  The token will be populated from the cache created by Connect-Verkada.
		
		.EXAMPLE
		Get-VerkadaCameraCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId" -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId.  The token is submitted as a parameter in the call.
		
		.EXAMPLE
		Get-VerkadaCameraCloudBackupSettings -camera_id "cwdfwfw-3f3-cwdf2-cameraId" -backup
		This will get the cloud backup settings of camera cwdfwfw-3f3-cwdf2-cameraId and write it to a csv.  The token will be populated from the cache created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Get-VerkadaCloudBackupSettings","Get-VrkdaCamCbStngs","gt-VrkdaCamCbStngs")]
	param (
		#The UUID of the camera who's cloud backup seetings are being retrieved
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$camera_id,
		#Switch used to write the retrieved cloud backup settings to a csv.  This will prompt for the path and file name for the output csv when the backup switch is used
		[Parameter()]
		[Switch]$backup,
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

		$response = @()
	} #end begin
	
	process {
		$body_params = @{}
		
		$query_params = @{
			'camera_id' = $camera_id
		}
		
		try {
			$response += Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method GET
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