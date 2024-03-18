function Set-VerkadaWorkplaceEmployee{
	<#
		.SYNOPSIS
		Sets the properties of a Verkada Workplace employee in an org and/or a specific site.

		.DESCRIPTION
		Used to set the properties of a Verkada Workplace employee in the root org and/or specific sites.  Specificying the siteId or siteName will set the properties of the employee in that site.  These paramteres are mutally exclusive.  Omitting siteId or siteName will set the properties of the employee in the root org.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaWorkplaceEmployee.md

		.EXAMPLE
		Set-VerkadaWorkplaceEmployee -hostId 8b6e9c59-ffff-4f89-9367-7e6786346f29 -firstName 'New' -lastName 'User' -phoneNumber '+15551239876'
		This will set a Workplace employee's, with the hostId '8b6e9c59-ffff-4f89-9367-7e6786346f29', name to "New User" and the phone number to +15551239876 in the organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaWorkplaceEmployee -hostId 8b6e9c59-ffff-4f89-9367-7e6786346f29 -siteId '21efb7f-8329-4886-a89d-d2cc482b01d0' -firstName 'New' -lastName 'Username'
		This will set a Workplace employee's, with the hostId '8b6e9c59-ffff-4f89-9367-7e6786346f29', name to "New Username" in the site with the id 'c21efb7f-8329-4886-a89d-d2cc482b01d0' in the organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaWorkplaceEmployee -siteName 'My Guest Site' -phoneNumber '+15551239876' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will set a Workplace employee's, with the hostId '8b6e9c59-ffff-4f89-9367-7e6786346f29', phone number to +15551239876 in the site named 'My Guest Site' in the organization.  The org_id and tokens are submitted as parameters in the call.

		.EXAMPLE
		Get-VerkadaWorkplaceEmployee -siteName 'My Guest Site' -email "new.user@contoso.com" | Set-VerkadaWorkplaceEmployee -phoneNumber '+15551239876'
		This will set a Workplace employee's, who's email is new.user@contoso.com, phone number to +15551239876 in the site named 'My Guest Site' in the organization.   The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Set-VrkdaWrkEmp","st-VrkdaWrkEmp")]
	param (
		#The UUID of the employee
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('employeeId')]
		[String]$hostId,
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
		if ([string]::IsNullOrEmpty($hostId)) {throw "hostId is missing but is required!"}
		$body =@{}
		
		if (!([string]::IsNullOrEmpty($firstName))){$body.adminFirstName = $firstName}
		if (!([string]::IsNullOrEmpty($lastName))){$body.lastName = $lastName}
		if (!([string]::IsNullOrEmpty($phoneNumber))){$body.adminPhoneNumber = $phoneNumber}

		if (!([string]::IsNullOrEmpty($siteId))) {
			$url = "https://vdoorman.command.verkada.com/host/org/$org_id/site/$siteId/host/$hostId"
		} elseif (!([string]::IsNullOrEmpty($siteName))) {
			#find siteId
			$siteId = Get-VerkadaAccessSite -name $siteName -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr | Select-Object -ExpandProperty cameraGroupId
			$url = "https://vdoorman.command.verkada.com/host/org/$org_id/site/$siteId/host/$hostId"
		} else {
			$url = "https://vdoorman.command.verkada.com/host/org/$org_id/host/$hostId"
		}

		try {
			Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'PATCH' | Select-Object -ExpandProperty host
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