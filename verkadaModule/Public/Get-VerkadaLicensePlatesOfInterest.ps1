function Get-VerkadaLicensePlatesOfInterest{
	<#
		.SYNOPSIS
		Returns creation time, description, and license plate number for all License Plates of Interest for an organization.

		.DESCRIPTION
		This function uses the public api endpoint(https://api.verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest) to returns creation time, description, and license plate number for all License Plates of Interest for an organization.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaLicensePlatesOfInterest.md

		.EXAMPLE
		Get-VerkadaLicensePlatesOfInterest
		The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaLPoI
		The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaLicensePlatesOfInterest -org_id 'deds343-uuid-of-org' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Get-VerkadaLPoI")]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api
	)
	
	begin {
		$url = "https://api.verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest"
		$page_size = 1000
		$propertyName = 'license_plate_of_interest'
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
	} #end begin
	
	process {
		$response = Invoke-VerkadaRestMethod $url $org_id $x_verkada_auth_api -pagination -page_size $page_size -propertyName $propertyName
	} #end process
	
	end {
		return $response
	} #end end
} #end function