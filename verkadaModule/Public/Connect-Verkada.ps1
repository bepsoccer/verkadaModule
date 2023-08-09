function Connect-Verkada
{
	<#
		.SYNOPSIS
		Gathers needed credentials for Verkada's API Endpoints
		
		.DESCRIPTION
		This function is used to authenticate a session and store the needed tokens and org_id for other functions in this module.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Connect-Verkada.md

		.EXAMPLE
		Connect-Verkada 'dsfwfd-wdf-orgId' 'myapiKey-dcwdskjnlnlkj'
		This will store the org_id dsfwfd-wdf-orgId with the public API key myapiKey-dcwdskjnlnlkj.
		
		.EXAMPLE
		Connect-Verkada 'dsfwfd-wdf-orgId' -userName "admin.user@contoso.com" -Password
		This will authenticate user admin.user@contoso.com by prompting for the password(stored as a secure string) and upon success store the org_id dsfwfd-wdf-orgId and the returned tokens.
		
		.EXAMPLE
		Connect-Verkada 'dsfwfd-wdf-orgId' -x_api_key 'myapiKey-dcwdskjnlnlkj' -userName "admin.user@contoso.com" -Password
		This will store the org_id dsfwfd-wdf-orgId with the public API key myapiKey-dcwdskjnlnlkj and will authenticate user admin.user@contoso.com by prompting for the password(stored as a secure string) and storing the returned tokens.
	#>

	[CmdletBinding(PositionalBinding = $true,DefaultParameterSetName='apiToken')]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(ParameterSetName = 'apiToken', Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
		[Parameter(ParameterSetName = 'UnPwd', Mandatory = $true, Position = 0)]
		[Parameter(ParameterSetName = 'ManualTokens', Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id,
		#The public API key to be used for calls that hit the public API gateway
		[Parameter(ParameterSetName = 'apiToken', Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
		[Parameter(ParameterSetName = 'UnPwd', Position = 1)]
		[Parameter(ParameterSetName = 'ManualTokens', Position = 1, ValueFromPipelineByPropertyName = $true)]
		[Alias('token')]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key,
		#The admin user name to be used to obtain needed session and auth tokens
		[Parameter(ParameterSetName = 'UnPwd', Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$userName,
		#The switch needed to prompt for admin password to be used to obtain needed session and auth tokens
		[Parameter(ParameterSetName = 'UnPwd', Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[switch]$Password,
		#The userToken retrieved from Command login
		[Parameter(ParameterSetName = 'ManualTokens', Mandatory = $true, Position = 2, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias('x_verkada_auth')]
		[String]$userToken,
		#The csrfToken retrieved from Command login
		[Parameter(ParameterSetName = 'ManualTokens', Mandatory = $true, Position = 3, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias('x_verkada_token')]
		[String]$csrfToken,
		#The usr ID retrieved from Command login
		[Parameter(ParameterSetName = 'ManualTokens', Mandatory = $true, Position = 4, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias('x-verkada-user-id')]
		[String]$usr,
		#The switch to indicate manual token auth
		[Parameter(ParameterSetName = 'ManualTokens')]
		[switch]$manual,
		#The One Time Password if using 2FA
		[Parameter(ParameterSetName = 'UnPwd')]
		[string]$otp
	)

	Process {
		Remove-Variable -Name verkadaCameras -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaCameraModels -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaCameraGroups -Scope Global -ErrorAction SilentlyContinue
		If (!($Global:verkadaConnection)){
			$Global:verkadaConnection = @{
				org_id		= $org_id
			}
		}
		
		if($x_api_key) {
			$Global:verkadaConnection.token = $x_api_key

			try {
				$body = @{
					'org_id' = $Global:verkadaConnection.org_id
					'page_size' = "1"
				}
				$headers=@{
					'x-api-key' = $Global:verkadaConnection.token
				}
				
				$response = Invoke-RestMethod -Uri 'https://api.verkada.com/cameras/v1/devices' -Body $body -Headers $headers -StatusCodeVariable responseCode
				Write-Host -ForegroundColor green "$responseCode - Successfully connected to Verkada Command with API Token"
				#return
			} catch [Microsoft.PowerShell.Commands.HttpResponseException] {
				Disconnect-Verkada
				Write-Host -ForegroundColor Red $_.Exception.Message
				return
			}

		}
		if ($Password) {
			$MyPwd = Read-Host -AsSecureString 'Please enter your password'
			$credential = New-Object System.Net.NetworkCredential($userName, $MyPwd, "Domain")

			try {
				$body = @{
					"email"			= $userName
					"password"	= $credential.Password
					"org_id"		= $Global:verkadaConnection.org_id
				}
				if (![string]::IsNullOrEmpty($otp)){
					[string]$body.otp = $otp
				}

				$body = $body | ConvertTo-Json
				$response = Invoke-RestMethod -Uri 'https://vprovision.command.verkada.com/user/login' -Body $body -StatusCodeVariable responseCode -Method Post -ContentType 'application/json'
				$Global:verkadaConnection.userToken = $response.userToken
				$Global:verkadaConnection.csrfToken = $response.csrfToken
				$Global:verkadaConnection.usr = $response.userId
				Write-Host -ForegroundColor green "$responseCode - Successfully connected to Verkada Command with Un/Pass"
				Invoke-VerkadaCommandInit | Out-Null
				return $response
			} catch [Microsoft.PowerShell.Commands.HttpResponseException] {
				Disconnect-Verkada
				Write-Host -ForegroundColor Red $_.Exception.Message
				return
			}
		}
		if ($usr){
			try{
				$Global:verkadaConnection.userToken = $userToken
				$Global:verkadaConnection.csrfToken = $csrfToken
				$Global:verkadaConnection.usr = $usr
				Get-VerkadaCommandUser -userId $usr
				Write-Host -ForegroundColor Green "Successfully connected to Verkada Command"
				Invoke-VerkadaCommandInit | Out-Null
				return
			} catch [Microsoft.PowerShell.Commands.HttpResponseException] {
				Disconnect-Verkada
				Write-Host -ForegroundColor Red $_.Exception.Message
				return
			}
		}
	} #end process
} #end function