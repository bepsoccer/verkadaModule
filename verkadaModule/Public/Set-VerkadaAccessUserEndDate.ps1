function Set-VerkadaAccessUserEndDate{
	<#
		.SYNOPSIS
		Set's the end date for an Access user's access in an organization using https://apidocs.verkada.com/reference/putaccessenddateviewv1

		.DESCRIPTION
		Given the user defined External ID or Verkada defined User ID (but not both), set the end date for an access users' credentials to become invalid. After this time, all methods of access will be revoked. End date value will be passed as a parameter in a json payload. Returns the updated Access Information Object.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserEndDate.md

		.EXAMPLE
		Set-VerkadaAccessUserEndDate -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -endDate '11/28/2025 08:00 AM'
		This set the Access user's access to end at 8am on Nov 28, 2025 with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 and send an email invite for the Pass app.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Set-VerkadaAccessUserEndDate -externalId 'newUserUPN@contoso.com' -endDate (Get-Date) -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a'
		This set the Access user's access to end immediately since you are specifiying the current date and time -externalId 'newUserUPN@contoso.com'.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Set-VrkdaAcUsrEndDt","st-VrkdaAcUsrEndDt")]
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
		#The Date/Time the user's Access ends
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('end_date')]
		[datetime]$endDate,
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
		$url = "https://api.verkada.com/access/v1/access_users/user/end_date"
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_api_key)) {throw "x_api_key is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		if ([string]::IsNullOrEmpty($endDate)) {throw "endDate is missing but is required!"}
		if ([string]::IsNullOrEmpty($externalId) -and [string]::IsNullOrEmpty($userId)){
			Write-Error "Either externalId or userId required"
			return
		}

		[string]$stringEndDate = [math]::round((New-TimeSpan -Start (Get-Date -Date "01/01/1970") -End (Get-Date $endDate)).TotalSeconds)
		
		$body_params = @{
			'end_date'	= $stringEndDate
		}
		
		$query_params = @{}
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