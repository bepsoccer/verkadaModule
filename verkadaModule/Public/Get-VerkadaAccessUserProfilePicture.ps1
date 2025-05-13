function Get-VerkadaAccessUserProfilePicture{
	<#
		.SYNOPSIS
		Retrieves a profile photo for the specified Access user using https://apidocs.verkada.com/reference/getprofilephotoviewv1

		.DESCRIPTION
		This will download the Access user's, specified by the user_Id or external_Id, current profile picture.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserProfilePicture.md

		.EXAMPLE
		Export-VerkadaAccessUserProfilePicture -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -outPath './MyProfilePics'
		This downloads the Access user's, with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3, picture to ./MyProfilePics/801c9551-b04c-4293-84ad-b0a6aa0588b3.jpg.  The org_id and token will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Export-VerkadaAccessUserProfilePicture -externalId 'newUserUPN@contoso.com' -outPath './MyProfilePics' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This downloads the Access user's, with externalId newUserUPN@contoso.com picture to ./MyProfilePics/newUserUPN.jpg.  The org_id and token are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Get-VrkdaAcUsrPrflPic","g-VrkdaAcUsrPrflPic")]
	param (
		#The UUID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('user_id')]
		[String]$userId,
		#unique identifier managed externally provided by the consumer
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('external_id')]
		[String]$externalId,
		#This is the path the picture/s will attempt to be saved to
		[Parameter()]
		[string]$outPath='./',
		#The flag that states whether to download the original or cropped version
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$original=$false,
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
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
		$url = "https://$($region).verkada.com/access/v1/access_users/user/profile_photo"
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		$body_params = @{}
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

		$query_params = @{
			'original'	= $original
		}

		if (!([string]::IsNullOrEmpty($userId))){
			$query_params.user_id = $userId
			$outFile = Join-Path $outPath "$userId.jpg"
		} elseif (!([string]::IsNullOrEmpty($externalId))){
			$query_params.external_id = $externalId
			$outFile = Join-Path $outPath "$($externalId.TrimEnd().Split('@')[0].replace('.','_')).jpg"
		}
		
		try {
			Invoke-VerkadaRestMethod $url $org_id $x_verkada_auth_api $query_params -method GET -outFile $outFile
			return
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