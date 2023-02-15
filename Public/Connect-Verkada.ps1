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
		[ValidateNotNullOrEmpty()]
		[String]$org_id,
		[Parameter(ParameterSetName = 'apiToken', Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[String]$Token
	)

	Process {
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

		}
	} #end process
} #end function