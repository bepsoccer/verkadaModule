function Set-VerkadaAccessUserEmployementDetail
{
	<#
		.SYNOPSIS
		Sets the employment details for an Access User in an organization
		.DESCRIPTION
		This function is used to set the employment details for an Access User in an organization.  While userId is preferable to use this function, email or firstName/lastName can be used to set the details as it will attempt to use the Find-VerkadaUserId function to lookup the userId.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		.EXAMPLE
		Set-VerkadaAccessUserEmployementDetail -userId 'gjg547-uuid-of-user' -employeeId '9999sd' -department 'sales' -departmentId 'salesUS' -employeeTitle 'Account Executive' -companyName 'Contoso'
		This will set the employment details specified in the parameters for the user specified.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		.EXAMPLE
		ASet-VerkadaAccessUserEmployementDetail -userId 'gjg547-uuid-of-user' -employeeId '9999sd' -department 'sales' -departmentId 'salesUS' -employeeTitle 'Account Executive' -companyName 'Contoso' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will set the employment details specified in the parameters for the user specified.  The org_id and tokens are submitted as parameters in the call.
		.EXAMPLE
		Import-Csv ./myUsers.csv |  Set-VerkadaAccessUserEmployementDetail
		This will set the employment details for every row in the csv file which contains userId, employeeId, employeeTitle, department, departmentId, and companyName.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'search')]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The UUID of the user
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'userId')]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$userId,
		#The email address of the user being updated
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'search')]
		[String]$email,
		#The first name of the user being updated
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'search')]
		[String]$firstName,
		#The last name of the user being updated
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'search')]
		[String]$lastName,
		#The employee ID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$employeeId,
		#The title of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$employeeTitle,
		#The department of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$department,
		#The departmentId of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$departmentId,
		#The company name of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$companyName,
		#The UUID of the user account making the request
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$usr = $Global:verkadaConnection.usr,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr_id is missing but is required!"}

		$url = "https://vprovision.command.verkada.com/organization/$org_id/user/employment"
	} #end begin
	
	Process {
		if ($PSCmdlet.ParameterSetName -eq 'search'){
			if (!([string]::IsNullOrEmpty($email))) {
				$userId = Find-VerkadaUserId -email $email -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth | Select-Object -ExpandProperty userId
			} elseif ((!([string]::IsNullOrEmpty($firstName))) -and (!([string]::IsNullOrEmpty($lastName)))) {
				$userId = Find-VerkadaUserId -firstName $firstName -lastName $lastName -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth | Select-Object -ExpandProperty userId
			} else {
				Write-Host "Could not find a userID for email:$email firstName:$firstName lastName:$lastName, no update will be made" -ForegroundColor Red
				Remove-Variable userId -ErrorAction SilentlyContinue
				return
			}

			if ([string]::IsNullOrEmpty($userId)) {
				Write-Host "Could not find a userID for email:$email firstName:$firstName lastName:$lastName, no update will be made" -ForegroundColor Red
				Remove-Variable userId -ErrorAction SilentlyContinue
				return
			}
		}

		$body_params = @{
			"targetUserId"		= $userId
		}
		if (!([string]::IsNullOrEmpty($employeeId))){$body_params.employeeId = $employeeId}
		if (!([string]::IsNullOrEmpty($employeeTitle))){$body_params.employeeTitle = $employeeTitle}
		if (!([string]::IsNullOrEmpty($department))){$body_params.department = $department}
		if (!([string]::IsNullOrEmpty($departmentId))){$body_params.departmentId = $departmentId}
		if (!([string]::IsNullOrEmpty($companyName))){$body_params.companyName = $companyName}
		
		try {Invoke-VerkadaCommandCall $url $org_id $body_params -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			#$err.message
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force
			#$err.StatusCode

			if ($err.message -eq 'User is managed, cannot modify') {
				Write-Host "$($err.StatusCode) - $firstName $lastName $email is a SCIM managed user and cannot be updated directly, use your IdP." -ForegroundColor Red
			} else {
				Write-Host "$($err.StatusCode) - $($err.message)" -ForegroundColor Red
			}
			#Write-Host -ForegroundColor Green $errorMes
		}
	} #end process

	End {
		
	}
} #end function