function Set-VerkadaCameraSite{
	<#
		.SYNOPSIS
		Sets a camera/s site in Verkada Command

		.DESCRIPTION
		This function is used to move/set the site a particular camera or cameras should be moved into.
		
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCameraSite.md

		.EXAMPLE
		Set-VerkadaCameraSite -camera_id 'd5efe6b9-c1e3-4f86-b6ba-b363f6d937d2' -cameraGroupId '3fed20c9-7316-4019-be6d-8e823b2fd254'
		This adds camera with id 'd5efe6b9-c1e3-4f86-b6ba-b363f6d937d2' to the site with id '3fed20c9-7316-4019-be6d-8e823b2fd254'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaCameraSite -camera_id 'd5efe6b9-c1e3-4f86-b6ba-b363f6d937d2' -cameraGroupId '3fed20c9-7316-4019-be6d-8e823b2fd254' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
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
		[string]$usr = $Global:verkadaConnection.usr,
		#The UUID of the camera who's name is being changed
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cameraId')]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias("cameraId")]
		[String[]]$camera_id,
		#The cameraGroupId of the site who permissions are being set
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('entityId','siteId')]
		[String]$cameraGroupId
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$url = 'https://vprovision.command.verkada.com/camera/site/batch/set'
	} #end begin
	
	process {
		$body = @{
			'destinationSiteId'	= $cameraGroupId
		}
		$cameraIds = @()
		foreach ($cam in $camera_id){
			$cameraIds += $cam
		}
		$body.cameraIds	= $cameraIds
		$body = $body | ConvertTo-Json | ConvertFrom-Json
		
		try {
			$response = Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
			return $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			Write-Host "Permission not added because:  $($err.StatusCode) - $($err.message)" -ForegroundColor Red
			Return
		}
		
	} #end process
	
	end {
		
	} #end end
} #end function