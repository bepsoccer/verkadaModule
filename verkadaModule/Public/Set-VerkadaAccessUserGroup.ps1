function Set-VerkadaAccessUserGroup{
	<#
		.SYNOPSIS
		Adds an Access user to an Access group in an organization using https://apidocs.verkada.com/reference/putaccessgroupuserviewv1

		.DESCRIPTION
		Add an access user to an access group with the Verkada defined Group ID and either the user defined External ID or the Verkada defined User ID.The Group ID is passed in as query parameter in the URL. The External ID or Verkada User ID(but not both) is passed in the json object in the body of the request.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserGroup.md

		.EXAMPLE
		Set-VerkadaAccessUserGroup -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -groupId '2d64e7de-fd95-48be-8b5c-7a23bde94f52'
		This adds the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 to Access group with groupId 2d64e7de-fd95-48be-8b5c-7a23bde94f52.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaAccessUserGroup -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -groupName 'MyAccessGroup'
		This adds the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 to Access group with groupName MyAccessGroup.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Set-VerkadaAccessUserGroup -externalId 'newUserUPN@contoso.com' -groupId '2d64e7de-fd95-48be-8b5c-7a23bde94f52' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This adds the Access user uwith xternalId newUserUPN@contoso.com to Access group with groupId 2d64e7de-fd95-48be-8b5c-7a23bde94f52.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'groupId')]
	[Alias("Set-VrkdaAcUsrGrp","st-VrkdaAcUsrGrp")]
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
		[Parameter( ValueFromPipelineByPropertyName = $true, ParameterSetName = 'groupId')]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('group_id')]
		[String]$groupId,
		#The name of the group the user should be added to
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'groupName')]
		[String]$groupName,
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
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
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		if ($PSCmdlet.ParameterSetName -eq 'groupName'){
			if ([string]::IsNullOrEmpty($groupName)) {
				Write-Error "groupName is missing but is required!"
				return
			}
			$groupId = Read-VerkadaAccessGroups -org_id $org_id -x_verkada_auth_api $x_verkada_auth_api | Where-Object {$_.name -eq $groupName} | Select-Object -ExpandProperty group_id
			if ([string]::IsNullOrEmpty($groupId)) {
				Write-Error "Group $groupName seems to not exist."
				return
			}
		}
		if ([string]::IsNullOrEmpty($groupId)) {
			Write-Error "groupId is missing but is required!"
			return
		}
		if ([string]::IsNullOrEmpty($externalId) -and [string]::IsNullOrEmpty($userId)){
			Write-Error "Either externalId or userId required"
			return
		}

		$body_params = @{}
		if (!([string]::IsNullOrEmpty($userId))){
			$body_params.user_id = $userId
		} elseif (!([string]::IsNullOrEmpty($externalId))){
			$body_params.external_id = $externalId
		}
		
		$query_params = @{
			'group_id'		= $groupId
		}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $org_id $x_verkada_auth_api $query_params -body_params $body_params -method PUT
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