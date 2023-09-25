function Add-VerkadaCommandUser{
	<#
		.SYNOPSIS
		Adds a user to Verkada Command using https://apidocs.verkada.com/reference/postuserviewv1

		.DESCRIPTION
		Creates a user in an organization. External ID required.
		Otherwise, the newly created user will contain a user ID which can be used for identification.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCommandUser.md

		.EXAMPLE
		Add-VerkadaCommandUser -firstName 'New' -lastName 'User'
		This will add the Command user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaCommandUser -firstName 'New' -lastName 'User' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a'
		This will add the Command user with the name "New User".  The org_id and tokens are submitted as parameters in the call.
		
		.EXAMPLE
		Add-VerkadaCommandUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' 
		This will add the Command user with the name "New User" and email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaCommandUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -externalId 'newUserUPN@contoso.com'
		This will add the Command user with the name "New User", email newUser@contoso.com, and externalId newUserUPN@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaCommandUser -email 'newUser@contoso.com' 
		This will add the Command user with the email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaCommandUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com -companyName 'Contoso' -department 'sales' -departmentId 'US-Sales' -employeeId '12345' -employeeTitle 'The Closer' -employeeTyoe 'Full Time' -phone '+18165556789'
		This will add the Command user with the name "New User" and email newUser@contoso.com in department defined as sales with departmnetId of US-Sales with the appropriate companyName, employeeID, employeeTitle, employeeType and phone.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Add-VrkdaCmdUsr","Ad-VrkdaCmdUsr")]
	param (
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
		#unique identifier managed externally provided by the consumer.  This will default to email if omitted
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
		[ValidatePattern("^\+?[1-9]\d{1,14}$")]
		[String]$phone,
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
		if ([string]::IsNullOrEmpty($firstName) -and [string]::IsNullOrEmpty($lastName) -and [string]::IsNullOrEmpty($email)){
			Write-Error "At least one of email, firstName, lastName required"
			return
		}
		if ([string]::IsNullOrEmpty($externalId) -and ![string]::IsNullOrEmpty($email)){$externalId = $email}

		$body_params = @{}
		if (!([string]::IsNullOrEmpty($email))){$body_params.email = $email}
		if (!([string]::IsNullOrEmpty($firstName))){$body_params.first_name = $firstName}
		if (!([string]::IsNullOrEmpty($middleName))){$body_params.middle_name = $middleName}
		if (!([string]::IsNullOrEmpty($lastName))){$body_params.last_name = $lastName}
		if (!([string]::IsNullOrEmpty($externalId))){$body_params.external_id = $externalId}
		if (!([string]::IsNullOrEmpty($companyName))){$body_params.company_name = $companyName}
		if (!([string]::IsNullOrEmpty($department))){$body_params.department = $department}
		if (!([string]::IsNullOrEmpty($departmentId))){$body_params.department_id = $departmentId}
		if (!([string]::IsNullOrEmpty($employeeId))){$body_params.employee_id = $employeeId}
		if (!([string]::IsNullOrEmpty($employeeType))){$body_params.employee_type = $employeeType}
		if (!([string]::IsNullOrEmpty($employeeTitle))){$body_params.employee_Title = $employeeTitle}
		if (!([string]::IsNullOrEmpty($phone))){$body_params.phone = $phone}

		$query_params = @{}

		try {
		$response = Invoke-VerkadaRestMethod $url $org_id $x_api_key $query_params -body_params $body_params -method POST
		return $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force
			$msg = "$($err.StatusCode) - $($err.message)"
			$msg += ": $($body_params | ConvertTo-Json -Compress)"
			Write-Error $msg
			$myErrors += $msg
			$msg = $null
		}
		catch [VerkadaRestMethodException] {
			$msg = $_.ToString()
			$msg += ": $($body_params | ConvertTo-Json -Compress)"
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