function Set-VerkadaCameraOrientation{
	<#
		.SYNOPSIS
		Sets the orientation of a Verkada camera

		.DESCRIPTION
		This will set the orientation of a Verkada camera to Normal, Upside down, Left, or Right.  Note Left and Right are "portraight" views.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraOrientation.md

		.EXAMPLE
		Set-VerkadaCameraOrientation -camera_id '4b822169-4f79-4ade-a4dd-676d39d4e802' -orientation Normal
		This will set the orientation of the camera with cameraId 4b822169-4f79-4ade-a4dd-676d39d4e802 to Normal(180).  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaCameraOrientation -serial 'YRF9-AKGQ-HC3P' -orientation Right -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will set the orientation of the camera with serial YRF9-AKGQ-HC3P to Right(270).  The org_id and tokens are submitted as parameters in the call.

		.EXAMPLE
		Get-VerkadaCameras | Set-VerkadaCameraOrientation -orientation UpsideDown 
		This will set all the cameras in the org to have an orientation of UpsideDown(0).  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Set-VrkdaCamOrnt","VrkdaCamOrnt")]
	param (
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
		#The orientation of the camera
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Normal','UpsideDown','Right','Left')]
		[String]$orientation,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		#The UUID of the user account making the request
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$usr = $Global:verkadaConnection.usr
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$url = 'https://vprovision.command.verkada.com/camera/rotate'
	} #end begin
	
	process {
		if ($PSCmdlet.ParameterSetName -eq 'serial'){
			$camera_id = Get-VerkadaCameras -serial $serial | Select-Object -ExpandProperty camera_id
		}

		if (!([string]::IsNullOrEmpty($orientation))) {
			switch ($orientation) {
				'Normal' { $rotate = "180"}
				'UpsideDown' { $rotate = "0" }
				'Right' { $rotate = "270" }
				'Left' { $rotate = "90" }
			}
		} else{
			throw "Orientation is missing but is required!"
		}

		$body = @{
			'cameraId' 	= $camera_id
			'rotate'		= $rotate
		}
		$body = $body | ConvertTo-Json -Depth 10 | ConvertFrom-Json

		try {
			$response = Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
			return $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			Write-Host "Orientation not changed for $camera_id because:  $($err.StatusCode) - $($err.message)" -ForegroundColor Red
			Return
		}
	} #end process
	
	end {
		
	} #end end
} #end function