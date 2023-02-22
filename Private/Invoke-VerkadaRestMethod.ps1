function Invoke-VerkadaRestMethod
{
	<#
		.SYNOPSIS
		Used to build an Invoke-RestMethod call for Verkada's RESTful API
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'Default')]
	Param(
		[Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Default')]
		[Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Pagination')]
		[Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'UnPwd')]
		[String]$url,
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Default')]
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Pagination')]
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'UnPwd')]
		[String]$org_id,
		[Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'Default')]
		[Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'Pagination')]
		[String]$x_api_key,
		[Parameter(Position = 3, ParameterSetName = 'Default')]
		[Parameter(Position = 3, ParameterSetName = 'Pagination')]
		[Object]$query_params,
		[Parameter(Position = 4, ParameterSetName = 'Default')]
		[Parameter(Position = 4, ParameterSetName = 'Pagination')]
		[Parameter(Position = 2, ParameterSetName = 'UnPwd')]
		[Object]$body_params,
		[Parameter(ParameterSetName = 'Default')]
		[Parameter(ParameterSetName = 'Pagination')]
		[Parameter(ParameterSetName = 'UnPwd')]
		[String]$method = 'GET',
		[Parameter(Mandatory = $true, ParameterSetName = 'Pagination')]
		[switch]$pagination,
		[Parameter(Mandatory = $true, ParameterSetName = 'Pagination')]
		[String]$page_size,
		[Parameter(Mandatory = $true, ParameterSetName = 'Pagination')]
		[String]$propertyName,
		[Parameter(Mandatory = $true,ParameterSetName = 'UnPwd')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		[Parameter(Mandatory = $true,ParameterSetName = 'UnPwd')]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		[Parameter(ParameterSetName = 'UnPwd')]
		[Switch]$UnPwd

	)

	Process {
		$query = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		$query.add('org_id',$org_id)
		if($query_params){
			foreach ($qp in $query_params.GetEnumerator()) {$query.add("$($qp.name)", "$($qp.value)")}
		}

		$body = @{}
		if ($body_params){
			$body += $body_params
			$body = $body | ConvertTo-Json
		}
		if ($UnPwd){
			$headers=@{
				'x-verkada-token'		= $x_verkada_token
				'X-Verkada-Auth'		=	$x_verkada_auth
			}
		} else {
			$headers=@{
				'x-api-key' = $x_api_key
			}
		}

		if ($pagination.IsPresent){
			$query.add('page_size', $page_size)
			$query.add('page_token', '1')
			$uri = [System.UriBuilder]"$url"
			$uri.Query = $query.ToString()
			$uri = $uri.Uri.OriginalString
			$records = @()
			Do {
				$response = Invoke-RestMethod -Uri $uri -Body $body -Headers $headers -ContentType 'application/json' -MaximumRetryCount 3 -TimeoutSec 30 -RetryIntervalSec 5
				$records += $response.($propertyName)
				$body.page_token = $response.next_page_token
			} While ($body.page_token)
			return $records
		} else {
			if ($UnPwd.IsPresent) {
				$uri = $url
			} else {
				$uri = [System.UriBuilder]"$url"
				$uri.Query = $query.ToString()
				$uri = $uri.Uri.OriginalString
			}
			
			$response = Invoke-RestMethod -Uri $uri -Body $body -Headers $headers -Method $method -ContentType 'application/json' -MaximumRetryCount 3 -TimeoutSec 30 -RetryIntervalSec 5
			return $response
		}
		
	} #end process
} #end function