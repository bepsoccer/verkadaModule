function Get-VerkadaAlarmsSiteContacts{
	<#
		.SYNOPSIS
		Returns the configured contacts of a Verkada Alarms site in an organization.

		.DESCRIPTION
		This function will return the configured contacts of a Verkada Alarms site in an organization using the UUID(zoneId) of the site.  This function take a pipeline input if you want to gather the contacts from multiple sites.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAlarmsSiteContacts.md

		.EXAMPLE
		Get-VerkadaAlarmsSiteContacts -zoneId 'cd611c9f-fa2b-4b5e-b194-f0ea296702c3'
		This will return the Alarms configured contacts for the site with the zoneId cd611c9f-fa2b-4b5e-b194-f0ea296702c3.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Read-VerkadaAlarmsSites | Get-VerkadaAlarmsSiteContacts
		This will return the Alarms configured contacts for every site in the org.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAlarmsSiteContacts -zoneId 'cd611c9f-fa2b-4b5e-b194-f0ea296702c3' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will return the Alarms configured contacts for the site with the siteId cd611c9f-fa2b-4b5e-b194-f0ea296702c3.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The UUID of the site
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$zoneId,
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

		$zoneIds = @()
	} #end begin
	
	process {
		$zone = @{
			'zoneId'	= $zoneId
		} | ConvertTo-Json | ConvertFrom-Json
		$zoneIds += $zone
	} #end process
	
	end {
		$zoneContacts = $zoneIds | Get-VerkadaAlarmsSiteConfig | Select-Object zoneId, siteName, notifyUsers
		foreach ($zone in $zoneContacts){
			$newNotifyUsers = @()
			foreach ($contact in $zone.notifyUsers){
				$methods = @()
				foreach ($method in $contact.notificationMethods){
					$methods += $method
				}
				if(![string]::IsNullOrEmpty($contact.remoteMonitoringPriority)){
					$methods += "phone call($($contact.remoteMonitoringPriority))"
				}
				[string]$methodsList = $null
				$methodsList = $methods -join ", "
				$methodsList = "[$methodsList]"

				$user = Get-VerkadaCommandUser -userId $contact.userId
				$newContact = "$($user.firstName) $($user.lastName): $methodsList"

				$newNotifyUsers += $newContact
			}
			[string]$zone.notifyUsers = $newNotifyUsers -join "`r`n"
		}

		return $zoneContacts
	} #end end
} #end function