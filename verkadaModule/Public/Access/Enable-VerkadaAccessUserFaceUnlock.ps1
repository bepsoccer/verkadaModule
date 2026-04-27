function Enable-VerkadaAccessUserFaceUnlock{
	<#
		.SYNOPSIS
		Enables face unlock for an Access user using https://apidocs.verkada.com/reference/postfaceunlockcopyuserphotoexternaluserviewv2, https://apidocs.verkada.com/reference/postfaceunlockuploadphotoexternaluserviewv2, https://apidocs.verkada.com/reference/postfaceunlockcopyuserphotouserviewv2, and https://apidocs.verkada.com/reference/postfaceunlockuploadphotouserviewv2

		.DESCRIPTION
		Enable face unlock for a user by using their existing profile photo by uploading a new photo. This will create a face credential from the user's profile photo or by providing a photo via uplaod. If the user already has a face credential and overwrite is False, the request will fail. The profile photo must meet quality requirements for face recognition.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Enable-VerkadaAccessUserFaceUnlock.md

		.EXAMPLE
		Enable-VerkadaAccessUserLicensePlate -externalId 'newUserUPN@contoso.com'
		This will enable Face Unlock for the user with externalId newUserUPN@contoso.com using their existing AC profile photo.  The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Enable-VerkadaAccessUserLicensePlate -externalId 'newUserUPN@contoso.com' -imagePath './myPicture.png' -overwrite $true -x_verkada_auth_api 'v2_sd78d9verkada-token'
		This will enable Face Unlock for the user with externalId newUserUPN@contoso.com using the photo specified in the imagePath, ./myPicture.png, and will overwrite the existing face credential if it exists.  The token is submitted as a parameter in the call.

		.EXAMPLE
		Enable-VerkadaAccessUserLicensePlate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3'
		This will enable Face Unlock for the user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 using their existing AC profile photo.  The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Enable-VerkadaAccessUserLicensePlate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -imagePath './801c9551-b04c-4293-84ad-b0a6aa0588b3.png' -overwrite $true -x_verkada_auth_api 'v2_sd78d9verkada-token'
		This will enable Face Unlock for the user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 using the photo specified in the imagePath, ./801c9551-b04c-4293-84ad-b0a6aa0588b3.png, and will overwrite the existing face credential if it exists.  The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'external_profilePhoto')]
	[Alias("Enable-VrkdaAcUsrFaceUnlk","e-VrkdaAcUsrFaceUnlk")]
	param (
		#The UUID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'user_profilePhoto')]
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'user_upload')]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('user_id')]
		[String]$userId,
		#unique identifier managed externally provided by the consumer
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'external_profilePhoto')]
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'external_upload')]
		[ValidateNotNullOrEmpty()]
		[Alias('external_id')]
		[String]$externalId,
		#This is the path the image will be uploaded from
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'user_upload')]
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'external_upload')]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^.*\.(jpg|jpeg|png)$')]
		[string]$imagePath,
		#The flag that states whether to overwrite the existing profile photo
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$overwrite=$false,
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
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		switch ($PSCmdlet.ParameterSetName) {
			'external_profilePhoto' {
				$url = "https://$($region).verkada.com/v2/access/external_users/$($externalId)/face_unlock/copy_user_photo"
				if ([string]::IsNullOrEmpty($externalId)) {throw "externalId is missing but is required!"}

				#check to see if an AC profile photo exists
				if ((Get-VerkadaAccessUser -externalId $externalId -x_verkada_auth_api $x_verkada_auth_api).has_profile_photo){
					$upload = $false
				} else {
					throw "$($externalId) has no current AC profile photo"
				}
			}
			'external_upload' {
				$url = "https://$($region).verkada.com/v2/access/external_users/$($externalId)/face_unlock/upload_photo"
				if ([string]::IsNullOrEmpty($externalId)) {throw "externalId is missing but is required!"}
				if ([string]::IsNullOrEmpty($imagePath)) {throw "imagePath is missing but is required!"}
				$upload = $true

				$form = @{
					file				= Get-Item -Path $imagePath
					'overwrite'	= $overwrite
				}
			}
			'user_profilePhoto' {
				$url = "https://$($region).verkada.com/v2/access/users/$($userId)/face_unlock/copy_user_photo"
				if ([string]::IsNullOrEmpty($userId)) {throw "userId is missing but is required!"}

				#check to see if an AC profile photo exists
				if ((Get-VerkadaAccessUser -userId $userId -x_verkada_auth_api $x_verkada_auth_api).has_profile_photo){
					$upload = $false
				} else {
					throw "$($userId) has no current AC profile photo"
				}
			}
			'user_upload' {
				$url = "https://$($region).verkada.com/v2/access/users/$($userId)/face_unlock/upload_photo"
				if ([string]::IsNullOrEmpty($userId)) {throw "userId is missing but is required!"}
				if ([string]::IsNullOrEmpty($imagePath)) {throw "imagePath is missing but is required!"}
				$upload = $true

				$form = @{
					file				= Get-Item -Path $imagePath
					'overwrite'	= $overwrite
				}
			}
		}

		$body_params = @{}
		
		$query_params = @{}
		
		try {
			if ($upload) {
				$response = Invoke-VerkadaFormCall $url $form -query_params $query_params -x_verkada_auth_api $x_verkada_auth_api -method POST
				return "Successfully uploaded $imagePath to $($response | ConvertTo-Json -Compress)"
			} else {
				$response = Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method POST
				return $response
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
	} #end end
} #end function