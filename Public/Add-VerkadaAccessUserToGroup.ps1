function Add-VerkadaAccessUserToGroup
{
	<#
		.SYNOPSIS
		Adds an Access User to an Access Group in an organization
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'email')]
	Param(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[String[]]$userId,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'groupId')]
		[String[]]$groupId,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'groupName')]
		[String[]]$groupName,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		[Parameter()]
		[int]$threads=$null

	)

	Begin {
		#if (!($org_id)){Write-Warning 'Missing org_id which is required'; return}
		#if (!($Global:verkadaConnection)){Write-Warning 'Missing auth token which is required'; return}
		#if ($Global:verkadaConnection.authType -ne 'UnPwd'){Write-Warning 'Un/Pwd auth is required'; return}

		$url = "https://vcerberus.command.verkada.com/user_groups/bulk_add_users"
	} #end begin
	
	Process {
		$body_params = @{
			"userIds"					= $userId
			"organizationId"	= $org_id
			"groupIds"				= $groupId
		}

		Invoke-VerkadaRestMethod $url $org_id $body_params -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -Method 'POST' -UnPwd

	} #end process

	End {
		
	}
} #end function