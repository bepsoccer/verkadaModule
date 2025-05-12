function Set-VerkadaLicensePlateOfInterest{
	<#
		.SYNOPSIS
		Updates a License Plate of Interest for an organization using a specified description and license plate number.

		.DESCRIPTION
		This function uses the public api endpoint(https://api.verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest) to update a License Plate of Interest to the specified organization.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaLicensePlateOfInterest.md

		.EXAMPLE
		Set-VerkadaLicensePlateOfInterest -license_plate 'ABC123' -description 'New License Plate Descriptionv2'
		The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaLPoI 'ABC123' 'New License Plate Descriptionv2'
		The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Import-CSV ./file_ofLicenses_and_Descriptions.csv | Set-VerkadaLPoI
		The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaLicensePlateOfInterest -license_plate 'ABC123' -description 'New License Plate Descriptionv2' -org_id 'deds343-uuid-of-org' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Set-VerkadaLPoI")]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The license plate number of the License Plate of Interest
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$license_plate,
		#The description for the License Plate of Interest
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 1, Mandatory = $true)]
		[String]$description,
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api
	)

	Begin {
		$url = "https://$($region).verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest"
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
	} #end begin
	
	Process {
		$body_params = @{
			'description'			= $description
		}

		$query_params = @{
			'license_plate'		= $license_plate
		}

		try {
		$response = Invoke-VerkadaRestMethod $url $org_id $x_verkada_auth_api $query_params -body_params $body_params -method patch
		return $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			throw "$($err.StatusCode) - $($err.message)"
		}
	} #end process

	End {
	} #end end
} #end function