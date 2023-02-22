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
		[String]$method = 'POST'

	)

	Begin {
		if (!($Global:verkadaConnection)){Write-Warning 'Missing auth token which is required'; return}
		if ($Global:verkadaConnection.authType -ne 'UnPwd'){Write-Warning 'Un/Pwd auth is required'; return}
	}

	Process {
		#$form = @{}
		#$form_params.psobject.properties | Foreach { $form[$_.Name] = $_.Value }
		
		$headers=@{
			'x-verkada-token'		= $Global:verkadaConnection.csrfToken
			'X-Verkada-Auth'		=	$Global:verkadaConnection.userToken
		}
		
		$uri = $url
		$form_params
		$headers
		$uri
			
		$response = Invoke-RestMethod -Uri $uri -Form $form_params -Headers $headers -Method $method -ContentType 'multipart/form-data'
		return $response
		
	} #end process
} #end function