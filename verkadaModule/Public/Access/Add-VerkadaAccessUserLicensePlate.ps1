function Add-VerkadaAccessUserLicensePlate{
	<#
		.SYNOPSIS
		Adds a license plate credential to an Aceess user in an organization using https://apidocs.verkada.com/reference/postlicenseplateviewv1

		.DESCRIPTION
		Add a license plate credential to a user given a specified user_id or external_id and org_id. License plate object will be passed in the body of the request as a json.
		We require a string of 6 alphanumeric values. The License Plate Object is returned.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUserLicensePlate.md

		.EXAMPLE
		Add-VerkadaAccessUserLicensePlate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -licensePlateNumber 'ABC123'
		This will add the license plate ABC123 to the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 as a credential.  The token will be populated from the cache created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaAccessUserLicensePlate -externalId 'newUserUPN@contoso.com' -licensePlateNumber 'ABC123' -name 'Users License Plate' -active $true -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a'
		This will add the license plate ABC123 to the Access user with externalId newUserUPN@contoso.com as a credential and mark it active.  The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Add-VrkdaAcUsrLPR","a-VrkdaAcUsrLPR")]
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
		#The name of the license plate credential; will default to the plate number
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]$name,
		#Bool value specifying if the license plate credential is currently active. Default value is False.
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$active=$true,
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

		$body_params = @{
			'license_plate_number'	= $licensePlateNumber.ToUpper()
			'active'								= $active
		}
		if (!([string]::IsNullOrEmpty($name))){$body_params.name = $name}
		
		$query_params = @{}
		if (!([string]::IsNullOrEmpty($userId))){
			$query_params.user_id = $userId
		} elseif (!([string]::IsNullOrEmpty($externalId))){
			$query_params.external_id = $externalId
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