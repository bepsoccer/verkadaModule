function Disable-VerkadaAccessUserFaceUnlock{
	<#
		.SYNOPSIS
		Disabled Face Unlock using https://apidocs.verkada.com/reference/deletefaceunlockdisableexternaluserviewv2 or https://apidocs.verkada.com/reference/deletefaceunlockdisableuserviewv2.

		.DESCRIPTION
		Disable face unlock for a user. This will delete their face credential and disable the face unlock access method. Any pending mobile enrollment invitations for this user will also be deleted.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Disable-VerkadaAccessUserFaceUnlock.md

		.EXAMPLE
		Disable-VerkadaAccessUserFaceUnlock -externalId 'newUserUPN@contoso.com'
		This will disable Face Unlock for the user with externalId newUserUPN@contoso.com and will delete the existing face credential..  The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Disable-VerkadaAccessUserFaceUnlock -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -x_verkada_auth_api 'v2_sd78d9verkada-token'
		This will disable Face Unlock for the user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 and will delete the existing face credential.  The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'user_id')]
	[Alias("Disable-VrkdaAcUsrFaceUnlk","d-VrkdaAcUsrFaceUnlk")]
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
				$url = "https://$($region).verkada.com/$($version)/access/external_users/$($externalId)/face_unlock"
				if ([string]::IsNullOrEmpty($externalId)) {throw "externalId is missing but is required!"}
				$ident = $externalId
			}
			'user_id' {
				$url = "https://$($region).verkada.com/$($version)/access/users/$($userId)/face_unlock"
				if ([string]::IsNullOrEmpty($userId)) {throw "userId is missing but is required!"}
				$ident = $userId
			}
		}
		$body_params = @{}
		
		$query_params = @{}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method DELETE
			"Successfully disabled Face Unlock for $($ident) $($response | ConvertTo-Json -Compress)"
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