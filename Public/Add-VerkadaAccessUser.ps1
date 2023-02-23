function Add-VerkadaAccessUser
{
	<#
		.SYNOPSIS
		Adds an Access User in an organization
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'email')]
	Param(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'email')]
		[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'name')]
		[String]$email,
		[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'email')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'name')]
		[String]$firstName,
		[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'email')]
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'name')]
		[String]$lastName,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$phone,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$role='ORG_MEMBER',
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[datetime]$start,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[datetime]$expiration,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$sendInviteEmail=$false,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$cardType,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$cardNumber,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$cardNumberHex,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$facilityCode,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String[]]$groupId,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String[]]$groupName,
		[Parameter()]
		[Switch]$includeBadge,
		[Parameter()]
		[int]$threads=$null

	)

	Begin {
		if (!($org_id)){Write-Warning 'Missing org_id which is required'; return}
		if (!($Global:verkadaConnection)){Write-Warning 'Missing auth token which is required'; return}
		if ($Global:verkadaConnection.authType -ne 'UnPwd'){Write-Warning 'Un/Pwd auth is required'; return}
		
		$x_verkada_token = $Global:verkadaConnection.csrfToken
		$x_verkada_auth = $Global:verkadaConnection.userToken


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
		if (!([string]::IsNullOrEmpty($start))){$form_params.start = $start}
		if (!([string]::IsNullOrEmpty($expiration))){$form_params.expiration = $expiration}
		if (!([string]::IsNullOrEmpty($sendInviteEmail))){$form_params.sendInviteEmail = $sendInviteEmail.ToString().ToLower()}

		if ($threads){
			do {
				$job = (Get-Job -State Running | Measure-Object).Count
			} until ($job -le $threads)

			Start-Job -Name $email -InitializationScript {Import-Module verkadaModule.psm1} -ScriptBlock {
				$output = Invoke-VerkadaFormCall $using:url $using:org_id $using:form_params -x_verkada_token $using:x_verkada_token -x_verkada_auth $using:x_verkada_auth
				$res = @{}
				$res.created = (Get-Date -Date "01-01-1970") + ([System.TimeSpan]::FromSeconds(($output.users.created)))
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
			$res.created = (Get-Date -Date "01-01-1970") + ([System.TimeSpan]::FromSeconds(($output.users.created)))
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