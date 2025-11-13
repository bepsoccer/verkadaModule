function Get-VerkadaAccessSite{
	<#
		.SYNOPSIS
		Gets all the access sites in an organization

		.DESCRIPTION
		Used to retrieve all the access sites in an organization or just the one with the specified name or siteId.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessSite.md

		.EXAMPLE
		Get-VerkadaAccessSite
		This will return all the Access sites in the organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessSite -name 'My New Site'
		This will return the Access sites with the name 'My New Site' in the organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessSite -siteId 'c21efb7f-8329-4886-a89d-d2cc482b01d0'
		This will return the Access sites with the id 'c21efb7f-8329-4886-a89d-d2cc482b01d0' in the organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessSite -name 'My New Site' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will return the Access sites with the name 'My New Site' in the organization.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The name of the site being retrieved
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$name,
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
		[string]$usr = $Global:verkadaConnection.usr,
		#Switch to force site refresh
		[Parameter()]
		[switch]$refresh
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}
	} #end begin
	
	process {
		if(!($global:verkadaAccessSites) -or $refresh.IsPresent){
			Invoke-VerkadaCommandInit | Out-Null
		}
		$accessSites = $global:verkadaAccessSites
		if (!([string]::IsNullOrEmpty($siteId))) {
			$accessSites = $accessSites | Where-Object {$_.cameraGroupId -eq $siteId}
		} elseif (!([string]::IsNullOrEmpty($name))) {
			$accessSites = $accessSites | Where-Object {$_.name -eq $name}
		}

		return $accessSites
	} #end process
	
	end {
		
	} #end end
} #end function