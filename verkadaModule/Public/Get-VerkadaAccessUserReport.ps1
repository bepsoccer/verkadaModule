function Get-VerkadaAccessUserReport{
	<#
		.SYNOPSIS
		Returns a report of all doors a user has access to and by what means.

		.DESCRIPTION
		This function will return all the doors the user/s have access to, the credentials assigned to the user, the last time they accessed a door, and their group membership.  This function requires that a valid Verkada Access User object be submitted.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserReport.md

		.EXAMPLE
		Get-VerkadaAccessUser -userId 'c1cb427f-9ef4-4800-95ec-4a580bfa2bf1' | Get-VerkadaAccessUserReport.	The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Read-VerkadaAccessUsers | Get-VerkadaAccessUserReport -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'.	The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The Access user object the report will run against
		[Parameter(ValueFromPipeline, Position = 0)]
		[ValidateScript(
			{ 
				$requiredProperties=@("accessCards","accessCardsRaw","accessGroups","accessUserRoles","bluetoothAccess","companyName","created","deactivated","deleted","department","departmentId","email","emailVerified","employeeId","employeeTitle","employeeType","firstName","lastActiveAccess","lastLogin","lastName","middleName","mobileAccess","modified","name","organizationId","phone","provisioned","roleGrant","userCodes","userCodesRaw","userId","__typename")
				$members=Get-Member -InputObject $_ -MemberType NoteProperty
				$missingProperties=Compare-Object -ReferenceObject $requiredProperties -DifferenceObject $members.Name -PassThru -ErrorAction SilentlyContinue
				if (-not($missingProperties)){			
					$true               
				} else{	
					$missingProperties | ForEach-Object {
						Throw [System.Management.Automation.ValidationMetadataException] "Property: '$_' missing"
					} 
				}
			}
		)]
		[Object]$user,
		#The UUID of the organization the user belongs to
		[Parameter()]
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

		$accessLevels = Get-VerkadaAccessLevels
		$allDoors = Get-VerkadaAccessDoors
		$outUsers = @()
	}
	
	process {
		$user = $user | Select-Object userId,name,email,@{name='accessGroups';expression={$_.accessGroups.group}},accessCardsRaw,bluetoothAcces,mobileAccess,@{name='lastActiveAccess';expression={Get-Date -UnixTimeSeconds $_.lastActiveAccess}}

		$userDoors = @()
		$accessGroups = @()
		foreach ($group in $user.accessGroups){
			#find which access levels that group is a part of
			$acLevels =@()
			$acLevels += $accessLevels | Where-Object {$_.userGroups -contains $group.userGroupId}
			$accessGroups += $group.name

			#find which doors that access level has access to and schedule
			foreach ($level in $acLevels){
				$schedule = $level | Select-Object -ExpandProperty events
				$schedule = Get-HumanReadableSchedule $schedule

				$doors = $level | Select-Object -ExpandProperty doors
				foreach ($d in $doors){
					$ds = $allDoors | Where-Object {$_.doorId -eq $d} | Select-Object name,doorId,accessControllerId
					$ds | Add-Member -NotePropertyName 'siteName' -NotePropertyValue (Get-VerkadaAccessSite | Where-Object {$_.accessControllers -contains $ds.accessControllerId} | Select-Object -ExpandProperty name)
					$ds | Add-Member -NotePropertyName 'schedule' -NotePropertyValue $schedule
					$ds | Add-Member -NotePropertyName 'group' -NotePropertyValue $group.name
					$ds.PSObject.Properties.Remove('accessControllerId')
					$ds.PSObject.Properties.Remove('doorId')
					$userDoors += $ds
				}
			}
		}
		#$userDoors | Group-Object -Property siteName

		$user | Add-Member -NotePropertyName 'doors' -NotePropertyValue $userDoors
		$user.accessGroups = $accessGroups

		#retrieve access cards
		#needs to be done
		$outUsers += $user
	}
	
	end {
		return $outUsers
	}
}