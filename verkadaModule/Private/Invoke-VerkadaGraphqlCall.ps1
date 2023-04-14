function Invoke-VerkadaGraphqlCall
{
	<#
		.SYNOPSIS
		Used to build an Invoke-RestMethod call for Verkada's graphql enpoint
		.DESCRIPTION
		Private function to build Invoke-RestMethod calls for Verkada's graphql enpoint
	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		#The url for the enpoint to be used
		[Parameter(Mandatory = $true, Position = 0)]
		[String]$url,
		#The body of the REST call
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'body')]
		[Object]$body,
		#HTTP method required
		[Parameter()]
		[String]$method = 'GET',
		#The page size used for pagination
		[Parameter()]
		[int]$page_size = 100,
		#The property to be used from the returned payload
		[Parameter(Mandatory = $true)]
		[String]$propertyName,
		#The graphql query
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'query')]
		[object]$query,
		#The graphql variables
		[Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'query')]
		[object]$qlVariables,
		#The UUID of the organization the user belongs to
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id,
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
		if ($query) {
			$body = @{
			'query' = $query
			'variables' = $variables
			}
		}
		
		$body.variables.pagination.pageSize		= $page_size
		$body.variables.pagination.pageToken		= $null

		$cookies = @{
			'auth'	= $x_verkada_auth
			'org'		= $org_id
			'token'	= $x_verkada_token
			'usr'		= $usr
		}

		$session = New-WebSession $cookies $url

		$uri = $url
		$records = @()
		
		Do {
			$loop = $false
			$rt = 0
			do {
				try {
					$bodyJson = $body | ConvertTo-Json -depth 100 -Compress
					$response = Invoke-RestMethod -Uri $uri -Body $bodyJson -ContentType 'application/json' -WebSession $session -Method $method -TimeoutSec 120
					$records += $response.data.($propertyName).($propertyName)
					$body.variables.pagination.pageToken = $response.data.($propertyName).nextPageToken
					$loop = $true
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
		} While ($body.variables.pagination.pageToken)
		
		return $records
	} #end process
} #end function