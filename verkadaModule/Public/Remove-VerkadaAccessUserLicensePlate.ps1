function Remove-VerkadaAccessUserLicensePlate{
	<#
		.SYNOPSIS
		Removes a license plate credential from an Aceess user in an organization  using https://apidocs.verkada.com/reference/deletelicenseplateviewv1

		.DESCRIPTION
		Deletes a license plate credential from a specified user by providing the user_id or the external_id, the org_id, and the license_plate_number.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaAccessUserLicensePlate.md

		.EXAMPLE
		Remove-VerkadaAccessUserLicensePlate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -licensePlateNumber 'ABC123'
		This will remove license plate ABC123 as a credential from the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3.  The token will be populated from the cache created by Connect-Verkada.
		
		.EXAMPLE
		Remove-VerkadaAccessUserLicensePlate -externalId 'newUserUPN@contoso.com' -licensePlateNumber 'ABC123' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will remove license plate ABC123 as a credential from the Access user with externalId newUserUPN@contoso.com.  The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Remove-VrkdaAcUsrLPR","rm-VrkdaAcUsrLPR")]
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
		#The license plate number of the user credential
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^\w{4,}$')]
		[Alias('license_plate_number')]
		[string]$licensePlateNumber,
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
		$url = "https://$($region).verkada.com/access/v1/credentials/license_plate"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		if ([string]::IsNullOrEmpty($licensePlateNumber)){
			Write-Error "LicensePlateNumber is required"
			return
		}
		if ([string]::IsNullOrEmpty($externalId) -and [string]::IsNullOrEmpty($userId)){
			Write-Error "Either externalId or userId required"
			return
		}

		$body_params = @{}
		
		$query_params = @{
			'license_plate_number'	= $licensePlateNumber.ToUpper()
		}
		if (!([string]::IsNullOrEmpty($userId))){
			$query_params.user_id = $userId
		} elseif (!([string]::IsNullOrEmpty($externalId))){
			$query_params.external_id = $externalId
		}
		
		try {
			Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method DELETE
			$response = $query_params | ConvertTo-Json | ConvertFrom-Json
			$response | Add-Member -NotePropertyName 'status' -NotePropertyValue 'deleted'
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