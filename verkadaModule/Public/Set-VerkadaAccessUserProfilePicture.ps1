function Set-VerkadaAccessUserProfilePicture{
	<#
		.SYNOPSIS
		Adds/replaces an Access user's profile picture in an organization.

		.DESCRIPTION
		This will set the Access user's, specified by the userId, profile picture.  This must be a png or jpeg/jpg format image.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserProfilePicture.md

		.EXAMPLE
		Set-VerkadaAccessUserProfilePicture -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -imagePath './myPicture.jpg'
		This sets the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 to use the picture specified at path ./myPicture.jpg.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaAccessUserProfilePicture -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -imagePath './myPicture.png' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This sets the Access user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 to use the picture specified at path ./myPicture.png.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Set-VrkdaAcUsrPrflPic","s-VrkdaAcUsrPrflPic")]
	param (
		#The UUID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('user_id')]
		[String]$userId,
		#This is the path the image will be uploaded from
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^.*\.(jpg|jpeg|png)$')]
		[string]$imagePath,
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
		[string]$usr = $Global:verkadaConnection.usr
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$url = 'https://vcerberus.command.verkada.com/user/photos/upload'
	} #end begin
	
	process {
		if (!(Test-Path -Path $imagePath -PathType Leaf)){
			Write-Error "$imagePath is not a valid file path"
			return
		}
		if ([string]::IsNullOrEmpty($userId)){
			Write-Error "userId required"
			return
		}

		$fileBytes = [System.IO.File]::ReadAllBytes($imagePath)
		$fileEnc = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($fileBytes)
		$boundary = "WebKitFormBoundary" + [System.Guid]::NewGuid().ToString().Replace("-", "").substring(0, 16)
		$LF = "`r`n"
		$contentType = "multipart/form-data; boundary=----$boundary"

		$file = Get-Item $imagePath
		switch ($file.Extension) {
			'.png' { $imageContentType = 'Content-Type: image/png' }
			Default { $imageContentType = 'Content-Type: image/jpeg' }
		}

		$body = ( 
			"------$boundary",
			"Content-Disposition: form-data; name=`"organizationId`"$LF",
			"$org_id",
			"------$boundary",
			"Content-Disposition: form-data; name=`"userId`"$LF",
			"$userId",
			"------$boundary",
			"Content-Disposition: form-data; name=`"file`"; filename=`"$($file.name)`"",
			"Content-Type: $imageContentType$LF",
			$fileEnc,
			"------$boundary--$LF" 
		) -join $LF

		try {
			Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST' -contentType $contentType
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			Write-Host "$($err.StatusCode) - $($err.message)" -ForegroundColor Red
			Return
		}
	} #end process
	
	end {
		
	} #end end
} #end function