function Set-VerkadaAlarmsPanicButtonSettings{
	<#
		.SYNOPSIS
		This is used to set the various settings of a Verkada Alarms BR33 panic button

		.DESCRIPTION
		This will set the settings of a Verkada Alarms wireless BR33 panic button in an organization.  This can be used to set the press type, mobile mode, silent mode, mute device, and mute tamper events settings.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Set-VerkadaAlarmsPanicButtonSettings.md

		.EXAMPLE
		Set-VerkadaAlarmsPanicButtonSettings -deviceId 'cd1f1bb9-c8b9-40b9-ab14-546a93d952cf' -panicPressType 'long' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		Sets the BR33 panic button press type to long for the panic button with deviceId cd1f1bb9-c8b9-40b9-ab14-546a93d952cf.  The org_id and tokens are submitted as parameters in the call.

		.EXAMPLE
		Get-VerkadaAlarmsDevices | Select-Object -ExpandProperty panicButton | Set-VerkadaAlarmsPanicButtonSettings -tamperIsMuted $true
		Sets all the BR33 panic buttons in an org to mute tamper events. The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Set-VrkdAlrmPancSetgs","s-VrkdAlrmPancSetgs","s-VrkdAlrmBr33Setgs")]
	param (
		#The UUID of the BR33 panic button
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias("device_id")]
		[String]$deviceId,
		#The new name for the panic button
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$name,
		#The panicPressType setting
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('single','long','double','triple')]
		[String]$panicPressType,
		#The enableMobileMode setting
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$enableMobileMode,
		#The isSilent setting
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$isSilent,
		#The isMuted setting
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$isMuted,
		#The tamperIsMuted setting
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$tamperIsMuted,
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

		$url = 'https://alarms.command.verkada.com/device/sensor/update'
	} #end begin
	
	process {
		$body = @{
			"deviceId"		= $deviceId
			"deviceType"	= "panicButton"
		}
		if (!([string]::IsNullOrEmpty($name))){$body.name = $name}
		if (!([string]::IsNullOrEmpty($panicPressType))){$body.panicPressType = $panicPressType}
		if (!([string]::IsNullOrEmpty($enableMobileMode))){$body.enableMobileMode = $enableMobileMode}
		if (!([string]::IsNullOrEmpty($isSilent))){$body.isSilent = $isSilent}
		if (!([string]::IsNullOrEmpty($isMuted))){$body.isMuted = $isMuted}
		if (!([string]::IsNullOrEmpty($tamperIsMuted))){$body.tamperIsMuted = $tamperIsMuted}

		$body = $body | ConvertTo-Json | ConvertFrom-Json

		try {
			$response = Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'
			return $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			Write-Host "Panic button settings not set because: $($err.StatusCode) - $($err.message)" -ForegroundColor Red
			Return
		}
	} #end process
	
	end {
		
	} #end end
} #end function