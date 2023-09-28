function Read-VerkadaAccessGroups{
	<#
		.SYNOPSIS
		Gets all the Access groups in an organization using https://apidocs.verkada.com/reference/getaccessgroupsviewv1

		.DESCRIPTION
		Retrieves a list of all access groups in a given organization. The response is a list of Access Group Objects.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Read-VerkadaAccessGroups.md

		.EXAMPLE
		Read-VerkadaAccessGroups
		This will return aa the Access Groups.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Read-VerkadaAccessGroups -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_api_key 'sd78ds-uuid-of-verkada-token'
		This will return aa the Access Groups.  The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	[Alias("Read-VrkdaAcGrps","rd-VrkdaAcGrps")]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The public API key to be used for calls that hit the public API gateway
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key = $Global:verkadaConnection.token,
		#Switch to write errors to file
		[Parameter()]
		[switch]$errorsToFile
	)
	
	begin {
		$url = "https://api.verkada.com/access/v1/access_groups"
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_api_key)) {throw "x_api_key is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		$body_params = @{}
		
		$query_params = @{}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $org_id $x_api_key $query_params -body_params $body_params -method GET
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