function Invoke-VerkadaFormCall
{
	<#
		.SYNOPSIS
		Used to build an Invoke-RestMethod call for Verkada's AC API
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		[Parameter(Mandatory = $true, Position = 0)]
		[String]$url,
		[Parameter(Mandatory = $true, Position = 1)]
		[String]$org_id,
		[Parameter(Mandatory = $true,Position = 3)]
		[Object]$form_params,
		[Parameter()]
		[String]$method = 'POST',
		[Parameter()]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		[Parameter()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken

	)

	Begin {
		#if (!($Global:verkadaConnection)){Write-Warning 'Missing auth token which is required'; return}
		#if ($Global:verkadaConnection.authType -ne 'UnPwd'){Write-Warning 'Un/Pwd auth is required'; return}
	}

	Process {
		#$form = @{}
		#$form_params.psobject.properties | Foreach { $form[$_.Name] = $_.Value }
		
		$headers=@{
			'x-verkada-token'		= $x_verkada_token
			'X-Verkada-Auth'		=	$x_verkada_auth
		}
		
		$uri = $url
			
		$response = Invoke-RestMethod -Uri $uri -Form $form_params -Headers $headers -Method $method -ContentType 'multipart/form-data' -MaximumRetryCount 3 -TimeoutSec 120 -RetryIntervalSec 5
		return $response
		
	} #end process
} #end function