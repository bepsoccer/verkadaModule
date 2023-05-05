function Get-VerkadaAccessGroup{
	<#
		.SYNOPSIS
		Gets all Access groups in an organization or a specific Access Group.

		.DESCRIPTION
		This function will return all the Access Groups in an organization if no parameters are specified.  If the name parameter is specified, it will attempt to retrieve the group matching the name.  If the groupId parameter is specified, it will attempt to retrieve the group matching the groupId.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessGroup.md

		.EXAMPLE
		Get-VerkadaAccessGroup
		This will return all the Access Groups in an organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessGroup -name "Executive Access"
		This will return the Access Group named "Executive Access".  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessGroup -groupId "7858d17a-3f72-4506-8532-a4b6ba233c5e"
		This will return the Access Group with userId "7858d17a-3f72-4506-8532-a4b6ba233c5e".  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessGroup -name "Executive Access" -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will return the Access Group named "Executive Access".  The org_id and tokens are submitted as parameters in the call.
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
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}

		$url = 'https://vcerberus.command.verkada.com/user_groups/get'

		$groups = @()
	} #end begin
	
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
	} #end process
	
	end {
		if (!([string]::IsNullOrEmpty($groupId))){
			$groups = $groups | Where-Object {$_.groupId -eq $groupId}
		} elseif (!([string]::IsNullOrEmpty($Name))) {
			$groups = $groups | Where-Object {$_.name -eq $Name}
		}
		return $groups
	} #end end
} #end function