function Remove-VerkadaLicensePlateOfInterest{
	<#
		.SYNOPSIS
		Deletes a License Plate of Interest for an organization using a license plate number.

		.DESCRIPTION
		This function uses the public api endpoint(https://api.verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest) to delete a License Plate of Interest from the specified organization.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Remove-VerkadaLicensePlateOfInterest.md

		.EXAMPLE
		Remove-VerkadaLicensePlateOfInterest -license_plate 'ABC123'
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Remove-VerkadaLPoI 'ABC123'
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Import-CSV ./file_ofLicenses.csv | Remove-VerkadaLPoI
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Remove-VerkadaLicensePlateOfInterest -license_plate 'ABC123' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Remove-VerkadaLPoI")]
	param (
		#The license plate number of the License Plate of Interest
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$license_plate,
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api
	)

	Begin {
		$url = "https://$($region).verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
	} #end begin
	
	Process {
		$query_params = @{
			'license_plate'		= $license_plate
		}

		try {
		$response = Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -method delete
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