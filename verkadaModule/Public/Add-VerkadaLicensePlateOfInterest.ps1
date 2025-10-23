function Add-VerkadaLicensePlateOfInterest{
	<#
		.SYNOPSIS
		Creates a License Plate of Interest for an organization using a specified description and license plate number.

		.DESCRIPTION
		This function uses the public api endpoint(https://api.verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest) to add a License Plate of Interest to the specified organization.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaLicensePlateOfInterest.md

		.EXAMPLE
		Add-VerkadaLicensePlateOfInterest -license_plate 'ABC123' -description 'New License Plate'
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaLPoI 'ABC123' 'New License Plate'
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Import-CSV ./file_ofLicenses_and_Descriptions.csv | Add-VerkadaLPoI
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaLicensePlateOfInterest -license_plate 'ABC123' -description 'New License Plate' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Add-VerkadaLPoI")]
	param (
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
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	Process {
		$body_params = @{
			'description'			= $description
			'license_plate'		= $license_plate
		}

		try {
		$response = Invoke-VerkadaRestMethod $url $x_verkada_auth_api -body_params $body_params -method post
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