function Get-VerkadaCameras
{
	<#
		.SYNOPSIS
		Gets all cameras in an organization
		
		.DESCRIPTION
		This function will retrieve the complete list of cameras in an organization.  Upon the first run the camera list will be cached until a new powershell session is initiated, Connect/Disconnect-Verkada is run, or you use the refresh switch.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaCameras.md

		.EXAMPLE
		Get-VerkadaCameras
		This will return all the cameras in the org.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Get-VerkadaCameras -org_id 'deds343-uuid-of-org' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will return all the cameras in the org.  The org_id and tokens are submitted as parameters in the call.
		
		.EXAMPLE
		Get-VerkadaCameras -serial
		This will return the camera information using the serial.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Get-VerkadaCameras -refresh
		This will return all the cameras in the org with the most recent data available from Command.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter(Position = 1)]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api,
		#The serial of the camera you are querying
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 2)]
		[String]$serial,
		#Switch to force a refreshed list of cameras from Command
		[Parameter()]
		[switch]$refresh
	)

	Begin {
		$url = "https://api.verkada.com/cameras/v1/devices"
		$page_size = 200
		$propertyName = 'cameras'
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}

		$response = @()

		if ((!([string]::IsNullOrEmpty($global:verkadaCameras))) -and (!($refresh.IsPresent))) { 
			$cameras = $Global:verkadaCameras
		} else {
			$cameras = Invoke-VerkadaRestMethod $url $org_id $x_verkada_auth_api -pagination -page_size $page_size -propertyName $propertyName
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
	} #end end
} #end function