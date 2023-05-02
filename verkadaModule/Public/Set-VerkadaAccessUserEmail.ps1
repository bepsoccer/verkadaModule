function Set-VerkadaAccessUserEmail {
	<#
		.SYNOPSIS
		Sets the Access users' emails
		
		.DESCRIPTION
		This function is used to edit the email address of a non-SCIM Access user.  Currently only users with no emails will this work for.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessUserEmail.md

		.EXAMPLE
		Set-VerkadaAccessUserEmail -userId 'bdae7dbd-54f1-4aff-94ed-0990e1fc56f8' -email 'newEmail@contoso.com'
		This will attempt to set the Access user email of a user with the the userId of 'bdae7dbd-54f1-4aff-94ed-0990e1fc56f8'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Set-VerkadaAccessUserEmail -userId 'bdae7dbd-54f1-4aff-94ed-0990e1fc56f8' -email 'newEmail@contoso.com' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will attempt to set the Access user email of a user with the the userId of 'bdae7dbd-54f1-4aff-94ed-0990e1fc56f8'.   The org_id and tokens are submitted as parameters in the call.
		
		.EXAMPLE
		Import-Csv users.csv | Set-VerkadaAccessUserEmail
		This will attempt to set the Access user email of a the userIds in the csv using the fields "userId,email".  These must be the headers of the data being piped to the function.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>

	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The UUID of the user who's email is being edited
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$userId,
		#The email address of the user being edited
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
		[String]$email,
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

		$url = "https://vcerberus.command.verkada.com/user/email"
	} #end begin
	
	process {
		$body = @{
			'userId' 					= $userId
			'newEmail'				= $email
			'organizationId'	= $org_id
		}
		$body = $body | ConvertTo-Json -Depth 10 | ConvertFrom-Json

		try {
			$response = Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
			return $response.users
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			Write-Host "User $userId : $email not updated because:  $($err.StatusCode) - $($err.message)" -ForegroundColor Red
			Return
		}
	} #end process
	
	end {
		
	} #end end
} #end function