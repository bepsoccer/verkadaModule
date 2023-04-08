function Invoke-VerkadaCommandCall
{
	<#
		.SYNOPSIS
		Used to build an Invoke-RestMethod call for Verkada's private API enpoints
		.DESCRIPTION
		Private function to build Invoke-RestMethod calls for Verkada's private API enpoints
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
		#The body of the REST call
		[Parameter(Mandatory = $true, Position = 2)]
		[Object]$body,
		#HTTP method required
		[Parameter()]
		[String]$method = 'GET',
		#The UUID of the user account making the request
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$usr,
		#The Verkada(CSRF) token of the user running the command
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter(Mandatory = $true)]
		[string]$x_verkada_auth
	)

	Process {

		$cookies = @{
			'auth'	= $x_verkada_auth
			'org'		= $org_id
			'token'	= $x_verkada_token
			'usr'		= $usr
		}

		$session = New-WebSession $cookies $url
		switch (([System.Uri]$url).host) {
			default {
				$headers=@{
					'x-verkada-token'		= $x_verkada_token
					'X-Verkada-Auth'		=	$x_verkada_auth
				}
			}
			'vnetsuite.command.verkada.com' {
				$headers=@{
					'x-verkada-token'						= $x_verkada_token
					'x-verkada-user-id'					=	$usr
					'x-verkada-organization-id'	= $org_id
				}
			}
			'vprovision.command.verkada.com' {
				switch (([System.Uri]$url).AbsolutePath) {
					default {
						$headers=@{
							'x-verkada-token'		= $x_verkada_token
							'X-Verkada-Auth'		=	$x_verkada_auth
						}
					}
					'/camera/init/batch' {
						$headers=@{
							'x-verkada-token'						= $x_verkada_token
							'x-verkada-user-id'					=	$usr
							'x-verkada-organization-id'	= $org_id
						}
					}
				}
			}
		}
		
		$uri = $url
		$bodyJson = $body | ConvertTo-Json -depth 100 -Compress

		$response = Invoke-RestMethod -Uri $uri -Body $bodyJson -ContentType 'application/json' -WebSession $session -Method $method -Headers $headers -TimeoutSec 120
		
		return $response
	} #end process
} #end function