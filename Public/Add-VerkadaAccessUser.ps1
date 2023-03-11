function Add-VerkadaAccessUser
{
	<#
		.SYNOPSIS
		Adds an Access User in an organization
		.DESCRIPTION
		This function is used to add a Verkaka Access user or users to a Verkada Command Organization.  As part of the user creation you can optionally add a badge and/or add the user to groups.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		.EXAMPLE
		Add-VerkadaAccessUser -email 'newUser@contoso.com' 
		This will add the access user with email address newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		.EXAMPLE
		Add-VerkadaAccessUser -email 'newUser@contoso.com' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will add the access user with email address newUser@contoso.com.  The org_id and tokens are submitted as parameters in the call.
		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User'
		This will add the access user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' 
		This will add the access user with the name "New User" and email newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -includeBadge -cardType 'HID' -facilityCode 111 -cardNumber 55555
		This will add the access user with the name "New User" and email newUser@contoso.com with an HID badge 111-55555.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		.EXAMPLE
		Add-VerkadaAccessUser -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' -includeBadge -cardType 'HID' -facilityCode 111 -cardNumber 55555 -groupId 'df76sd-dsc-group1','dsf987-daf-group2'
		This will add the access user with the name "New User" and email newUser@contoso.com with an HID badge 111-55555 and in groups df76sd-dsc-group1 and dsf987-daf-group2.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'email')]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The email address of the user being added
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'email')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailWithBadge')]
		#[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'name')]
		#[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'nameWithBadge')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailAndName')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailAndNameWithBadge')]
		[String]$email,
		#The first name of the user being added
		#[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'email')]
		#[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailWithBadge')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'name')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'nameWithBadge')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailAndName')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailAndNameWithBadge')]
		[String]$firstName,
		#The last name of the user being added
		#[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'email')]
		#[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailWithBadge')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'name')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'nameWithBadge')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailAndName')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailAndNameWithBadge')]
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
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailWithBadge')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'nameWithBadge')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailAndNameWithBadge')]
		[ValidateSet('HID','HID33DSX','HID33RS2','HID34','HID36Keyscan','HID37wFacilityCode','HID37woFacilityCode','Corporate1000_35','Corporate1000_48','CasiRusco','MiFareClassic1K_CSN','DESFire','PointGuardMDI37','GProxII36','KantechXSF','Schlage34','HID36Simplex','Kastle32','RBH50')]
		[String]$cardType,
		#The card number of the card being added (Mutually exclusive with CardHex)
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailWithBadge')]
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'nameWithBadge')]
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailAndNameWithBadge')]
		[String]$cardNumber,
		#The card Number Hex of the card being added (Mutually exclusive with Card Number)
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailWithBadge')]
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'nameWithBadge')]
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailAndNameWithBadge')]
		[String]$cardNumberHex,
		#The facility code of the card being added
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailWithBadge')]
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'nameWithBadge')]
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'emailAndNameWithBadge')]
		[String]$facilityCode,
		#The UUID of the group or groups the user should be added to on creation
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String[]]$groupId,
		#The name of the group or groups the user should be added to on creation(not currently implemented)
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String[]]$groupName,
		#Switch to create badge or not upon user creation
		[Parameter(Mandatory = $true, ParameterSetName = 'emailWithBadge')]
		[Parameter(Mandatory = $true, ParameterSetName = 'nameWithBadge')]
		[Parameter(Mandatory = $true, ParameterSetName = 'emailAndNameWithBadge')]
		[Switch]$includeBadge,
		#Number of threads allowed to multi-thread the task
		[Parameter()]
		[ValidateRange(1,4)]
		[int]$threads=$null
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		
		$url = "https://vcerberus.command.verkada.com/users/create"
	} #end begin
	
	Process {
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

		if ($threads){
			do {
				$job = (Get-Job -State Running | Measure-Object).Count
			} until ($job -le $threads)

			Start-Job -Name $email -InitializationScript {Import-Module verkadaModule.psm1} -ScriptBlock {
				$output = Invoke-VerkadaFormCall $using:url $using:org_id $using:form_params -x_verkada_token $using:x_verkada_token -x_verkada_auth $using:x_verkada_auth
				$res = @{}
				$res.created = ((Get-Date -Date "01-01-1970") + ([System.TimeSpan]::FromSeconds(($output.users.created)))).ToLocalTime()
				$res.userId = $output.users.userId
				$res.firstName = $output.users.firstName
				$res.lastName = $output.users.lastName
				$res.email = $output.users.email

				$response = $res | ConvertTo-Json -Depth 100 | ConvertFrom-Json
				
				if ($using:includeBadge.IsPresent){ 
					$eval = "`$response | Add-VerkadaAccessBadgeToUser -org_id $using:org_id -x_verkada_token $using:x_verkada_token -x_verkada_auth $using:x_verkada_auth -cardType $using:cardType"
					if (!([string]::IsNullOrEmpty($using:cardNumber))){$eval +=" -cardNumber $using:cardNumber"}
					if (!([string]::IsNullOrEmpty($using:cardNumberHex))){$eval +=" -cardNumberHex $using:cardNumberHex"}
					if (!([string]::IsNullOrEmpty($using:facilityCode))){$eval +=" -facilityCode $using:facilityCode"}
	
					$output2 = invoke-expression $eval
					$res.accessCards = $output2.accessCards
				}

				if ($using:groupId){
					$response | Add-VerkadaAccessUserToGroup -groupId $using:groupId -org_id $using:org_id -x_verkada_token $using:x_verkada_token -x_verkada_auth $using:x_verkada_auth | Out-Null
				} elseif ($using:groupName) {
					<# Action when this condition is true #>
				}

				$response = $res | ConvertTo-Json -Depth 100 | ConvertFrom-Json
				$response
			} | Out-Null
			Get-Job -State Completed | Receive-Job -AutoRemoveJob -Wait
		} else {
			$output = Invoke-VerkadaFormCall $url $org_id $form_params -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth
			$res = @{}
			$res.created = ((Get-Date -Date "01-01-1970") + ([System.TimeSpan]::FromSeconds(($output.users.created)))).ToLocalTime()
			$res.userId = $output.users.userId
			$res.firstName = $output.users.firstName
			$res.lastName = $output.users.lastName
			$res.email = $output.users.email

			$response = $res | ConvertTo-Json -Depth 100 | ConvertFrom-Json
			
			if ($includeBadge.IsPresent){ 
				$eval = "`$response | Add-VerkadaAccessBadgeToUser -cardType $cardType"
				if (!([string]::IsNullOrEmpty($cardNumber))){$eval +=" -cardNumber $cardNumber"}
				if (!([string]::IsNullOrEmpty($cardNumberHex))){$eval +=" -cardNumberHex $cardNumberHex"}
				if (!([string]::IsNullOrEmpty($facilityCode))){$eval +=" -facilityCode $facilityCode"}

				$output2 = invoke-expression $eval
				$res.accessCards = $output2.accessCards
			}

			if ($groupId){
				$response | Add-VerkadaAccessUserToGroup -groupId $groupId
			} elseif ($groupName) {
				<# Action when this condition is true #>
			}

			$response = $res | ConvertTo-Json -Depth 100 | ConvertFrom-Json
			$response
		}
	} #end process

	End {
		if ($threads){
			Wait-Job -State Running  | Out-Null
			Get-Job -State Completed | Receive-Job -AutoRemoveJob -Wait
			Get-Job | Receive-Job -AutoRemoveJob -Wait
		}
	}
} #end function