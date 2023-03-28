function Add-VerkadaAccessUser
{
	<#
		.SYNOPSIS
		Adds an Access User in an organization
		
		.DESCRIPTION
		This function is used to add a Verkaka Access user or users to a Verkada Command Organization.  As part of the user creation you can optionally add a badge and/or add the user to groups.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUser.md

		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User'
		This will add the access user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will add the access user with the name "New User".  The org_id and tokens are submitted as parameters in the call.
		
		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' 
		This will add the access user with the name "New User" and email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaAccessUser -email 'newUser@contoso.com' 
		This will add the access user with the email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com -department 'sales' -departmentId 'US-Sales' -employeeId '12345' -employeeTitle 'The Closer' -companyName 'Contoso' 
		This will add the access user with the name "New User" and email newUser@contoso.com in department defined as sales with departmnetId of US-Sales with the appropriate employeeID, Title, and Company.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -includeBadge -cardType 'HID' -facilityCode 111 -cardNumber 55555
		This will add the access user with the name "New User" and email newUser@contoso.com with an HID badge 111-55555.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -includeBadge -cardType 'HID' -facilityCode 111 -cardNumber 55555 -groupId 'df76sd-dsc-group1','dsf987-daf-group2'
		This will add the access user with the name "New User" and email newUser@contoso.com with an HID badge 111-55555 and in groups df76sd-dsc-group1 and dsf987-daf-group2.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The email address of the user being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$email,
		#The first name of the user being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$firstName,
		#The last name of the user being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$lastName,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		#The phone number of the user being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern("^\+\d{11}")]
		[String]$phone,
		#The role of the user being added.
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateSet('ORG_MEMBER','ADMIN')]
		[String]$role='ORG_MEMBER',
		#Start date/time of the user being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[datetime]$start,
		#End date/time of the user being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[datetime]$expiration,
		#Boolean on whether to send invite email to newly created user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$sendInviteEmail=$false,
		#The card type of the card being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$cardType,
		#The card number of the card being added (Mutually exclusive with CardHex)
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$cardNumber,
		#The card Number Hex of the card being added (Mutually exclusive with Card Number)
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$cardNumberHex,
		#The facility code of the card being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$facilityCode,
		#The UUID of the group or groups the user should be added to on creation
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String[]]$groupId,
		#The name of the group or groups the user should be added to on creation(not currently implemented)
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String[]]$groupName,
		#The employee ID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$employeeId,
		#The title of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$employeeTitle,
		#The department of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$department,
		#The departmentId of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$departmentId,
		#The company name of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$companyName,
		#The UUID of the user account making the request
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$usr = $Global:verkadaConnection.usr,
		#Number of threads allowed to multi-thread the task
		[Parameter()]
		[ValidateRange(1,20)]
		[int]$threads=4
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		
		$url = "https://vcerberus.command.verkada.com/users/create"

		$jobs = @()
	} #end begin
	
	Process {
		#decide which parameter set is presented for first/last name and email
		if ([string]::IsNullOrEmpty($firstName) -and [string]::IsNullOrEmpty($lastName) -and [string]::IsNullOrEmpty($email)){
			Write-Warning "No user created since no email or name was presented.  An email and/or First/Last Name are required to create a user."
			return
		} elseif ((!([string]::IsNullOrEmpty($firstName))) -and (!([string]::IsNullOrEmpty($lastName))) -and (!([string]::IsNullOrEmpty($email)))) {
			#write-host "$firstName $lastName $email are all present" -ForegroundColor Red
		} elseif ((!([string]::IsNullOrEmpty($email))) -and [string]::IsNullOrEmpty($firstName) -and [string]::IsNullOrEmpty($lastName)) {
			#write-host "$email is the only thing present" -ForegroundColor Red
		} elseif (([string]::IsNullOrEmpty($firstName) -or [string]::IsNullOrEmpty($lastName))) {
			Write-Warning "No user created since either the first or last name is missing.  First and Last Name are required to create a user if one is specified."
			return
		} elseif ((!([string]::IsNullOrEmpty($firstName)) -and (!([string]::IsNullOrEmpty($lastName)))) -and [string]::IsNullOrEmpty($email)) {
			#write-host "$firstName $lastname were specified and no email" -ForegroundColor Red
		}

		#build the form parameters for the user creation
		$form_params = @{
			"organizationId" = $org_id
		}
		if (!([string]::IsNullOrEmpty($email))){$form_params.email = $email}
		if (!([string]::IsNullOrEmpty($firstName))){$form_params.firstName = $firstName}
		if (!([string]::IsNullOrEmpty($lastName))){$form_params.lastName = $lastName}
		if (!([string]::IsNullOrEmpty($phone))){$form_params.phone = $phone}
		if (!([string]::IsNullOrEmpty($role))){$form_params.role = $role}
		if (!([string]::IsNullOrEmpty($start))){$form_params.start = ([DateTimeOffset]($start)).ToUnixTimeSeconds()}
		if (!([string]::IsNullOrEmpty($expiration))){$form_params.expiration = ([DateTimeOffset]($expiration)).ToUnixTimeSeconds()}
		if (!([string]::IsNullOrEmpty($sendInviteEmail))){$form_params.sendInviteEmail = $sendInviteEmail.ToString().ToLower()}

		#start a threadJob for each user addition
		$jobs += Start-ThreadJob -InitializationScript {Import-Module verkadaModule.psm1} -ThrottleLimit $threads -ScriptBlock {
			#Add the user to Command
			#Write-Output "Add user $using:firstName $using:lastName $using:email"
			$res = @{}
			try {
				$output = Invoke-VerkadaFormCall $using:url $using:org_id $using:form_params -x_verkada_token $using:x_verkada_token -x_verkada_auth $using:x_verkada_auth
				$res.created = ((Get-Date -Date "01-01-1970") + ([System.TimeSpan]::FromSeconds(($output.users.created)))).ToLocalTime()
				$res.userId = $output.users.userId
				$res.firstName = $output.users.firstName
				$res.lastName = $output.users.lastName
				$res.email = $output.users.email

				$response = $res | ConvertTo-Json -Depth 100 | ConvertFrom-Json
			}
			catch [Microsoft.PowerShell.Commands.HttpResponseException] {
				$err = $_.ErrorDetails | ConvertFrom-Json
				$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
				$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force
				
				$res.created = '0'
				$res.firstName = $using:firstName
				$res.lastName = $using:lastName
				$res.email = $using:email

				Write-Warning "$using:firstName $using:lastName $using:email was not created due to: $($err.StatusCode) - $($err.message)"
				$noUser = $true
			}
			catch {
				$_.Exception
				$noUser = $true
			}
			finally {
				$response = $res | ConvertTo-Json -Depth 100 | ConvertFrom-Json
			}
			if ($noUser){return}
			
			#Add badge to user if present
			if (!([string]::IsNullOrEmpty($using:cardType))){
				#Write-Output "Add badge $using:cardType $using:cardNumber $using:cardNumberHex $using:facilityCode"
				#Write-Output "Need to verify cardnumber or cardnumberhex are present as well as other card error handling"
				if (([string]::IsNullOrEmpty($using:cardNumber)) -and ([string]::IsNullOrEmpty($using:cardNumberHex))){
					#check to see if both cardnumber and cardnumberhex are exmpty
					Write-Warning "No card is being added to $using:firstName $using:lastName $using:email as both cardnumber and cardnumberhex are missing.  One is required."
					$res.accessCards = ''
				} elseif ((!([string]::IsNullOrEmpty($using:cardNumber))) -and (!([string]::IsNullOrEmpty($using:cardNumberHex)))) {
					#check to see if both cardnumber and cardnumberhex are present
					Write-Warning "No card is being added to $using:firstName $using:lastName $using:email as a cardnumber and cardnumberhex were submitted.  They are mutually exclusive."
					$res.accessCards = ''
				} else {
					$eval = "`$response | Add-VerkadaAccessBadgeToUser -org_id $using:org_id -x_verkada_token $using:x_verkada_token -x_verkada_auth $using:x_verkada_auth -cardType $using:cardType"
					if (!([string]::IsNullOrEmpty($using:cardNumber))){$eval +=" -cardNumber $using:cardNumber"}
					if (!([string]::IsNullOrEmpty($using:cardNumberHex))){$eval +=" -cardNumberHex $using:cardNumberHex"}
					if (!([string]::IsNullOrEmpty($using:facilityCode))){$eval +=" -facilityCode $using:facilityCode"}

					try {
						$output2 = invoke-expression $eval
						$res.accessCards = $output2.accessCards
					}
					catch {
						if ($_.Exception.Message -match '^\d{3}\s-\s.*') {
							Write-Warning "No card is being added to $using:firstName $using:lastName $using:email due to: $($_.Exception.Message)"
						} else {
							$_.Exception
						}
						$res.accessCards = ''
					}
				}
			} else {$res.accessCards = ''}

			#add user to group/s if present
			if (!([string]::IsNullOrEmpty($using:groupId))){
				#validate group is proper UUID
				$res.groupIds = @()
				switch -Regex ($using:groupId) {
					'^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$' {
							#Write-Output "Adding $using:firstName $using:lastName to $_"
							try {
								$response | Add-VerkadaAccessUserToGroup -groupId $_ -org_id $using:org_id -x_verkada_token $using:x_verkada_token -x_verkada_auth $using:x_verkada_auth | Out-Null
								$res.groupIds += $_
							 }
							 catch {
								Write-Warning "$using:firstName $using:lastName $using:email was not added to the groupID provided ($_) due to: $($_.Exception.Message)"
							 }
					}
					default {Write-Warning "$using:firstName $using:lastName $using:email was not added to the groupID provided ($_) as it is not a valid UUID"}
				}
				
			} elseif (!([string]::IsNullOrEmpty($using:groupName))) {
				<# Action when this condition is true #>
			}

			#add employment deatils if present
			$employment = @{}
			$eval3 = "Set-VerkadaAccessUserEmployementDetail -org_id $using:org_id -usr $using:usr -x_verkada_token $using:x_verkada_token -x_verkada_auth $using:x_verkada_auth -userId $($response.userId)"
			if (!([string]::IsNullOrEmpty($using:employeeId))){$employment.employeeId = $using:employeeId; $eval3 +=" -employeeId `$using:employeeId"}
			if (!([string]::IsNullOrEmpty($using:employeeTitle))){$employment.employeeTitle = $using:employeeTitle; $eval3 +=" -employeeTitle `$using:employeeTitle"}
			if (!([string]::IsNullOrEmpty($using:department))){$employment.department = $using:department; $eval3 +=" -department `$using:department"}
			if (!([string]::IsNullOrEmpty($using:departmentId))){$employment.departmentId = $using:departmentId; $eval3 +=" -departmentId `$using:departmentId"}
			if (!([string]::IsNullOrEmpty($using:companyName))){$employment.companyName = $using:companyName; $eval3 +=" -companyName `$using:companyName"}

			#check tp see if any employment details are present
			if ($employment.Count){
				try {
					$employment.userId = $response.userId
					$output3 = invoke-expression $eval3
					$res.employeeId = $output3.employeeId
					$res.employeeTitle = $output3.employeeTitle
					$res.department = $output3.department
					$res.departmentId = $output3.departmentId
					$res.companyName = $output3.companyName
				}
				catch {
					if ($_.Exception.Message -match '^\d{3}\s-\s.*') {
						Write-Warning "No employment details were updated for $using:firstName $using:lastName $using:email due to: $($_.Exception.Message)"
					} else {
						$_.Exception
					}
					$res.employeeId = ''
					$res.employeeTitle = ''
					$res.department = ''
					$res.departmentId = ''
					$res.companyName = ''
				}
			} else {
				$res.employeeId = ''
				$res.employeeTitle = ''
				$res.department = ''
				$res.departmentId = ''
				$res.companyName = ''
			}
			#aggregated response output
			$response = $res | ConvertTo-Json -Depth 100 | ConvertFrom-Json
			$response
		} 
	} #end process

	End {
		$jobs | Receive-Job -AutoRemoveJob -Wait -WarningVariable +w -ErrorVariable +e
		foreach ($line in $w){Write-Output "Warning: $line"}
		foreach ($line in $e){Write-Output "Error: $line"}
		Remove-Variable -Name w -ErrorAction SilentlyContinue
		Remove-Variable -Name e -ErrorAction SilentlyContinue
	}
} #end function