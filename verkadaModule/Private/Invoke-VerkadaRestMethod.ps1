class VerkadaRestMethodException: System.Exception {
	VerkadaRestMethodException([string] $x) :
			base ("$x") {}
}

function Invoke-VerkadaRestMethod
{
	<#
		.SYNOPSIS
		Used to build an Invoke-RestMethod call for Verkada's private API enpoints
		.DESCRIPTION
		Private function to build Invoke-RestMethod calls for Verkada's private API enpoints
	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'Default')]
	Param(
		#The url for the enpoint to be used
		[Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Default')]
		[Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Pagination')]
		[Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'UnPwd')]
		[String]$url,
		#The UUID of the organization the user belongs to
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Default')]
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Pagination')]
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'UnPwd')]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id,
		#The public API key to be used for calls that hit the public API gateway
		[Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'Default')]
		[Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'Pagination')]
		[String]$x_api_key,
		#Object containing the query parameters need that will be put into the query string of the uri
		[Parameter(Position = 3, ParameterSetName = 'Default')]
		[Parameter(Position = 3, ParameterSetName = 'Pagination')]
		[Object]$query_params,
		#The body of the REST call
		[Parameter(Position = 4, ParameterSetName = 'Default')]
		[Parameter(Position = 4, ParameterSetName = 'Pagination')]
		[Parameter(Position = 2, ParameterSetName = 'UnPwd')]
		[Object]$body_params,
		#HTTP method required
		[Parameter(ParameterSetName = 'Default')]
		[Parameter(ParameterSetName = 'Pagination')]
		[Parameter(ParameterSetName = 'UnPwd')]
		[String]$method = 'GET',
		#Switch to enable pagination through records
		[Parameter(Mandatory = $true, ParameterSetName = 'Pagination')]
		[switch]$pagination,
		#The page size used for pagination
		[Parameter(Mandatory = $true, ParameterSetName = 'Pagination')]
		[String]$page_size,
		#The property to be used from the returned payload
		[Parameter(Mandatory = $true, ParameterSetName = 'Pagination')]
		[String]$propertyName,
		#The Verkada(CSRF) token of the user running the command
		[Parameter(Mandatory = $true,ParameterSetName = 'UnPwd')]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter(Mandatory = $true,ParameterSetName = 'UnPwd')]
		[string]$x_verkada_auth,
		#Switch to indicate username/password auth is required
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
			$page_token = '1'
			$query.add('page_size', $page_size)
			$records = @()
			Do {
				if($page_token -ne '1'){
					try {$query.Remove('page_token')} catch {}
					$query.add('page_token', $page_token)
				}
				$uri = [System.UriBuilder]"$url"
				$uri.Query = $query.ToString()
				$uri = $uri.Uri.OriginalString

				$loop = $false
				$rt = 0
				do {
					try {
						$response = Invoke-RestMethod -Uri $uri -Body $body -Headers $headers -ContentType 'application/json' -MaximumRetryCount 3 -TimeoutSec 30 -RetryIntervalSec 5
						$records += $response.($propertyName)
						$page_token = $response.next_page_token
						#$query.Set('page_token', $page_token)

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
			} While ($page_token)
			return $records
		} else {
			if ($UnPwd.IsPresent) {
				$uri = $url
			} else {
				$uri = [System.UriBuilder]"$url"
				$uri.Query = $query.ToString()
				$uri = $uri.Uri.OriginalString
			}
			
			$loop = $false
			$rt = 0
			do {
				try {
					$response = Invoke-RestMethod -Uri $uri -Body $body -Headers $headers -Method $method -ContentType 'application/json' -TimeoutSec 30 -SkipHttpErrorCheck -StatusCodeVariable resCode

					switch ($resCode) {
						200 {
							$loop = $true
							return $response
						}
						429 {
							$rt++
							if ($rt -gt 2){
								$loop = $true
								$res = "$resCode - $($response.message)"
								throw [VerkadaRestMethodException] "$res"
							}
							else {
								Start-Sleep -Seconds 5
							}
						}
						Default {
							$loop = $true
							$res = "$resCode - $($response.message)"
							throw [VerkadaRestMethodException] "$res"
						}
					}
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
		}
	} #end process
} #end function