function Get-VerkadaAlarmsSiteConfig{
	<#
		.SYNOPSIS
		Returns the config of a Verkada Alarms site in an organization.

		.DESCRIPTION
		This function will return the config of a Verkada Alarms site in an organization using the UUID(zoneId) of the site.  This function take a pipeline input if you want to gather the config from multiple sites.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAlarmsSiteConfig.md

		.EXAMPLE
		Get-VerkadaAlarmsSiteConfig -zoneId 'cd611c9f-fa2b-4b5e-b194-f0ea296702c3'
		This will return the Alarms config for the site with the zoneId cd611c9f-fa2b-4b5e-b194-f0ea296702c3.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Read-VerkadaAlarmsSites | Get-VerkadaAlarmsSiteConfig
		This will return the Alarms config for every site in the org.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAlarmsSiteConfig -zoneId 'cd611c9f-fa2b-4b5e-b194-f0ea296702c3' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will return the Alarms config for the site with the siteId cd611c9f-fa2b-4b5e-b194-f0ea296702c3.  The org_id and tokens are submitted as parameters in the call.
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
		[string]$usr = $Global:verkadaConnection.usr,
		#The size of the batch of zoneId's to process in a single call
		[Parameter()]
		[Int]$batchSize = 100
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$url = 'https://alarms.command.verkada.com/alarm_configuration/list'

		$zoneIds = @()
		$zoneConfigs = @()
	} #end begin
	
	process {
		$zoneIds += $zoneId
	} #end process
	
	end {
		if ($batchSize -gt $zoneIds.count){
			$batchSize = $zoneIds.count
		}
		$batches = [System.Collections.ArrayList]::new()
		for ($i = 0; $i -lt $zoneIds.Count; $i += $batchSize) {
				if (($zoneIds.Count - $i) -gt ($batchSize - 1)) {
						$batches.add($zoneIds[$i..($i + ($batchSize - 1))]) | Out-Null
				}
				else {
						$batches.add($zoneIds[$i..($zoneIds.Count - ($batchSize - 1))]) | Out-Null
				}
		}

		foreach ($batch in $batches){
			$Body = @{
				"zoneIds"		= $batch
			}

			try {
				$configs = Invoke-VerkadaCommandCall $URL $org_id $Body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST'

				#$configs = ConvertFrom-PropertylessJson $configs 'cameraId'
				$zoneConfigs += $configs.alarmConfiguration
			}
			catch [Microsoft.PowerShell.Commands.HttpResponseException] {
				$err = $_.ErrorDetails | ConvertFrom-Json
				$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
				$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

				Write-Host "$($err.StatusCode) - $($err.message)" -ForegroundColor Red
				Return
			}
		}

		foreach ($config in $zoneConfigs){
			$siteDetails = $null
			$siteDetails = Read-VerkadaAlarmsSites | Where-Object {$_.zoneId -eq $config.zoneId}
			$config | Add-Member -NotePropertyName 'siteName' -NotePropertyValue $siteDetails.siteName
			$config | Add-Member -NotePropertyName 'siteId' -NotePropertyValue $siteDetails.siteId
		}

		return $zoneConfigs
	} #end end
} #end function