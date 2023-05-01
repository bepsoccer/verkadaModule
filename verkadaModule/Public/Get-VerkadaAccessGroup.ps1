function Get-VerkadaAccessGroup{
	<#
		.SYNOPSIS
		Gets all Access groups in an organization or a specific Access Group.

		.DESCRIPTION
		This function will return all the Access Groups in an organization if no parameters are specified.  If the name parameter is specified, it will attempt to retrieve the group matching the name.  If the groupId parameter is specified, it will attempt to retrieve the group matching the groupId.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessGroup.md

		.EXAMPLE
		Get-VerkadaAccessGroup.	The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessGroup -name "Executive Access".	The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessGroup -groupId "7858d17a-3f72-4506-8532-a4b6ba233c5e".	The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessGroup -name "Executive Access" -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'.	The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The name of the group being retrieved
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$Name,
		#The UUID of the group being retrieved
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$groupId,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		#The UUID of the user account making the request
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$usr = $Global:verkadaConnection.usr
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$url = 'https://vcerberus.command.verkada.com/user_groups/get'

		$groups = @()
	}
	
	process {
		$body_params = @{
			"organizationId"	= $org_id
		}

		try {
			$response = Invoke-VerkadaRestMethod $url $org_id $body_params -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -Method 'POST' -UnPwd

			foreach ($group in $response.children.psobject.Properties){
				$id = $group.name
				$newgroup = $group.value
				$newgroup | Add-Member -NotePropertyName groupId -NotePropertyValue $id
				$groups += $newgroup
			}
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			throw "$($err.StatusCode) - $($err.message)"
		}
	}
	
	end {
		if (!([string]::IsNullOrEmpty($groupId))){
			$groups = $groups | Where-Object {$_.groupId -eq $groupId}
		} elseif (!([string]::IsNullOrEmpty($Name))) {
			$groups = $groups | Where-Object {$_.name -eq $Name}
		}
		return $groups
	}
}