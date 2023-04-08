function Disconnect-Verkada
{
	<#
		.SYNOPSIS
		Removes cached credentials for Verkada's API Enpoints
		
		.DESCRIPTION
		This function is used to removed stored org_id, tokens, and cached data from the session.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Disconnect-Verkada.md

		.EXAMPLE
		Disconnect-Verkada
	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		#The UUID of the organization the user belongs to(not implemented)
		[Parameter(Position = 0)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id
	)

	Process {
		Remove-Variable -Name verkadaConnection -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaCameras -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaUsers -Scope Global -ErrorAction SilentlyContinue
	} #end process
} #end function