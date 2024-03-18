function Add-VerkadaWorkplaceEmployee{
	<#
		.SYNOPSIS
		Adds a Verkada Workplace employee to an org and/or a specific site.

		.DESCRIPTION
		Used to add a Verkada Workplace employee in the root org and/or specific sites.  Specificying the siteId or siteName will add the employee to that site.  These paramteres are mutally exclusive.  Omitting siteId or siteName will add the employee in the root org.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaWorkplaceEmployee.md

		.EXAMPLE
		Add-VerkadaWorkplaceEmployee -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -phoneNumber '+15551239876'
		This will add a Workplace employee with the name "New User", email newUser@contoso.com and phone number +15551239876 to the organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaWorkplaceEmployee -siteId '21efb7f-8329-4886-a89d-d2cc482b01d0' -firstName 'New' -lastName 'User' -email 'newUser@contoso.com'
		This will add a Workplace employee with the name "New User" and email newUser@contoso.com in the site with the id 'c21efb7f-8329-4886-a89d-d2cc482b01d0' to the organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaWorkplaceEmployee -siteName 'My Guest Site' -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will add a Workplace employee with the name "New User" and email newUser@contoso.com in the site named 'My Guest Site' to the organization.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Add-VrkdaWrkEmp","a-VrkdaWrkEmp")]
	param (
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
		#The phone number of the user, E.164 format preferred
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern("^\+[1-9]\d{10,14}$")]
		[Alias('phone')]
		[String]$phoneNumber,
		#The UUID of the site
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$siteId,
		#The siteName if siteId is unknown
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$siteName,
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
		if ([string]::IsNullOrEmpty($email)) {throw "email is missing but is required!"}
		if ([string]::IsNullOrEmpty($firstName)) {throw "firstName is missing but is required!"}
		if ([string]::IsNullOrEmpty($lastName)) {throw "lastName is missing but is required!"}

		$body =@{
			'email'					= $email
			'firstName'			= $firstName
			'lastName'			= $lastName
			'individualAdd'	= $true
		}
		if (!([string]::IsNullOrEmpty($phoneNumber))){$body.phoneNumber = $phoneNumber}

		if (!([string]::IsNullOrEmpty($siteId))) {
			$url = "https://vdoorman.command.verkada.com/host/org/$org_id/site/$siteId"
		} elseif (!([string]::IsNullOrEmpty($siteName))) {
			#find siteId
			$siteId = Get-VerkadaAccessSite -name $siteName -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr | Select-Object -ExpandProperty cameraGroupId
			$url = "https://vdoorman.command.verkada.com/host/org/$org_id/site/$siteId"
		} else {
			$url = "https://vdoorman.command.verkada.com/host/org/$org_id"
		}

		try {
			Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST' | Select-Object -ExpandProperty newHost
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