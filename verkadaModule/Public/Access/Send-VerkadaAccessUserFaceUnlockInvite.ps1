function Send-VerkadaAccessUserFaceUnlockInvite{
	<#
		.SYNOPSIS
		Sends an invite for an Access user to enrol their face to enable Face Unlock using https://apidocs.verkada.com/reference/postfaceunlockinviteexternaluserviewv2 or https://apidocs.verkada.com/reference/postfaceunlockinviteuserviewv2

		.DESCRIPTION
		Enable face unlock for a user by sending them an invitation to enroll their face via mobile device. An email will be sent to the user with a link to complete the enrollment process. If the user already has a face credential and overwrite is False, the request will fail. When overwrite is True, the invitation is sent and the user can upload a new photo which will replace the existing credential.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Send-VerkadaAccessUserFaceUnlockInvite.md

		.EXAMPLE
		Send-VerkadaAccessUserFaceUnlockInvite -externalId 'newUserUPN@contoso.com'
		This will send a Face Unlock invite to the user with externalId newUserUPN@contoso.com.  The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Send-VerkadaAccessUserFaceUnlockInvite -externalId 'newUserUPN@contoso.com' -overwrite $true -x_verkada_auth_api 'v2_sd78d9verkada-token'
		This will send a Face Unlock invite to the user with externalId newUserUPN@contoso.com and will overwrite the existing face credential if it exists.  The token is submitted as a parameter in the call.

		.EXAMPLE
		Send-VerkadaAccessUserFaceUnlockInvite -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -method 'email'
		This will send a Face Unlock invite to the user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 via email only, not the default sms and email.  The token will be populated from the cache created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'user_id')]
	[Alias("Send-VrkdaAcUsrUsrFaceInv","sd-VrkdaAcUsrUsrFaceInv")]
	param (
		#The UUID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'user_id')]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('user_id')]
		[String]$userId,
		#unique identifier managed externally provided by the consumer
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'external_id')]
		[ValidateNotNullOrEmpty()]
		[Alias('external_id')]
		[String]$externalId,
		#The flag that states whether to overwrite the existing profile photo
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$overwrite=$false,
		#The method to send the invite
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateSet('email','sms')]
		[String[]]$method=@('email','sms'),
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api,
		#The region of the public API to be used
		[Parameter()]
		[ValidateSet('api','api.eu','api.au')]
		[String]$region='api',
		#Version designation for which version of the function to use
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('v2')]
		[string]$version='v2',
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
			'external_id' {
				$url = "https://$($region).verkada.com/$($version)/access/external_users/$($externalId)/face_unlock/invite"
				if ([string]::IsNullOrEmpty($externalId)) {throw "externalId is missing but is required!"}
			}
			'user_id' {
				$url = "https://$($region).verkada.com/$($version)/access/users/$($userId)/face_unlock/invite"
				if ([string]::IsNullOrEmpty($userId)) {throw "userId is missing but is required!"}
			}
		}

		$body_params = @{
			'invitation_methods'	= $method
		}
		
		$query_params = @{}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method POST
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