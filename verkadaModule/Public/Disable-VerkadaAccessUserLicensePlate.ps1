function Disable-VerkadaAccessUserLicensePlate{
	<#
		.SYNOPSIS
		Deactivates a license plate credential for an Aceess user in an organization using https://apidocs.verkada.com/reference/putlicenseplatedeactivateviewv1

		.DESCRIPTION
		Given the Verkada defined User ID (OR user defined External ID)and License Plate Number, deactivate a users License Plate Credential. Returns the updated License Plate Object.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Disable-VerkadaAccessUserLicensePlate.md

		.EXAMPLE
		Disable-VerkadaAccessUserLicensePlate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -licensePlateNumber 'ABC123'
		This will deactivate the license plate ABC123 for the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 as a credential.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Disable-VerkadaAccessUserLicensePlate -externalId 'newUserUPN@contoso.com' -licensePlateNumber 'ABC123' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_api_key 'sd78ds-uuid-of-verkada-token'
		This will deactivate the license plate ABC123 for the Access user with externalId newUserUPN@contoso.com as a credential.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Disable-VrkdaAcUsrLPR","d-VrkdaAcUsrLPR")]
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
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The public API key to be used for calls that hit the public API gateway
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key = $Global:verkadaConnection.token,
		#Switch to write errors to file
		[Parameter()]
		[switch]$errorsToFile
	)
	
	begin {
		$url = "https://api.verkada.com/access/v1/credentials/license_plate/deactivate"
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_api_key)) {throw "x_api_key is missing but is required!"}
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
			$response = Invoke-VerkadaRestMethod $url $org_id $x_api_key $query_params -body_params $body_params -method PUT
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