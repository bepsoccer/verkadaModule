function Add-VerkadaAccessUserToGroup
{
	<#
		.SYNOPSIS
		Adds an Access User to an Access Group in an organization
		.DESCRIPTION
		This function is used to add a Verkada Access user to a group or groups.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		.EXAMPLE
		Add-VerkadaAccessUserToGroup -userid 'dcscsdc-dsc-user1' -groupId 'df76sd-dsc-group1','dsf987-daf-group2'
		This will add the userid dcscsdc-dsc-user1 to access groups df76sd-dsc-group1 and dsf987-daf-group2.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		.EXAMPLE
		Add-VerkadaAccessUserToGroup -userid 'dcscsdc-dsc-user1' -groupId 'df76sd-dsc-group1','dsf987-daf-group2' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will add the userid dcscsdc-dsc-user1 to access groups df76sd-dsc-group1 and dsf987-daf-group2.  The org_id and tokens are submitted as parameters in the call.
	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'email')]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The UUID of the user the badge is being added to
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String[]]$userId,
		#The UUID of the group or groups the user should be added to
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'groupId')]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String[]]$groupId,
		#The name of the group or groups the user should be added to on creation(not currently implemented)
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'groupName')]
		[String[]]$groupName,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		#Number of threads allowed to multi-thread the task
		[Parameter()]
		[ValidateRange(1,4)]
		[int]$threads=$null
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		
		$url = "https://vcerberus.command.verkada.com/user_groups/bulk_add_users"
	} #end begin
	
	Process {
		$body_params = @{
			"userIds"					= $userId
			"organizationId"	= $org_id
			"groupIds"				= $groupId
		}

		try {
			Invoke-VerkadaRestMethod $url $org_id $body_params -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -Method 'POST' -UnPwd
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			throw "$($err.StatusCode) - $($err.message)"
		}
	} #end process

	End {
		
	}
} #end function