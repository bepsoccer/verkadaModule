function Export-VerkadaAccessUserProfilePicture{
	<#
		.SYNOPSIS
		Downloads a copy of the current Verkada Access profile picture.

		.DESCRIPTION
		This will download the Access user's, specified by the userId, current profile picture.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Export-VerkadaAccessUserProfilePicture.md

		.EXAMPLE
		Export-VerkadaAccessUserProfilePicture -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -outPath './MyProfilePics'
		This downloads the Access user's, with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3, picture to ./MyProfilePics/801c9551-b04c-4293-84ad-b0a6aa0588b3.jpg.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Find-VerkadaUserId -email 'some.user@contoso.com' | Export-VerkadaAccessUserProfilePicture
		This downloads the Access user's, with email some.user@contoso.com, picture to ./MyProfilePics/801c9551-b04c-4293-84ad-b0a6aa0588b3.jpg.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Export-VerkadaAccessUserProfilePicture -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -outPath './MyProfilePics' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This downloads the Access user's, with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3, picture to ./MyProfilePics/801c9551-b04c-4293-84ad-b0a6aa0588b3.jpg.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Export-VrkdaAcUsrPrflPic","ep-VrkdaAcUsrPrflPic")]
	param (
		#The UUID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('user_id')]
		[String]$userId,
		#This is the path the picture/s will attempt to be saved to
		[Parameter()]
		[string]$outPath='./',
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

		$Body = ''
	} #end begin
	
	process {
		if ([string]::IsNullOrEmpty($userId)){
			Write-Error "userId required"
			return
		}

		$url = "https://vcerberus.command.verkada.com/user/photos/$org_id/$userId/512.jpg"

		function testOutPath {
			param ($folderPath)
			try {
				if([string]::IsNullOrEmpty($folderPath)){Throw "no path provided"}
				Get-ChildItem -Path $folderPath -ErrorAction Stop | Out-Null
				$folderPath = ($folderPath | Resolve-Path).Path
				return $folderPath
			}
			catch {
				Write-Warning $_.Exception.Message
				$folderPath = Read-Host -Prompt 'Please provide a valid folder path for the AC profile picture/s to be saved to.'
				testOutPath $folderPath
			}
		}

		$outPath = testOutPath $outPath
		$outFile = Join-Path $outPath "$userId.jpg"

		try {
			$testPic = Test-VerkadaAccessProfilePictureUrl -userId $userId -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr

			if ($testPic.profilePicture -eq $true){
				Invoke-VerkadaCommandCall $URL $org_id $Body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'GET' -outFile $outFile
				Write-Host "Profile picture exported to $outFile" -ForegroundColor Green
			}
			else {
				Write-Host "No profile picture exists for $userId" -ForegroundColor Red
			}
			
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