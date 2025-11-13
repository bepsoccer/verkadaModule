function Read-VerkadaAccessGroups{
	<#
		.SYNOPSIS
		Gets all the Access groups in an organization using https://apidocs.verkada.com/reference/getaccessgroupsviewv1

		.DESCRIPTION
		Retrieves a list of all access groups in a given organization. The response is a list of Access Group Objects.
		The reqired token can be directly submitted as a parameter, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Read-VerkadaAccessGroups.md

		.EXAMPLE
		Read-VerkadaAccessGroups
		This will return aa the Access Groups.  The token will be populated from the cache created by Connect-Verkada.

		.EXAMPLE
		Read-VerkadaAccessGroups -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will return aa the Access Groups.  The token is submitted as a parameter in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Read-VrkdaAcGrps","rd-VrkdaAcGrps")]
	param (
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
		$url = "https://$($region).verkada.com/access/v1/access_groups"
		#parameter validation
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		$body_params = @{}
		
		$query_params = @{}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $x_verkada_auth_api $query_params -body_params $body_params -method GET
			if (![string]::IsNullOrEmpty($response.access_groups)) {$response = $response.access_groups}
			return $response
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