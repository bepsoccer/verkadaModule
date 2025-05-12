function Test-VerkadaAccessProfilePictureUrl{
	<#
		.SYNOPSIS
		Tests to see if the user profile picture URL is valid; i.e. does the user have a profile picture.

		.DESCRIPTION
		This function will test to see if the user profile picture url returns a 200 or a 404 to determine if the user specified has a profile picture.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Test-VerkadaAccessProfilePictureUrl.md

		.EXAMPLE
		Test-VerkadaAccessProfilePictureUrl -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will test to see if a profile picture for the user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 exists.  The org_id and tokens are submitted as parameters in the call.
		
		.EXAMPLE
		Read-VerkadaCommandUsers | Test-VerkadaAccessProfilePictureUrl 
		This will test to see if a profile picture for all the users in a organization exists.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("t-VrkdaAcPrflPicUrl")]
	param (
		#The UUID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('user_id')]
		[String]$userId,
		#The email address of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$email,
		#The first name of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('first_name')]
		[String]$firstName,
		#The last name of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('last_name')]
		[String]$lastName,
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
	} #end begin
	
	process {
		if ([string]::IsNullOrEmpty($userId)){
			Write-Error "userId required"
			return
		}
		$url = "https://vcerberus.command.verkada.com/user/photos/$org_id/$userId/128.jpg"
		$res = @{}
		try {
			Invoke-VerkadaCommandCall -url $url -org_id $org_Id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -method GET -body '' | Out-Null
			$res.userId = $userId
			$res.email = $email
			$res.firstName = $firstName
			$res.lastName = $lastName
			$res.profilePicture = $true

			$response = $res | ConvertTo-Json -Depth 100 | ConvertFrom-Json
			return $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {	
			$res.userId = $userId
			$res.email = $email
			$res.firstName = $firstName
			$res.lastName = $lastName
			$res.profilePicture = $false

			$response = $res | ConvertTo-Json -Depth 100 | ConvertFrom-Json
			return $response
		}
		catch {
			$_.Exception
		}
	} #end process
	
	end {
		
	} #end end
} #end function