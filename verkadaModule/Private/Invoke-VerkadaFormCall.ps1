function Invoke-VerkadaFormCall
{
	<#
		.SYNOPSIS
		Used to build an Invoke-RestMethod call for Verkada's private API enpoints that require a form
		.DESCRIPTION
		Private function to build Invoke-RestMethod calls for Verkada's private API enpoints that require a form
	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'Default')]
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
		[Parameter(Mandatory = $true,Position = 2)]
		[Object]$form_params,
		#Object containing the query parameters need that will be put into the query string of the uri
		[Parameter()]
		[Object]$query_params,
		#HTTP method required
		[Parameter()]
		[String]$method = 'POST',
		#The Verkada(CSRF) token of the user running the command
		[Parameter(Mandatory = $true, ParameterSetName = 'UnPwd')]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter(Mandatory = $true, ParameterSetName = 'UnPwd')]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth,
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter(ParameterSetName = 'Default')]
		[String]$x_verkada_auth_api
	)

	Process {
		if ($PSCmdlet.ParameterSetName -eq 'UnPwd'){
			$headers=@{
				'x-verkada-token'		= $x_verkada_token
				'X-Verkada-Auth'		=	$x_verkada_auth
			}
		} else {
			$headers=@{
				'x-verkada-auth'		= $x_verkada_auth_api
			}
		}

		if($query_params){
			$query = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
			foreach ($qp in $query_params.GetEnumerator()) {
				$query.add("$($qp.name)", "$($qp.value)")
			}
			$uri = [System.UriBuilder]"$url"
			$uri.Query = $query.ToString()
			$uri = $uri.Uri.OriginalString
			$url = $uri
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