function Invoke-VerkadaFormCall
{
	<#
		.SYNOPSIS
		Used to build an Invoke-RestMethod call for Verkada's private API enpoints that require a form
		.DESCRIPTION
		Private function to build Invoke-RestMethod calls for Verkada's private API enpoints that require a form
	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		#The url for the enpoint to be used
		[Parameter(Mandatory = $true, Position = 0)]
		[String]$url,
		#The UUID of the organization the user belongs to
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id,
		#Object to pass form parameters to forms
		[Parameter(Mandatory = $true,Position = 3)]
		[Object]$form_params,
		#HTTP method required
		[Parameter()]
		[String]$method = 'POST',
		#The Verkada(CSRF) token of the user running the command
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth
	)

	Process {
		$headers=@{
			'x-verkada-token'		= $x_verkada_token
			'X-Verkada-Auth'		=	$x_verkada_auth
		}
		
		$uri = $url
			
		$loop = $false
		$rt = 0
		do {
			try {
				$response = Invoke-RestMethod -Uri $uri -Form $form_params -Headers $headers -Method $method -ContentType 'multipart/form-data' -TimeoutSec 120
				
				$loop = $true
				return $response
			}
			catch [System.TimeoutException] {
				$rt++
				if ($rt -gt 2){
					$loop = $true
				}
				else {
					Start-Sleep -Seconds 5
				}
			}
		}
		while ($loop -eq $false)
	} #end process
} #end function