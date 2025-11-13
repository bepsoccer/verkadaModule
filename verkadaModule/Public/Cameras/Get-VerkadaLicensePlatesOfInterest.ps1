function Get-VerkadaLicensePlatesOfInterest{
	<#
		.SYNOPSIS
		Returns creation time, description, and license plate number for all License Plates of Interest for an organization.

		.DESCRIPTION
		This function uses the public api endpoint(https://api.verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest) to returns creation time, description, and license plate number for all License Plates of Interest for an organization.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaLicensePlatesOfInterest.md

		.EXAMPLE
		Get-VerkadaLicensePlatesOfInterest
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaLPoI
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaLicensePlatesOfInterest -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Get-VerkadaLPoI")]
	param (
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api,
		#Switch to write errors to file
		[Parameter()]
		[switch]$errorsToFile
	)
	
	begin {
		$url = "https://$($region).verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest"
		$page_size = 1000
		$propertyName = 'license_plate_of_interest'
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
	} #end begin
	
	process {
		$response = Invoke-VerkadaRestMethod $url $x_verkada_auth_api -pagination -page_size $page_size -propertyName $propertyName
	} #end process
	
	end {
		return $response
	} #end end
} #end function