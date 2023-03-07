function Set-VerkadaCameraName
{
	<#
		.SYNOPSIS
		Set the name of a camera in an organization
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'email')]
	Param(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias("cameraId")]
		[String]$camera_id,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias("name")]
		[String]$camera_name,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken
	)

	Begin {
		$url = "https://vprovision.command.verkada.com/camera/name/set"
		$response = @()
	} #end begin
	
	Process {
		$body_params = @{
			"cameraId"				= $camera_id
			"name"						= $camera_name
		}
		
		$res = Invoke-VerkadaRestMethod $url $org_id $body_params -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -Method 'POST' -UnPwd
		$response += $res.cameras
	} #end process

	End {
		return $response
	}
} #end function