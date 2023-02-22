function Invoke-VerkadaGraphqlCall
{
	<#
		.SYNOPSIS
		Used to build an Invoke-RestMethod call for Verkada's Graphql enpoint
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		[Parameter(Mandatory = $true, Position = 0)]
		[String]$url,
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'body')]
		[Object]$body,
		[Parameter()]
		[String]$method = 'GET',
		[Parameter()]
		[int]$page_size = 100,
		[Parameter(Mandatory = $true)]
		[String]$propertyName,
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'query')]
		[object]$query,
		[Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'query')]
		[object]$qlVariables

	)

	Process {
		if (!($Global:verkadaConnection)){Write-Warning 'Missing auth token which is required'; return}
		if ($Global:verkadaConnection.authType -ne 'UnPwd'){Write-Warning 'Un/Pwd auth is required'; return}
		
		if ($query) {
			$body = @{
			'query' = $query
			'variables' = $variables
			}
		}
		
		$body.variables.pagination.pageSize		= $page_size
		$body.variables.pagination.pageToken		= $null

		$cookies = @{
			'auth'	= $Global:verkadaConnection.userToken
			'org'		= $Global:verkadaConnection.org_id
			'token'	= $Global:verkadaConnection.csrfToken
			'usr'		= $Global:verkadaConnection.usr = $response.userId
		}

		$session = New-WebSession $cookies $url

		$uri = $url
		$records = @()
		
		Do {
			$bodyJson = $body | ConvertTo-Json -depth 100 -Compress
			$response = Invoke-RestMethod -Uri $uri -Body $bodyJson -ContentType 'application/json' -WebSession $session -Method $method -TimeoutSec 10
			$records += $response.data.($propertyName).($propertyName)
			$body.variables.pagination.pageToken = $response.data.($propertyName).nextPageToken
		} While ($body.variables.pagination.pageToken)
		
		return $records
		
	} #end process
} #end function