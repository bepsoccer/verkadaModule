function Set-VerkadaCommandUser{
	<#
		.SYNOPSIS
		Sets the user details for a Command User in an organization using https://apidocs.verkada.com/reference/putuserviewv1

		.DESCRIPTION
		Updates a user's metadata for an organization based on either provided user ID or an external ID set during creation.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaCommandUser.md

		.EXAMPLE
		Set-VerkadaCommandUser -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -firstName 'New' -lastName 'User'
		This will update the Command user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Set-VerkadaCommandUser -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -firstName 'New' -lastName 'User' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_api_key 'sd78ds-uuid-of-verkada-token'
		This will update the Command user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 with the name "New User".  The org_id and tokens are submitted as parameters in the call.
		
		.EXAMPLE
		Set-VerkadaCommandUser -externalId 'newUserUPN@contoso.com' -email 'newUser@contoso.com' 
		This will update the Command user with externalId newUserUPN@contoso.com with the email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaCommandUser -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -externalId 'newUserUPN@contoso.com' 
		This will update the Command user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 to have the new externalId newUPN@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Set-VerkadaCommandUser -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -firstName 'New' -lastName 'User' -email 'newUser@contoso.com -companyName 'Contoso' -department 'sales' -departmentId 'US-Sales' -employeeId '12345' -employeeTitle 'The Closer' -employeeType 'Full Time' -phone '+18165556789'
		This will update the Command user with userId 801c9551-b04c-4293-84ad-b0a6aa0588b3 to the name "New User" and email newUser@contoso.com in department defined as sales with departmnetId of US-Sales with the appropriate companyName, employeeID, employeeTitle, employeeType and phone.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Set-VrkdaCmdUsr","st-VrkdaCmdUsr")]
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
		#The middle name of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('middle_name')]
		[String]$middleName,
		#The last name of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('last_name')]
		[String]$lastName,
		#unique identifier managed externally provided by the consumer
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('external_id')]
		[String]$externalId,
		#The company name of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$companyName,
		#The department of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$department,
		#The departmentId of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('department_id')]
		[String]$departmentId,
		#The employee ID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('employee_id')]
		[String]$employeeId,
		#The employee type of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('employee_type')]
		[String]$employeeType,
		#The title of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$employeeTitle,
		#The main phone number of the user, E.164 format preferred
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern("^\+[1-9]\d{10,14}$")]
		[String]$phone,
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The public API key to be used for calls that hit the public API gateway
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key = $Global:verkadaConnection.token,
		#Switch to write errors to file
		[Parameter()]
		[switch]$errorsToFile
	)
	
	begin {
		$url = "https://api.verkada.com/core/v1/user"
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_api_key)) {throw "x_api_key is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		if ([string]::IsNullOrEmpty($externalId) -and [string]::IsNullOrEmpty($userId)){
			Write-Error "Either externalId or userId required"
			return
		}

		$body_params = @{}
		if (!([string]::IsNullOrEmpty($email))){$body_params.email = $email}
		if (!([string]::IsNullOrEmpty($firstName))){$body_params.first_name = $firstName}
		if (!([string]::IsNullOrEmpty($middleName))){$body_params.middle_name = $middleName}
		if (!([string]::IsNullOrEmpty($lastName))){$body_params.last_name = $lastName}
		if (!([string]::IsNullOrEmpty($companyName))){$body_params.company_name = $companyName}
		if (!([string]::IsNullOrEmpty($department))){$body_params.department = $department}
		if (!([string]::IsNullOrEmpty($departmentId))){$body_params.department_id = $departmentId}
		if (!([string]::IsNullOrEmpty($employeeId))){$body_params.employee_id = $employeeId}
		if (!([string]::IsNullOrEmpty($employeeType))){$body_params.employee_type = $employeeType}
		if (!([string]::IsNullOrEmpty($employeeTitle))){$body_params.employee_Title = $employeeTitle}
		if (!([string]::IsNullOrEmpty($phone))){$body_params.phone = $phone}
		
		$query_params = @{}
		if (!([string]::IsNullOrEmpty($userId))){
			$query_params.user_id = $userId
			if (!([string]::IsNullOrEmpty($externalId))){$body_params.external_id = $externalId}
		} elseif (!([string]::IsNullOrEmpty($externalId))){
			$query_params.external_id = $externalId
		}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $org_id $x_api_key $query_params -body_params $body_params -method PUT
			return $response
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