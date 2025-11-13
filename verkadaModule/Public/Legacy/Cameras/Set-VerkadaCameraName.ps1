function Set-VerkadaCameraName
{
	<#
		.SYNOPSIS
		Set the name of a camera in an organization
		
		.DESCRIPTION
		This function is used to rename a camera or cameras in a Verkada org.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraName.md

		.EXAMPLE
		Set-VerkadaCameraName -camera_id '6fbdcd72-a2ec-4016-9c6f-21553a42c998' -camera_name 'Camera1'
		This will rename camera_id 6fbdcd72-a2ec-4016-9c6f-21553a42c998 to Camera1.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Set-VerkadaCameraName -camera_id '6fbdcd72-a2ec-4016-9c6f-21553a42c998' -camera_name 'Camera1' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will rename camera_id 6fbdcd72-a2ec-4016-9c6f-21553a42c998 to Camera1.   The org_id and tokens are submitted as parameters in the call.
		
		.EXAMPLE
		Set-VerkadaCameraName -serial 'ABCD-123-UNME' -camera_name 'Camera1'
		This will rename the camera with serial ABCD-123-UNME to Camera1.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Import-Csv ./cameras.csv | Set-VerkadaCameraName  
		This will rename all the cameras in the imported CSV which needs to caontain the camera_id(cameraId) or serial and the camera_name(name).  The org_id and tokens are submitted as parameters in the call.
	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The UUID of the camera who's name is being changed
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cameraId')]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias("cameraId")]
		[String]$camera_id,
		#The serial of the camera who's name is being changed
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'serial')]
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cameraId')]
		[String]$serial,
		#The new name for the camera who's name is being changed
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias("name")]
		[String]$camera_name,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter(ParameterSetName = 'serial')]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ($PSCmdlet.ParameterSetName -eq 'serial'){
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
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
	} #end end
} #end function