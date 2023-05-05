function Set-VerkadaSitePermissions {
	<#
		.SYNOPSIS
		Sets a group's or user's permission on a site in an organization
		
		.DESCRIPTION
		Sets a group's or user's permission on a site in an organization.  This function takes pipeline paramters making it easy to add mulitple sites via csv with the desired named out of the gate.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaSitePermissions.md

		.EXAMPLE
		Set-VerkadaSitePermissions -cameraGroupId '919dedeb-b3fe-420c-b663-ce44cbfd1c1e' -securityEntityGroupId(userGroupId) '719c81b9-0617-4871-b249-61559dc4684c' -roleKey 'SITE_ADMIN'
		This will give the user group with ID '719c81b9-0617-4871-b249-61559dc4684c' SITE_ADMIN permission on the site with ID '919dedeb-b3fe-420c-b663-ce44cbfd1c1e'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaSitePermissions -cameraGroupId '919dedeb-b3fe-420c-b663-ce44cbfd1c1e' -securityEntityGroupId(userGroupId) '719c81b9-0617-4871-b249-61559dc4684c' -roleKey 'SITE_ADMIN' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will give the user group with ID '719c81b9-0617-4871-b249-61559dc4684c' SITE_ADMIN permission on the site with ID '919dedeb-b3fe-420c-b663-ce44cbfd1c1e'.  The org_id and tokens are submitted as parameters in the call.
	#>

	[CmdletBinding()]
	param (
		#The cameraGroupId of the site who permissions are being set
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('entityId','siteId')]
		[String]$cameraGroupId,
		#The securityEntityGroupId of group or user who's being given permission to the site
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('userGroupId','userId')]
		[String]$securityEntityGroupId,
		#The permission being given
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateSet('SITE_ADMIN','SITE_VIEWER','SITE_VIEWER_LIVE_ONLY')]
		[String]$roleKey,
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		#The UUID of the user account making the request
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$usr = $Global:verkadaConnection.usr
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$url = 'https://vauth.command.verkada.com/security_entity_group/set_permissions'
	} #end begin
	
	process {
		$body = @{
			'securityEntityGroupId' = $securityEntityGroupId
		}
		$body.grant = @()
		$obj = @{
			'entityId'	= $cameraGroupId
			'roleKey'		= $roleKey
		}
		$body.grant += $obj
		$body = $body | ConvertTo-Json -Depth 10 | ConvertFrom-Json

		try {
			$response = Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
			return $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			Write-Host "Permission not added to $cameraGroupId because:  $($err.StatusCode) - $($err.message)" -ForegroundColor Red
			Return
		}
	} #end process
	
	end {
		
	} #end end
} #end function