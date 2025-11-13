function Add-VerkadaAccessSiteAdmin{
	<#
		.SYNOPSIS
		Adds a user as an Access Site Admin to a site

		.DESCRIPTION
		This function will make the provided user/s an Access aite admin for the provided site.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessSiteAdmin.md

		.EXAMPLE
		Add-VerkadaAccessSiteAdmin -userId '2418dd52-0f0a-4cb0-8b4c-ad8432164804' -siteName 'HQ'
		This will add the user with userId 2418dd52-0f0a-4cb0-8b4c-ad8432164804 as an Access site admin for the site name 'HQ'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaAccessSiteAdmin -userId 'e618d19c-cf3a-4070-af41-284fd977759c','5e9455ba-06cd-4c0f-a241-ec3d673d247b','2418dd52-0f0a-4cb0-8b4c-ad8432164804' -siteId '9fb72cf6-e025-418b-86ca-31d6bad05091' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will add the users provided as Access site admins on the site with siteId 9fb72cf6-e025-418b-86ca-31d6bad05091.  The org_id and tokens are submitted as parameters in the call.

		.EXAMPLE
		Read-VerkadaCommandUsers | ?{$_.firstName -eq 'alex' -or $_.firstName -eq 'john'} | Add-VerkadaAccessSiteAdmin -siteName 'HQ'
		This will add the users found as an Access site admin for the site name 'HQ'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The UUID of the user the permission is being granted to
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String[]]$userId,
		#The name of the site being retrieved.  Will be ignored if siteId is present
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$siteName,
		#The UUID of of the site being retrieved
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$siteId,
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
		if ([string]::IsNullOrEmpty($siteId)) {
			if ([string]::IsNullOrEmpty($siteName)) {throw "siteId and siteName are missing but one is required!"}
		}
	} #end begin
	
	process {
		if([string]::IsNullOrEmpty($siteId)){
			$siteId = Get-VerkadaAccessSite -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -Name $siteName | Select-Object -ExpandProperty cameraGroupId
			if([string]::IsNullOrEmpty($siteId)){
				throw "$siteName was not found so no permission set.  Check the name and try again."
			}
		}

		$grants = @()
		$revokes = @()
		foreach ($uId in $userId){
			$grant = @{
				'granteeId'	= $uId
				'roleKey'		= 'SITE_ACCESS_ADMIN'
				'entityId'	= $siteId
			}
			$grant = $grant | ConvertTo-Json -Depth 10 | ConvertFrom-Json
			$grants += $grant
		}

		$payload = @{
			'grant'		= $grants
			'revoke'	= $revokes
		}
		$payload = $payload | ConvertTo-Json -Depth 10 | ConvertFrom-Json

		try {
			$response = Set-VerkadaCommandPermissions $payload -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr
			return $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			throw "$($err.StatusCode) - $($err.message)"
			Return
		}
	} #end process
	
	end {
		
	} #end end
} #end function