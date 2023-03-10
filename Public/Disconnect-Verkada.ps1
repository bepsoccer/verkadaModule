function Disconnect-Verkada
{
	<#
		.SYNOPSIS
		Removes cached credentials for Verkada's API Enpoints
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		# Parameter help description
		[Parameter(Position = 0)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id
	)

	Process {
		Remove-Variable -Name verkadaConnection -Scope Global -ErrorAction SilentlyContinue
		Remove-Variable -Name verkadaCameras -Scope Global -ErrorAction SilentlyContinue
	} #end process
} #end function