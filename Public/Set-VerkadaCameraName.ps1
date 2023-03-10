function Set-VerkadaCameraName
{
	<#
		.SYNOPSIS
		Set the name of a camera in an organization
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cameraId')]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias("cameraId")]
		[String]$camera_id,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'serial')]
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cameraId')]
		[String]$serial,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias("name")]
		[String]$camera_name,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		[Parameter(ParameterSetName = 'serial')]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key = $Global:verkadaConnection.token
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ($PSCmdlet.ParameterSetName -eq 'serial'){
			if ([string]::IsNullOrEmpty($x_api_key)) {throw "x_api_key is missing but is required!"}
		}
		
		$url = "https://vprovision.command.verkada.com/camera/name/set"
		$response = @()
	} #end begin
	
	Process {
		if ($PSCmdlet.ParameterSetName -eq 'serial'){
			$camera_id = Get-VerkadaCameras -serial $_.serial | Select-Object -ExpandProperty camera_id
		}

		$body_params = @{
			"cameraId"				= $camera_id
			"name"						= $camera_name
		}
		
		$res = Invoke-VerkadaRestMethod $url $org_id $body_params -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -Method 'POST' -UnPwd
		$response += $res.cameras
	} #end process

	End {
		return $response
	}
} #end function