function Set-VerkadaCloudBackupSettings
{
	<#
		.SYNOPSIS
		Sets a camera's cloud backup settings
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
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$days_to_preserve,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[int]$enabled,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$time_to_preserve,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$upload_timeslot,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$video_quality,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$video_to_upload
	)

	Begin {
		$uri = "https://api.verkada.com/cameras/v1/cloud_backup/settings"
		$response = @()
		if (!($org_id)){Write-Warning 'missing org_id'; return}
		if (!($x_api_key)){Write-Warning 'missing API token'; return}
		Write-Warning "Have you backed up your configs first? If not, consider halting and running Get-VerkadaCloudBackupSettings -backup" -WarningAction Inquire
	} #end begin

	Process {
		$body_params = @{
			'camera_id'					= $camera_id
			'days_to_preserve'	= $days_to_preserve
			'enabled'						= $enabled
			'time_to_preserve'	= $time_to_preserve
			'upload_timeslot'		= $upload_timeslot
			'video_quality'			= $video_quality
			'video_to_upload'		= $video_to_upload
		}

		$response += Invoke-VerkadaRestMethod $uri $org_id $x_api_key $body_params -method post
	} #end process

	End {
		return $response
	} #end end
} #end function