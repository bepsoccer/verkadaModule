function Get-VerkadaAccessUserReport{
	<#
		.SYNOPSIS
		Returns a report of all doors a user has access to and by what means.

		.DESCRIPTION
		This function will return all the doors the user/s have access to, the credentials assigned to the user, the last time they accessed a door, and their group membership.  This function requires that a valid Verkada Access User object be submitted.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUserReport.md

		.EXAMPLE
		Get-VerkadaAccessUser -userId 'c1cb427f-9ef4-4800-95ec-4a580bfa2bf1' | Get-VerkadaAccessUserReport
		This will get the Acces user object for userId c1cb427f-9ef4-4800-95ec-4a580bfa2bf1 and return the access report for that user.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessUser -userId 'c1cb427f-9ef4-4800-95ec-4a580bfa2bf1' | Get-VerkadaAccessUserReport -beautify | Export-Csv ~/Desktop.ACusersReport.csv -NoTypeInformation
		This will get the Acces user object for userId c1cb427f-9ef4-4800-95ec-4a580bfa2bf1 and return the access report for that user in a consumeable way for a csv report.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Get-VerkadaAccessUser -userId 'c1cb427f-9ef4-4800-95ec-4a580bfa2bf1' | Get-VerkadaAccessUserReport -outReport
		This will get the Acces user object for userId c1cb427f-9ef4-4800-95ec-4a580bfa2bf1 and return the access report for that user in a pretty HTML file.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Read-VerkadaAccessUsers | Get-VerkadaAccessUserReport -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will get all the Acces user objects in an organization and return the access report for that user.  The org_id and tokens are submitted as parameters in the call.
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
		[string]$usr = $Global:verkadaConnection.usr,
		#This is a switch to indicate we're gonna try to make the report prettier
		[Parameter()]
		[switch]$beautify,
		#This is a switch to indicate we're gonna try to make the report a pretty html
		[Parameter()]
		[switch]$outReport,
		#Number of threads allowed to multi-thread the task
		[Parameter()]
		[ValidateRange(1,20)]
		[int]$threads=10
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$accessLevels = Get-VerkadaAccessLevels -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr
		$allDoors = Get-VerkadaAccessDoors -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr
		$accessSites = Get-VerkadaAccessSite -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr
		$outUsers = @()

		if($beautify.IsPresent){$beautify = $true} else {$beautify = $false}
		if($outReport.IsPresent){$outReport = $true} else {$outReport = $false}

		$helpers = {
			Import-Module verkadaModule
			#some helper functions
			function prettyGrouping {
				param (
					$myInput,
					$groupProperty1,
					$groupProperty2,
					$groupProperty3
				)
				$temp = @()
				$myInput | Group-Object -Property $groupProperty1 | ForEach-Object {$ob = @{"$($_.Name.toString())"=$_.Group;};$ob = $ob | ConvertTo-Json -Depth 10 | ConvertFrom-Json; $temp += $ob}
				$temp = groupRemoveProp $temp $groupProperty1
				foreach ($group in $temp){
					$temp2 = @()
					$group.($group.psobject.Properties.name) | Group-Object -Property $groupProperty2 | ForEach-Object {$ob = @{"$($_.Name.toString())"=$_.Group;};$ob = $ob | ConvertTo-Json -Depth 10 | ConvertFrom-Json; $temp2 += $ob}
					$temp2 = groupRemoveProp $temp2 $groupProperty2
					foreach ($group2 in $temp2){
						$temp3 = @()
						$group2.($group2.psobject.Properties.name) | Group-Object -Property $groupProperty3 | ForEach-Object {$ob = @{"$($_.Name.toString())"=$_.Group;};$ob = $ob | ConvertTo-Json -Depth 10 | ConvertFrom-Json; $temp3 += $ob}
						$temp3 = groupRemoveProp $temp3 $groupProperty3
						foreach ($name in $temp3){
							$names = $name.($name.psobject.Properties.name) | Select-Object -ExpandProperty name
							$name.($name.psobject.Properties.name) = $names
						}
						$group2.($group2.psobject.Properties.name) = $temp3
					}
					$group.($group.psobject.Properties.name) = $temp2
				}
				return $temp | ConvertTo-Json -Depth 10 -Compress
			}
			
			function groupRemoveProp {
				param (
					$myInput,
					$groupingProp
				)
				foreach ($group in $myInput){
					$thing = $group.($group.psobject.Properties.name)
					foreach ($prop in $thing){
						$prop.PSObject.Properties.Remove($groupingProp)
					}
				}
				return $myInput
			}

			function listFormatter {
				param (
					$myInput,
					$level=1,
					$arrayItem,
					$open,
					$close
				)
				switch ($level) {
					default {}
					1 {$class = 'group'}
					2 {$class = 'site'}
					3 {$class = 'sched'}
					4 {$class = 'door'}
				}
				$s=''
				if ($myInput.GetType().baseType.name -eq 'Array'){
					for($i=0; $i -lt $myInput.count; $i++) {
						$close=$false
						$open=$false
						if($i -eq $($($myInput.count)-1)){
							$close = $true
						} elseif ($i -eq 0) {
							$open = $true
						}
						listFormatter $myInput[$i] $level $true $open $close
					}
				} elseif ($myInput.GetType().name -eq 'String') {
					if (!($arrayItem) -or $open){
						$s+="<ul>"
					}
					$s+="<li class=`"$class`">$myInput</li>"
					if (!($arrayItem) -or $close){
						$s+="</ul></ul></ul>"
					}
					$s
				} else {
					if($level -eq 1){
						$s+="<li class=`"$class`">$($myInput.psobject.Properties.name)</li>"
					} else {
						$s+="<ul><li class=`"$class`">$($myInput.psobject.Properties.name)</li>"
					}
					$s
					$level++
					listFormatter $myInput.($myInput.psobject.Properties.name) $level
				}
			}

			function jsonToList {
				param (
					$myJson
				)
				$json = $myJson | ConvertFrom-Json
				$s='<ul>'
				$s += (listFormatter $Json)
				$s+="</ul>"
				return $s
			}
		}

		$jobs = @()

	} #end begin
	
	process {
		$jobs += Start-ThreadJob -InitializationScript $helpers -ThrottleLimit $threads -ScriptBlock {
			$user = $using:user | Select-Object userId,name,email,@{name='accessGroups';expression={$_.accessGroups.group}},accessCards,bluetoothAccess,mobileAccess,@{name='lastActiveAccess';expression={Get-Date -UnixTimeSeconds $_.lastActiveAccess}}

			$userDoors = @()
			$accessGroups = @()
			foreach ($group in $user.accessGroups){
				#find which access levels that group is a part of
				$acLevels =@()
				$acLevels += $using:accessLevels | Where-Object {$_.userGroups -contains $group.userGroupId}
				$accessGroups += $group.name

				#find which doors that access level has access to and schedule
				foreach ($level in $acLevels){
					$schedule = $level | Select-Object -ExpandProperty events
					$schedule = Get-HumanReadableSchedule $schedule

					$doors = $level | Select-Object -ExpandProperty doors
					foreach ($d in $doors){
						$ds = $using:allDoors | Where-Object {$_.doorId -eq $d} | Select-Object name,doorId,accessControllerId
						$ds | Add-Member -NotePropertyName 'siteName' -NotePropertyValue ($using:accessSites | Where-Object {$_.accessControllers -contains $ds.accessControllerId} | Select-Object -ExpandProperty name)
						$ds | Add-Member -NotePropertyName 'schedule' -NotePropertyValue $schedule
						$ds | Add-Member -NotePropertyName 'group' -NotePropertyValue $group.name
						$ds.PSObject.Properties.Remove('accessControllerId')
						$ds.PSObject.Properties.Remove('doorId')
						$userDoors += $ds
					}
				}
			}
			$user.accessGroups = $accessGroups
			
			if ($using:beautify -or $using:outReport){
				$userDoors = prettyGrouping $userDoors 'group' 'siteName' 'schedule'
				$user.accessGroups = $user.accessGroups | ConvertTo-Json #-Compress
				if ($user.accessCards){
					try {
						#retrieve access cards
						$creds = Get-VerkadaAccessCredential -userId $user.userId -org_id $using:org_id -x_verkada_token $using:x_verkada_token -x_verkada_auth $using:x_verkada_auth -usr $using:usr
						$user.accessCards = $creds.accessCards | Select-Object active,cardType,cardParams,@{name='lastUsed';expression={Get-Date -UnixTimeSeconds $_.lastUsed}} | ConvertTo-Json #-Compress
					} catch {

					}
				}

				if($using:outReport){
					if($userDoors){
						$userDoors = jsonToList $userDoors
					}
					$user.PSObject.Properties.Remove('userId')
				}
			}
			$user | Add-Member -NotePropertyName 'doors' -NotePropertyValue $userDoors
			$user
		}
		#$outUsers += $user
	} #end process
	
	end {
		$outUsers = $jobs | Receive-Job -AutoRemoveJob -Wait -WarningVariable +w -ErrorVariable +e
		foreach ($line in $w){Write-Output "Warning: $line"}
		foreach ($line in $e){Write-Output "Error: $line"}
		Remove-Variable -Name w -ErrorAction SilentlyContinue
		Remove-Variable -Name e -ErrorAction SilentlyContinue

		#$outUsers = $jobs
		$outUsers
		if ($outReport){
			function testReportPath {
				param ()
				$filePath = Read-Host -Prompt 'Please provide the path for the AC report to be saved to.'
				try {
					Get-ChildItem -Path $filePath -ErrorAction Stop | Out-Null
					return $filePath
				}
				catch {
					Write-Warning $_.Exception.Message
					testReportPath
				}
			}
			$reportFile = testReportPath
			$reportFile = (Get-Item $reportFile).fullName + "/ACuserReport-$(Get-Date -Format MMddyyyy).html"

			$Head = @"
<style>
	body {
		font-family: "Arial";
		font-size: 11pt;
		color: #4C607B;
		background-color: #F5F5F5;
		margin-top: 50px;
	}
	table {
		border-collapse: collapse;
	}
	th, td { 
		max-width: 550px;
	}
	th {
		font-size: 12pt;
		text-align: left;
		background-color: #F1F1F1;
		color: #949BA0;
		font-weight: bold;
		position: sticky;
		top: 0;
	}
	td {
		color: #949BA0;
		vertical-align: top;
		padding-top: 10px;
	}
	td:first-child {
			width: 300px;
			color: #000000;
	}
	td:nth-child(3),
	td:nth-child(4),
	td:nth-child(5),
	td:nth-child(6) {
		padding: 10px;
	}
	td:nth-child(4),
	td:nth-child(5){
		width: 100px;
	}
	tr:hover td {
		Background-Color: #F5FBFE;
		Color: #51B9ED;
	}
	tr:nth-child(odd) {
		Background-Color: #F8F8F8;
	}
	tr:nth-child(even) {
		Background-Color: #FFFFFF;
	}
	pre {
		white-space: pre-wrap;
	}
	#myInput {
		background-image: url('data:image/svg+xml;utf8,<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="26" height="26" viewBox="0 0 26 26"><g fill="none" fill-rule="evenodd"><path d="M11.65 20.21c-4.78 0-8.65-3.77-8.65-8.4s3.87-8.4 8.65-8.4a8.53 8.53 0 0 1 8.64 8.4c0 4.63-3.86 8.4-8.64 8.4z" stroke="%23949BA0" stroke-width="2"></path><path d="M17.34 17.96a1.43 1.43 0 0 1 1.98 0l3.7 3.64a1.35 1.35 0 0 1 0 1.93l.06-.05a1.43 1.43 0 0 1-1.99 0l-3.7-3.63a1.35 1.35 0 0 1 0-1.93l-.06.04z" fill="%23949BA0"></path></g></svg>');
		background-position: 10px 10px;
		background-repeat: no-repeat;
		width: 375px;
		padding: 12px 20px 12px 40px;
		border: none;
		margin-bottom: 12px;
		Background-Color: #FFFFFF;
		font-family: "Arial";
		font-size: 11pt;
		color: #4C607B;
	}
	::placeholder {
		color: #949BA0;
		font-family: "Arial";
		font-size: 11pt;
	}
	#myInput:focus{
		font-family: "Arial";
		font-size: 11pt;
		color: #4C607B;
		border: none;
		outline: none;
	}
	h2 {
		color: #949BA0;
	}
	li.group {
		list-style-image: url('data:image/svg+xml;utf8,<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="14" height="14" viewBox="0 0 26 26"><g fill-rule="evenodd" fill="%23949BA0"><path d="M17.07 3.6c3.25 0 5.11 1.92 4.64 6.24-.45 4.16-2.52 4.3-2.27 5.27.23.9 5.7.13 6.45 4.16.06.3 0 .97-.86.97h-5.51c-.65-2.17-2.29-3.47-4.54-4.17a12.12 12.12 0 0 0-.52-.15c.54-1.03.9-2.25 1.07-3.76.35-3.2-.43-5.65-2.13-7.12.81-.98 2.07-1.44 3.67-1.44z"></path><path d="M1.05 22.32c-.98 0-1.05-.71-.98-1.02.78-3.98 6.21-3.21 6.44-4.1.25-.98-1.82-1.12-2.27-5.28-.47-4.32 1.39-6.24 4.64-6.24S14 7.6 13.53 11.92c-.45 4.16-2.53 4.3-2.28 5.27.24.9 5.7.12 6.46 4.16.05.3 0 .97-.87.97H1.05z" fill-rule="nonzero"></path></g></svg>');
	}
	li.site {
		list-style-image: url('data:image/svg+xml;utf8,<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" height="18" viewBox="0 0 24 24" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.09 11.09C3.38 6.36 7.07 2 12 2s8.62 4.36 7.91 9.09c-.8 5.45-6.36 10.07-7.64 10.84-.08.05-.17.07-.27.07s-.19-.02-.27-.07c-1.27-.77-6.83-5.38-7.64-10.85zM12 20.91c1.47-1.05 6.21-5.16 6.92-9.98a6.87 6.87 0 0 0-1.6-5.5A7.03 7.03 0 0 0 12 3.01a7 7 0 0 0-5.32 2.43 6.87 6.87 0 0 0-1.6 5.5c.71 4.85 5.49 8.97 6.92 9.98zM8 10a4 4 0 1 1 8 0 4 4 0 1 1-8 0zm1 0a3.01 3.01 0 0 0 3 3c1.65 0 3-1.34 3-3a3.01 3.01 0 0 0-3-3 3 3 0 0 0-3 3z" fill="%23949BA0"></path></svg>');
	}
	li.sched {
		list-style-image: url('data:image/svg+xml;utf8,<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" height="18" viewBox="0 0 24 24" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M20 4h-3V2h-1v2H8V2H7v2H4a2 2 0 0 0-2 2v14c0 1.1.9 2 2 2h16a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2zm-4 3H8V5h8v2zM3 6a1 1 0 0 1 1-1h3v2H3V6zm18 14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V8h18v12zm0-13h-4V5h3a1 1 0 0 1 1 1v1zm-7 4h-3v1h3v-1zm-3 3h3v1h-3v-1zm5 0h3v1h-3v-1zm0-3h3v1h-3v-1zm3 6h-3v1h3v-1zm-8 0h3v1h-3v-1zm-6 2v-9h4v9H5zm1-8v7h2v-7H6z" fill="%23949BA0"></path></svg>');
	}
	li.door{
		list-style-image: url('data:image/svg+xml;utf8,<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="11" height="16" viewBox="0 0 21 31" fill="none"><path d="M13.54 1.22L1.34 2.98a.4.4 0 0 0-.34.4v24.9a.4.4 0 0 0 .36.4l12.2 1.18a.4.4 0 0 0 .44-.4V1.61a.4.4 0 0 0-.46-.39z" stroke="%23949BA0" stroke-width="2"></path><path d="M17.6 3.37v-1 1zm0 24.68v-1 1zm0-25.68H14v2h3.6v-2zm-3.59 26.68h3.6v-2H14v2zm6-2.4V4.56h-2v22.09h2zm-2.4 2.4c.32 0 .65 0 .91-.03s.68-.1 1.02-.44c.33-.33.4-.75.44-1.01.03-.27.02-.6.02-.92h-2v.44a3 3 0 0 1-.01.26c-.02.13-.03-.02.13-.18s.32-.15.18-.14a3.14 3.14 0 0 1-.25.02h-.45v2zm0-24.68h.44l.27.01c.06.01.07.02.05 0a.63.63 0 0 1-.36-.33L17.99 4l.01.2v.36h2c0-.27 0-.57-.03-.82a1.5 1.5 0 0 0-.5-.98 1.7 1.7 0 0 0-.96-.37c-.26-.02-.58-.02-.9-.02v2z" fill="%23949BA0"></path><path d="M9.29 18.02a1.44 1.44 0 0 1-1.43-1.44c0-.8.64-1.44 1.43-1.44.79 0 1.43.64 1.43 1.44 0 .8-.65 1.44-1.43 1.44z" fill="%23949BA0"></path></svg>');
	}
	.main {
		margin: auto;
	}
</style>
"@

$preContent = @"
<svg width="450" height="100" viewBox="0 0 90 20" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M9.17 13.38L19.22 3.33c.23-.22.58-.22.78 0l3.29 3.27a.53.53 0 0 1 0 .78l-9.66 9.68c-.23.23-.58.23-.78 0l-3.68-3.68zM3.2 7.4c-.23-.23-.23-.57 0-.78l3.27-3.27a.53.53 0 0 1 .77 0l5.09 5.09-4.05 4.05-5.08-5.1zM32.49 5h-2l4.08 10.81h2.17l4.08-10.8h-2l-3.17 8.41-3.16-8.41zm11.48 10.98c2.16 0 3.16-1.31 3.16-1.31l-1.02-1.25s-.77.94-2.08.94c-1.25 0-1.98-.75-2.17-1.61h5.64s.08-.39.08-.86c0-2.06-1.49-3.74-3.61-3.78A3.96 3.96 0 0 0 40 11.36a3.97 3.97 0 0 0 3.97 4.62zM43.8 9.8c1 0 1.64.61 1.86 1.47h-3.78c.23-.86.84-1.47 1.92-1.47zm5.23-1.56h1.78v1.09h.08s.78-1.23 2.17-1.23h.3v1.92s-.22-.08-.6-.08c-1.09 0-1.93.86-1.93 2.17v3.7h-1.77l-.02-7.57zm7.22-3.24h-1.78l-.02 10.8h1.78v-1.86l1.16-1.3 2.17 3.16h2l-3-4.39 2.86-3.17h-2.17l-3 3.31V5.01zm10.58 9.8h-.08s-.7 1.17-2.25 1.17c-1.47 0-2.47-1-2.47-2.17 0-1.22.92-2.16 2.25-2.39l2.55-.47c0-.53-.61-1.16-1.47-1.16-1.12 0-1.86.92-1.86.92l-1.08-1.09s1.08-1.53 3-1.53c1.86 0 3.17 1.35 3.17 3v4.7H66.8l.02-.98zm0-2.47l-1.78.3c-.92.17-1.22.48-1.22.93 0 .45.47.92 1.16.92 1 0 1.86-.86 1.86-1.92l-.02-.23zm8.85 2.4h.08v1.08h1.78V5h-1.78V9.3h-.08s-.7-1.23-2.48-1.23c-1.77 0-3.39 1.62-3.39 3.95 0 2.32 1.62 3.94 3.4 3.94 1.77 0 2.47-1.23 2.47-1.23zm-2-4.87a2.1 2.1 0 0 1 2.08 2.17c0 1.24-.92 2.16-2.09 2.16a2.1 2.1 0 0 1-2.08-2.16c0-1.25.92-2.17 2.08-2.17zm9.86 4.95h-.08s-.7 1.16-2.25 1.16c-1.47 0-2.47-1-2.47-2.17 0-1.22.92-2.16 2.25-2.39l2.55-.47c0-.53-.61-1.16-1.47-1.16-1.12 0-1.86.92-1.86.92l-1.08-1.09s1.08-1.53 3-1.53c1.86 0 3.17 1.35 3.17 3v4.7h-1.78l.02-.98zm0-2.48l-1.77.3c-.92.17-1.23.48-1.23.93 0 .45.47.92 1.17.92 1 0 1.85-.86 1.85-1.92l-.02-.23z" fill="#030E16"></path></svg>
<div class="main">
<input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name">
"@

$postContent = @"
</div>
<script>
function myFunction() {
  var input, filter, table, tr, td, i, txtValue;
  input = document.getElementById("myInput");
  filter = input.value.toUpperCase();
  table = document.getElementById("report");
  tr = table.getElementsByTagName("tr");
  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[0];
    if (td) {
      txtValue = td.textContent || td.innerText;
      if (txtValue.toUpperCase().indexOf(filter) > -1) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    }       
  }
}
</script>
"@

			$jsonProps = @('accessGroups','accessCards')
			foreach ($prop in $jsonProps){
				$outUsers | ForEach-Object {
					if(!([string]::IsNullOrEmpty($_.($prop)))){
						$_.($prop) = "<pre>$($_.($prop))</pre>"
					}
				}
			}

			$outUsers | ConvertTo-Html -Property @{name='Name';expression={$_.name}},@{name='Email';expression={$_.email}},@{name='Doors';expression={$_.doors}},@{name='Bluetooth';expression={$_.bluetoothAccess}},@{name='Mobile';expression={$_.mobileAccess}},@{name='Creds';expression={$_.accessCards}},@{name='Groups';expression={$_.accessGroups}} -Title 'AC User Report' -Head $Head -PreContent $preContent -PostContent $postContent | foreach-object {[System.Web.HttpUtility]::HtmlDecode($_)} | ForEach-Object {$_.Replace('<table>','<table id="report">')} | Set-Content $reportFile
		}
	} #end end
} #end function