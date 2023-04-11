function Get-AddressCheck
{
	<#
		.SYNOPSIS
		Used to verify an address with Google Maps API and retrieve lat/lon
		.DESCRIPTION
		Private function to verify an address with Google Maps API and retrieve lat/lon
	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		#The url for the enpoint to be used
		[Parameter(Mandatory = $true, Position = 0)]
		[String]$address,
		#Google Maps API Key
		[Parameter()]
		[String]$key='AIzaSyBOqayI1MPP1zWM_MiP-Hjq3gR9144jqvM'
	)

	Process {
		$address = $address.Replace(' ','+')
		$uri = 'https://maps.googleapis.com/maps/api/geocode/json'
		$query = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		$query.add('address',$address)
		$query.add('key',$key)
		$uri = [System.UriBuilder]"$uri"
		$uri.Query = $query.ToString()
		$uri = $uri.Uri.OriginalString

		$response = Invoke-RestMethod -Uri $uri -ContentType 'application/json'

		if ($response.results.count -gt 1){
			Write-Host "Multiple similar addresses were found" -ForegroundColor Yellow
			Write-Host "Please select a an address" -ForegroundColor Yellow
			for($i = 0; $i -le $response.results.count; $i++){
				if ($i -eq $response.results.count){
					Write-Host "$($i): None of these"
				} else {
					Write-Host "$($i): $($response.results[$i].formatted_address)"
				}
			}
			$selection = Read-Host -Prompt "Enter the number of the address you want to use"
			return $response.results[$selection]
		} else {
			return $response.results
		}
	} #end process
} #end function