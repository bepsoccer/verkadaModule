function Add-VerkadaAccessUserMfaCode{
	<#
		.SYNOPSIS
		Adds a mfa code credential to a user using https://apidocs.verkada.com/reference/postmfacodeviewv1

		.DESCRIPTION
		Adds a mfa code credential to a user given a specified user_id or external_id and org_id. MFA code object will be passed in the body of the request as a json.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessMfaCode.md

		.EXAMPLE
		Add-VerkadaAccessUserMfaCode -mfaCode '9567' -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3'
		This adds the MFA code 9567 to the Access user's profile with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3. The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaAccessUserMfaCode -mfaCode '9567' -externalId 'newUserUPN@contoso.com' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This adds the MFA code 9567 to the Access user's profile with externalId newUserUPN@contoso.com. The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Add-VrkdaAcUsrMfaCd","a-VrkdaAcUsrMfaCd")]
	param (
		#The UUID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('user_id')]
		[String]$userId,
		#unique identifier managed externally provided by the consumer
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('external_id')]
		[String]$externalId,
		#The Access MFA code
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^\d{4,16}$')]
		[Alias('mfa_code','code')]
		[string]$mfaCode,
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
		$url = "https://$($region).verkada.com/access/v1/credentials/mfa_code"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		if ([string]::IsNullOrEmpty($mfaCode)) {
			Write-Error "mfaCode is missing but is required!"
			return
		}

		$body_params = @{
			'code'	= $mfaCode
		}
		
		$query_params = @{}
		if (!([string]::IsNullOrEmpty($externlId))){
			$query_params.externl_id = $externlId
		} elseif (!([string]::IsNullOrEmpty($userId))){
			$query_params.user_id = $userId
		} else {
			Write-Error "Either externalId or userId required"
			return
		}
		
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