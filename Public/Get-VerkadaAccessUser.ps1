function Get-VerkadaAccessUser
{
	<#
		.SYNOPSIS
		Gets an Access User in an organization by userId
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0)]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
		[String]$userId,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken

	)

	Begin {
		#if (!($org_id)){Write-Warning 'Missing org_id which is required'; return}
		#if (!($Global:verkadaConnection)){Write-Warning 'Missing auth token which is required'; return}
		#if ($Global:verkadaConnection.authType -ne 'UnPwd'){Write-Warning 'Un/Pwd auth is required'; return}
	} #end begin
	
	Process {
		$url = "https://vcerberus.command.verkada.com/user/$org_id/$userId"

		Invoke-VerkadaRestMethod $url $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -UnPwd
	} #end process
} #end function