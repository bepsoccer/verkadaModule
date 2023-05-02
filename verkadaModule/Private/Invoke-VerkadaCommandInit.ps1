function Invoke-VerkadaCommandInit {

	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		#The UUID of the user account making the request
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$usr = $Global:verkadaConnection.usr
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$url = 'https://vappinit.command.verkada.com/app/init'
	}
	
	process {
		$cookies = @{
			'auth'	= $x_verkada_auth
			'org'		= $org_id
			'token'	= $x_verkada_token
			'usr'		= $usr
		}

		$headers=@{
			'x-verkada-token'						= $x_verkada_token
			'x-verkada-user-id'					=	$usr
		}

		$session = New-WebSession $cookies $url

		$loop = $false
		$rt = 0
		do {
			try {
				$response = Invoke-RestMethod -Uri $url -ContentType 'application/json' -WebSession $session -Method 'POST' -Headers $headers -TimeoutSec 120
				
				$verkadaCameraGroups = $response.cameraGroups | Select-Object -Property name,cameraGroupId,organizationId,created,cameraGroups
				$accessSites = $response.cameraGroups | Select-Object -Property name,cameraGroupId,organizationId,accessControllers,accessLevels,accessLockdowns,accessReaders
				Set-Variable -Name 'verkadaCameraGroups' -Scope Global -Value $verkadaCameraGroups
				Set-Variable -Name 'verkadaCameraModels' -Scope Global -Value $response.models
				Set-Variable -Name 'verkadaAccessSites' -Scope Global -Value $accessSites

				$loop = $true
				return $response
			}
			catch [System.TimeoutException] {
				$rt++
				if ($rt -gt 2){
					$loop = $true
				}
				else {
					Start-Sleep -Seconds 5
				}
			}
		}
		while ($loop -eq $false)
	}
	
	end {
		
	}
}