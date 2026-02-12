function Get-VerkadaAccessDoors{
	<#
		.SYNOPSIS
		Gets a list of door from Verkada Command using https://apidocs.verkada.com/reference/getaccessdoorinformationviewv1

		.DESCRIPTION
		Retrieves a list of all doors in the organization. The response can optionally be filtered to doors within sites with the requested site_ids or to the specific doors represented by the specified door_ids. Only one of site_ids or door_ids can be used to filter the response for a single request (not both). A successful response will contain one Door Information Object per corresponding undeleted door.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessDoors.md

		.EXAMPLE
		Get-VerkadaAccessDoors
		This will retrieve a list off all the doors in an Command org.  The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessDoors -door_ids cd6247e7-57ee-42e3-8a05-adeddba0ece8
		This will retrieve the door with door_id cd6247e7-57ee-42e3-8a05-adeddba0ece8.  The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessDoors -site_ids d8eedf08-38ae-4c92-a45f-4230624890d5 -x_verkada_auth_api 'v2_sd78dsVerkadaToken'
		This will retirve a list of doors from the site d8eedf08-38ae-4c92-a45f-4230624890d5.  The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'None')]
	[Alias("Get-VrkdaAcDoors","g-VrkdaAcDoors")]
	param (
		#The UUID of the door/s
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DoorId')]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias("door_id","doorId","doorIds")]
		[String[]]$door_ids,
		#The UUID of the site/s you want to retrieve doors from
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'SiteId')]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias("site_id","siteId","siteIds")]
		[String[]]$site_ids,
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api,
		#The region of the public API to be used
		[Parameter()]
		[ValidateSet('api','api.eu','api.au')]
		[String]$region='api',
		#Switch to write errors to file
		[Parameter()]
		[switch]$errorsToFile
	)
	
	begin {
		$url = "https://$($region).verkada.com/access/v1/doors"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		$body_params = @{}
		
		$query_params = @{}
		if (!([string]::IsNullOrEmpty($door_ids))){$query_params.door_ids = $door_ids -join ","}
		if (!([string]::IsNullOrEmpty($site_ids))){$query_params.site_ids = $site_ids -join ","}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method GET
			return $response.doors
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force
			$msg = "$($err.StatusCode) - $($err.message)"
			$msg += ": $(($query_params + $body_params) | ConvertTo-Json -Compress)"
			Write-Error $msg
			$myErrors += $msg
			$msg = $null
		}
		catch [VerkadaRestMethodException] {
			$msg = $_.ToString()
			$msg += ": $(($query_params + $body_params) | ConvertTo-Json -Compress)"
			Write-Error $msg
			$myErrors += $msg
			$msg = $null
		}
	} #end process
	
	end {
		if ($errorsToFile.IsPresent){
			if (![string]::IsNullOrEmpty($myErrors)){
				Get-Date | Out-File ./errors.txt -Append
				$myErrors | Out-File ./errors.txt -Append
			}
		}
	} #end end
} #end function