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

	)

	Process {
		Remove-Variable -Name verkadaConnection -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaCameras -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaUsers -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaCameraModels -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaCameraGroups -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaAccessSites -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaAccessUsers -Scope Global -ErrorAction SilentlyContinue
	} #end process
} #end function