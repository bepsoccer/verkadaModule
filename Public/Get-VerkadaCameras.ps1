function Get-VerkadaCameras
{
	<#
		.SYNOPSIS
		Gets all cameras in an organization
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(	
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Position = 1)]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key = $Global:verkadaConnection.token,
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 2)]
		[String]$serial,
		[Parameter()]
		[switch]$refresh
	)

	Begin {
		$url = "https://api.verkada.com/cameras/v1/devices"
		$page_size = '100'
		$propertyName = 'cameras'
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_api_key)) {throw "x_api_key is missing but is required!"}

		$response = @()

		if ((!([string]::IsNullOrEmpty($global:verkadaCameras))) -and (!($refresh.IsPresent))) { 
			$cameras = $Global:verkadaCameras
		} else {
			$cameras = Invoke-VerkadaRestMethod $url $org_id $x_api_key -pagination -page_size $page_size -propertyName $propertyName
			$Global:verkadaCameras = $cameras
		}
	} #end begin
	
	Process {
		if ($serial) {
			$response += $cameras | Where-Object {$_.serial -eq $serial}
		} else {
			$response += $cameras
		}
	} #end process

	End {
		return $response
	}
} #end function