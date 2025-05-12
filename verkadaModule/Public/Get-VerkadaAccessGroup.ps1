function Get-VerkadaAccessGroup{
	<#
		.SYNOPSIS
		Gets an Access group in an organization using https://apidocs.verkada.com/reference/getaccessgroupviewv1

		.DESCRIPTION
		Retrieves an access group specified by its Verkada-defined unique identifier(Group ID). The response is the Access Group Metadata Object for the desired Access Group.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessGroup.md

		.EXAMPLE
		Get-VerkadaAccessGroup -groupId '7858d17a-3f72-4506-8532-a4b6ba233c5e'
		This will return the Access Group with userId "7858d17a-3f72-4506-8532-a4b6ba233c5e".  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessGroup -groupId '7858d17a-3f72-4506-8532-a4b6ba233c5e' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will return the Access Group with userId "7858d17a-3f72-4506-8532-a4b6ba233c5e".  The org_id and tokens are submitted as parameters in the call.

		.EXAMPLE
		Read-VerkadaAccessGroups | Where-Object {$_.name -eq "Executive Access"} | Get-VerkadaAccessGroup
		This will return the Access Group named "Executive Access".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Get-VrkdaAcGrp","gt-VrkdaAcGrp")]
	param (
		#The UUID of the group
		[Parameter( ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('group_id')]
		[String]$groupId,
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
		$url = "https://$($region).verkada.com/access/v1/access_groups/group"
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		if ([string]::IsNullOrEmpty($groupId)){
			Write-Error "Either name or groupId is required"
			return
		}
		$body_params = @{}
		
		$query_params = @{
			'group_id'		= $groupId
		}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $org_id $x_verkada_auth_api $query_params -body_params $body_params -method GET
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