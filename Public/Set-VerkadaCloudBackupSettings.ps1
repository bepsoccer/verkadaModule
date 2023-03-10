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
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$camera_id,
		[Parameter(Position = 1)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Position = 2)]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key = $Global:verkadaConnection.token,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidatePattern("[0-1],[0-1],[0-1],[0-1],[0-1],[0-1],[0-1]")]
		[String]$days_to_preserve,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidatePattern("[0-1]")]
		[int]$enabled,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidatePattern("^(\d|[1-9]\d{1,3}|[1-7]\d{4}|8[0-3]\d{3}|84[0-5]\d{2}|84600),(\d|[1-9]\d{1,3}|[1-7]\d{4}|8[0-3]\d{3}|84[0-5]\d{2}|84600)$")]
		[String]$time_to_preserve,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidatePattern("^(\d|[1-9]\d{1,3}|[1-7]\d{4}|8[0-3]\d{3}|84[0-5]\d{2}|84600),(\d|[1-9]\d{1,3}|[1-7]\d{4}|8[0-3]\d{3}|84[0-5]\d{2}|84600)$")]
		[String]$upload_timeslot,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateSet("STANDARD_QUALITY","HIGH_QUALITY")]
		[String]$video_quality,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[ValidateSet("MOTION","ALL")]
		[String]$video_to_upload
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_api_key)) {throw "x_api_key is missing but is required!"}
		
		$url = "https://api.verkada.com/cameras/v1/cloud_backup/settings"
		$result = @()
		Write-Warning "Have you backed up your configs first? If not, consider halting and running Get-VerkadaCloudBackupSettings -backup" -WarningAction Inquire
	} #end begin

	Process {
		$body_params = @{
			'camera_id'					= $camera_id
			'org_id'						= $org_id
			'days_to_preserve'	= $days_to_preserve
			'enabled'						= $enabled
			'time_to_preserve'	= $time_to_preserve
			'upload_timeslot'		= $upload_timeslot
			'video_quality'			= $video_quality
			'video_to_upload'		= $video_to_upload
		}

		$query_params = @{
			'camera_id'					= $camera_id
		}

		Invoke-VerkadaRestMethod $url $org_id $x_api_key $query_params -body_params $body_params -method post
		$result += ($body_params | ConvertTo-Json | ConvertFrom-Json)
	} #end process

	End {
		return $result
	} #end end
} #end function