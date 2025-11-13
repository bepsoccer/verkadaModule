function Read-VerkadaAlarmsSites{
	<#
		.SYNOPSIS
		Returns the list of Verkada Alarms sites in an organization.

		.DESCRIPTION
		This function will return the list of Verkada Alarms sites in an organization based on the org_id used.  No parameters are necessary if using Connect-Verkada.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Read-VerkadaAlarmsSites.md

		.EXAMPLE
		Read-VerkadaAlarmsSites
		This will return all the Alarms sites in the org.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Read-VerkadaAlarmsSites -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will return all the Alarms sites in the org.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	param (
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
		[string]$usr = $Global:verkadaConnection.usr,
		#Switch to force a refreshed list of Alarms from Command
		[Parameter()]
		[switch]$refresh
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$url = 'https://alarms.command.verkada.com/zone/list'
	} #end begin
	
	process {
		if ((!([string]::IsNullOrEmpty($global:verkadaAlarmsZones))) -and (!($refresh.IsPresent))) { 
			$zones = $Global:verkadaAlarmsZones
		} else {
			$body = @{
				"organizationId"	= $org_id
				"includeLastEvent"		= $false
			}
	
			$body = $body | ConvertTo-Json -Depth 10 | ConvertFrom-Json
	
			try {
				$response = Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
				$zones = $response.zone
				$global:verkadaAlarmsZones = $zones
			}
			catch [Microsoft.PowerShell.Commands.HttpResponseException] {
				$err = $_.ErrorDetails | ConvertFrom-Json
				$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
				$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force
	
				Write-Host "$($err.StatusCode) - $($err.message)" -ForegroundColor Red
				Return
			}
		}

	} #end process
	
	end {
		return $zones
	} #end end
} #end function