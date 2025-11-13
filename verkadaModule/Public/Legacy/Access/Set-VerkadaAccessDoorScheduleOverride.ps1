function Set-VerkadaAccessDoorScheduleOverride{
	<#
		.SYNOPSIS
		This is used to set a Verkada Access door schedule override

		.DESCRIPTION
		This function allows for setting a VerkadaAccess door schedule overide in an organization.  This can change the state to LOCKED, UNLOCKED, ACCESS_CONTROL for the period of time specified.  This can also be indefinte and be set to start in the future.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAccessDoorScheduleOverride.md

		.EXAMPLE
		Set-VerkadaAccessDoorScheduleOverride -doorId '373c1b23-3965-4bf8-80cb-6bd245b366b8' -doorState 'UNLOCKED' -minutes 30
		This will set the door with doorId 373c1b23-3965-4bf8-80cb-6bd245b366b8 to change its schedule to be unlocked for the next 30 minutes.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Set-VerkadaAccessDoorScheduleOverride -doorId '373c1b23-3965-4bf8-80cb-6bd245b366b8' -doorState 'LOCKED' -startDateTime '11/3/2023 12:16PM' -indefinite -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will set the door with doorId 373c1b23-3965-4bf8-80cb-6bd245b366b8 to change its schedule to be locked indefinitely fstarting on November 3, 2023 at 12:16PM local time.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Set-VrkdAcDrSchOvrd","s-VrkdAcDrSchOvrd")]
	param (
		#The UUID of the door
		[Parameter(ValueFromPipelineByPropertyName = $true, mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$doorId,
		#The duration in minutes for the override
		[Parameter(ValueFromPipelineByPropertyName = $true, mandatory = $true, ParameterSetName = 'minutes')]
		[ValidateNotNullOrEmpty()]
		[int]$minutes,
		#The switch to make the overide indefinite
		[Parameter(ValueFromPipelineByPropertyName = $true, mandatory = $true, ParameterSetName = 'indefinite')]
		[switch]$indefinite,
		#The Date/Time the override starts
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('startDateTime')]
		[datetime]$startDate = (Get-Date),
		#The desired door override state
		[Parameter(ValueFromPipelineByPropertyName = $true, mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('UNLOCKED','ACCESS_CONTROL','LOCKED')]
		[String]$doorState,
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

		$url = "https://vcerberus.command.verkada.com/organizations/$org_id/schedules"
	} #end begin
	
	process {
		if($indefinite.IsPresent){
			$endDate = $null
		} else {
			$endDate = Get-Date $startDate.AddMinutes($minutes) -Format s
		}
		$startDate = Get-Date $startDate -Format s

		$schedules = @()
		[array]$doors = @($doorId)
		$events = @()
		$schedule = @{
			"priority"							= "MANUAL"
			"startDateTime"					= $startDate
			"endDateTime"						= $endDate
			"deleted"								=	$false
			"name"									= ""
			"type"									= "DOOR"
			"doors"									= $doors
			"defaultDoorLockState"	= $doorState
			"events"								= $events
		}
		$schedule = $schedule | ConvertTo-Json -Depth 10 | ConvertFrom-Json
		$schedules += $schedule

		$body = @{
			"sitesEnabled"		= $true
			"schedules"				= $schedules
		}
		$body = $body | ConvertTo-Json -Depth 10 | ConvertFrom-Json

		try {
			$response = Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
			return $response
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