function Get-VerkadaCloudBackupSettings
{
	<#
		.SYNOPSIS
		Gets a camera's cloud backup settings
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
		[String]$camera_id,
		[Parameter(Position = 1)]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Position = 2)]
		[String]$x_api_key = $Global:verkadaConnection.token,
		[Parameter()]
		[Switch]$backup
	)

	Begin {
		$url = "https://api.verkada.com/cameras/v1/cloud_backup/settings"
		$response = @()
		if (!($org_id)){Write-Warning 'missing org_id'; return}
		if (!($x_api_key)){Write-Warning 'missing API token'; return}
	} #end beging
	
	Process {
		$query_params = @{
			'camera_id' = $camera_id
		}

		$response += Invoke-VerkadaRestMethod $url $org_id $x_api_key $query_params
	} #end process

	End {
		if ($backup){
			try {
				$response | Export-Csv -Path (Read-Host 'Enter full path where CSV should be saved with filename')
			} catch {
				Write-Warning 'A valid path and file name is required so the command will now terminate'
				exit
			}
		}
		return $response
	} #end end
} #end function