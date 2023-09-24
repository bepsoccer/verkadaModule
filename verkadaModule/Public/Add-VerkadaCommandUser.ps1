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
		The org_id and token will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		The org_id and token are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Add-VrkdaCmdUsr","Ad-VrkdaCmdUsr")]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The public API key to be used for calls that hit the public API gateway
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key = $Global:verkadaConnection.token,
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
		[String]$phone
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
		if (!([string]::IsNullOrEmpty($phone))){$body_params.phone = $phone}

		$query_params = @{}

		try {
		$response = Invoke-VerkadaRestMethod $url $org_id $x_api_key $query_params -body_params $body_params -method POST
		return $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$msg = ($body_params | ConvertTo-Json -Compress) + " not created due to an error"
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force
			$msg += ": $($err.StatusCode) - $($err.message)"
			Write-Error $msg
			$myErrors += $msg
			$msg = $null
		}
	} #end process
	
	end {
		#Write-Host $myErrors -ForegroundColor Red
	} #end end
} #end function