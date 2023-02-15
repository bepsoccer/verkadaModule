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
		[String]$uri,
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Default')]
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Pagination')]
		[String]$org_id,
		[Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'Default')]
		[Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'Pagination')]
		[String]$x_api_key,
		[Parameter(Position = 3, ParameterSetName = 'Default')]
		[Parameter(Position = 3, ParameterSetName = 'Pagination')]
		[Object]$body_params,
		[Parameter(ParameterSetName = 'Default')]
		[Parameter(ParameterSetName = 'Pagination')]
		[String]$method = 'GET',
		[Parameter(Mandatory = $true, ParameterSetName = 'Pagination')]
		[switch]$pagination,
		[Parameter(Mandatory = $true, ParameterSetName = 'Pagination')]
		[String]$page_size,
		[Parameter(Mandatory = $true, ParameterSetName = 'Pagination')]
		[String]$propertyName

	)

	Process {
		$body = @{
			'org_id' = $org_id
		}
		if ($body_params){$body += $body_params}
		$headers=@{
			'x-api-key' = $x_api_key
		}

		if ($pagination){
			$body.page_size = $page_size
			$body.page_token = "1"
			$records = @()
			Do {
				$response = Invoke-RestMethod -Uri $uri -Body $body -Headers $headers
				$records += $response.($propertyName)
				$body.page_token = $response.next_page_token
			} While ($body.page_token)
			return $records
		} else {
			$response = Invoke-RestMethod -Uri $uri -Body $body -Headers $headers -Method $method
			return $response
		}
		
	} #end process
} #end function