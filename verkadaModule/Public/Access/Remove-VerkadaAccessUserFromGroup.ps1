function Remove-VerkadaAccessUserFromGroup{
	<#
		.SYNOPSIS
		Removes an Access user from an Access group in an organization using https://apidocs.verkada.com/reference/deleteaccessgroupuserviewv1

		.DESCRIPTION
		Remove an access user from an access group with the Verkada defined group ID and the user defined either by their User ID or their External ID. Both the group ID and the User ID(or External ID) are passed as query parameters in the URL.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaAccessUserFromGroup.md

		.EXAMPLE
		Remove-VerkadaAccessUserFromGroup -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -groupId '2d64e7de-fd95-48be-8b5c-7a23bde94f52'
		This will remove the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 from the group with groupId 2d64e7de-fd95-48be-8b5c-7a23bde94f52.  The token will be populated from the cache created by Connect-Verkada.
		
		.EXAMPLE
		Remove-VerkadaAccessUserFromGroup -externalId 'newUserUPN@contoso.com' -groupId '2d64e7de-fd95-48be-8b5c-7a23bde94f52' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will remove the Access user with externalId newUserUPN@contoso.com from the group with groupId 2d64e7de-fd95-48be-8b5c-7a23bde94f52.  The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Remove-VrkdaAcUsrFrGrp","rm-VrkdaAcUsrFrGrp")]
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
		#The UUID of the group
		[Parameter( ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('group_id')]
		[String]$groupId,
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
		$url = "https://$($region).verkada.com/access/v1/access_groups/group/user"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		if ([string]::IsNullOrEmpty($groupId)){
			Write-Error "groupId is required"
			return
		}
		if ([string]::IsNullOrEmpty($externalId) -and [string]::IsNullOrEmpty($userId)){
			Write-Error "Either externalId or userId required"
			return
		}

		$body_params = @{}
		
		$query_params = @{
			'group_id'		= $groupId
		}
		if (!([string]::IsNullOrEmpty($userId))){
			$query_params.user_id = $userId
		} elseif (!([string]::IsNullOrEmpty($externalId))){
			$query_params.external_id = $externalId
		}
		
		try {
			Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method DELETE
			$response = $query_params | ConvertTo-Json | ConvertFrom-Json
			$response | Add-Member -NotePropertyName 'status' -NotePropertyValue 'removed'
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