function Connect-Verkada
{
	<#
		.SYNOPSIS
		Gathers needed credentials for Verkada's Public API
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true,DefaultParameterSetName='apiToken')]
	Param(
		# Parameter help description
		[Parameter(ParameterSetName = 'apiToken', Mandatory = $true, Position = 0)]
		[Parameter(ParameterSetName = 'UnPwd', Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[String]$org_id,
		[Parameter(ParameterSetName = 'apiToken', Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[String]$Token,
		[Parameter(ParameterSetName = 'UnPwd', Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$userName,
		[Parameter(ParameterSetName = 'UnPwd', Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[switch]$Password
	)

	Process {
		Disconnect-Verkada

		if($Token) {
			$Global:verkadaConnection = @{
				token			= $Token
				org_id		= $org_id
				authType	= 'Token'
			}

			try {
				$body = @{
					'org_id' = $Global:verkadaConnection.org_id
					'page_size' = "1"
				}
				$headers=@{
					'x-api-key' = $Global:verkadaConnection.token
				}
				
				$response = Invoke-RestMethod -Uri 'https://api.verkada.com/cameras/v1/devices' -Body $body -Headers $headers -StatusCodeVariable responseCode
				Write-Host -ForegroundColor green "$responseCode - Successfully connected to Verkada Command"
				return
			} catch [Microsoft.PowerShell.Commands.HttpResponseException] {
				Disconnect-Verkada
				Write-Host -ForegroundColor Red $_.Exception.Message
				return
			}

		} elseif ($Password) {
			$MyPwd = Read-Host -AsSecureString 'Please enter your password'
			$credential = New-Object System.Net.NetworkCredential($userName, $MyPwd, "Domain")

			$Global:verkadaConnection = @{
				org_id		= $org_id
				authType	= 'UnPwd'
			}

			try {
				$body = @{
					"email"			= $userName
					"password"	= $credential.Password
					"org_id"		= $Global:verkadaConnection.org_id
				}

				$body = $body | ConvertTo-Json
				$response = Invoke-RestMethod -Uri 'https://vprovision.command.verkada.com/user/login' -Body $body -StatusCodeVariable responseCode -Method Post -ContentType 'application/json'
				$Global:verkadaConnection.userToken = $response.userToken
				$Global:verkadaConnection.csrfToken = $response.csrfToken
				$Global:verkadaConnection.usr = $response.userId
				Write-Host -ForegroundColor green "$responseCode - Successfully connected to Verkada Command"
				return $response
			} catch [Microsoft.PowerShell.Commands.HttpResponseException] {
				Disconnect-Verkada
				Write-Host -ForegroundColor Red $_.Exception.Message
				return
			}
		}
	} #end process
} #end function