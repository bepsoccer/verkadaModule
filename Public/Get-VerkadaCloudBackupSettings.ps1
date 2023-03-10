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
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$camera_id,
		[Parameter(Position = 1)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Position = 2)]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key = $Global:verkadaConnection.token,
		[Parameter()]
		[Switch]$backup
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_api_key)) {throw "x_api_key is missing but is required!"}
	
		$url = "https://api.verkada.com/cameras/v1/cloud_backup/settings"
		$response = @()
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