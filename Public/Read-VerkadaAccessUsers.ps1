function Read-VerkadaAccessUsers
{
	<#
		.SYNOPSIS
		Gathers all Access Users in an organization
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0)]
		[String]$org_id = $Global:verkadaConnection.org_id

	)

	Begin {
		$url = "https://vcerberus.command.verkada.com/get_users"
		if (!($org_id)){Write-Warning 'Missing org_id which is required'; return}
		if (!($Global:verkadaConnection)){Write-Warning 'Missing auth token which is required'; return}
		if ($Global:verkadaConnection.authType -ne 'UnPwd'){Write-Warning 'Un/Pwd auth is required'; return}
	} #end begin
	
	Process {
		$body_params =@{
			"organizationId"	= $org_id
		}
		Invoke-VerkadaRestMethod $url $org_id $body_params -Method Post -UnPwd
	} #end process
} #end function