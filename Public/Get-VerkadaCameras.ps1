function Get-VerkadaCameras
{
	<#
		.SYNOPSIS
		Gets all cameras in an organization
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0)]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Position = 1)]
		[String]$x_api_key = $Global:verkadaConnection.token

	)

	Begin {
		$url = "https://api.verkada.com/cameras/v1/devices"
		$page_size = 100
		$propertyName = 'cameras'
		if (!($org_id)){Write-Warning 'Missing org_id which is required'; return}
		if (!($x_api_key)){Write-Warning 'Missing API token which is required'; return}
	} #end begin
	
	Process {
		Invoke-VerkadaRestMethod $url $org_id $x_api_key -pagination -page_size $page_size -propertyName $propertyName
	} #end process
} #end function