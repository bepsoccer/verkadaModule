function Add-VerkadaCommandSite {
	<#
		.SYNOPSIS
		Adds a site to an organization
		
		.DESCRIPTION
		Used to bulk add sites to an organization with the desired name.  This function takes pipeline paramters making it easy to add mulitple sites via csv with the desired named out of the gate.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaCommandSite.md

		.EXAMPLE
		Add-VerkadaCommandSite -name 'My New Site'
		This will add the new site with the name "My New Site".  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaCommandSite -name 'My New Sub-Site' -parentSiteId '919dedeb-b3fe-420c-b663-ce44cbfd1c1e'
		This will add the new sub-site with the name "My New Sub-Site" in the parent site with ID '919dedeb-b3fe-420c-b663-ce44cbfd1c1e'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Add-VerkadaCommandSite -name 'My New Site' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will add the new site with the name "My New Site".  The org_id and tokens are submitted as parameters in the call.
	#>

	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The name of the site or sub-site being added
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[String]$name,
		#The parentSiteId(parentCameraGroupId) of the sub-site being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias("parentCameraGroupId")]
		[String]$parentSiteId,
		#The parentSiteName of the sub-site being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$parentSiteName,
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

		$url = 'https://vprovision.command.verkada.com/org/camera_group/create'
		$created =@()
	}
	
	process {
		$body = @{
			'organizationId'	=	$org_id
			'name'						= $name
		}

		if (!([string]::IsNullOrEmpty($parentSiteId))) {
			#get siteID of parent and set it here
			$body.parentCameraGroupId	=	$parentSiteId
		} elseif (!([string]::IsNullOrEmpty($parentSiteName))){
			$g = Get-VerkadaCameraGroup $parentSiteName -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr
			if ($g.count -lt 1){
				$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
				$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
				$cancel = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel","Description."
				$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $cancel)

				$title = "No site found by the name $parentSiteName"
				$message = "Would you like to create it?"
				$result = $host.ui.PromptForChoice($title, $message, $options, 1)
				switch ($result) {
					0{
						$temp = Add-VerkadaCommandSite -name $parentSiteName -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr
						$parentSiteId = $temp.cameraGroupId
						$body.parentCameraGroupId	=	$parentSiteId
					}1{
						Write-Warning "No parent site ($parentSiteName) created, so no site name $name will be created"
						return
					}2{
						Write-Host -ForegroundColor Red "Exiting invocation"
						Exit
					}
				}
			} else {
				$parentSiteId = $g.cameraGroupId
				$body.parentCameraGroupId	=	$parentSiteId
			}
		}

		$body = $body | ConvertTo-Json -Depth 10 | ConvertFrom-Json

		try {
			$response = Invoke-VerkadaCommandCall $url $org_id $body -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -Method 'POST' | Select-Object -ExpandProperty cameraGroups | Select-Object -Property name,cameraGroupId,organizationId,created,cameraGroups
			if ($Global:verkadaCameraGroups){
				$Global:verkadaCameraGroups += $response
			} else {
				Invoke-VerkadaCommandInit | Out-Null
				$Global:verkadaCameraGroups += $response
			}
			if ($temp){
				$temp.cameraGroups += $response.cameraGroupId
				$created += $temp
			}
			Remove-Variable -Name temp -ErrorAction SilentlyContinue
			$created += $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			Write-Host "Site $name not added because:  $($err.StatusCode) - $($err.message)" -ForegroundColor Red
			Return
		}
	}
	
	end {
		return $created
	}
}