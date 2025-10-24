function Add-VerkadaCameraLicensePlateOfInterest{
	<#
		.SYNOPSIS
		Creates a License Plate of Interest for an organization using a specified description and license plate number using https://apidocs.verkada.com/reference/postlicenseplateofinterestviewv1

		.DESCRIPTION
		Creates a License Plate of Interest for an organization using a specified description and license plate number.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCameraLicensePlateOfInterest.md

		.EXAMPLE
		Add-VerkadaCameraLicensePlateOfInterest -license_plate 'ABC123' -description 'New License Plate'
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaLPoI 'ABC123' 'New License Plate'
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Import-CSV ./file_ofLicenses_and_Descriptions.csv | Add-VerkadaLPoI
		The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaCameraLicensePlateOfInterest -license_plate 'ABC123' -description 'New License Plate' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Add-VerkadaLicensePlateOfInterest","Add-VerkadaLPoI","Add-VrkdaLPoI","a-VrkdaLPoI")]
	param (
		#The license plate number of the License Plate of Interest
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$license_plate,
		#The description for the License Plate of Interest
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 1, Mandatory = $true)]
		[String]$description,
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
		$url = "https://$($region).verkada.com/cameras/v1/analytics/lpr/license_plate_of_interest"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		$body_params = @{
			'description'			= $description
			'license_plate'		= $license_plate
		}
		
		$query_params = @{}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method POST
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