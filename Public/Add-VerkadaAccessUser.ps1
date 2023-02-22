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
		[bool]$sendInviteEmail=$false

	)

	Begin {
		if (!($org_id)){Write-Warning 'Missing org_id which is required'; return}
		if (!($Global:verkadaConnection)){Write-Warning 'Missing auth token which is required'; return}
		if ($Global:verkadaConnection.authType -ne 'UnPwd'){Write-Warning 'Un/Pwd auth is required'; return}


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

		Invoke-VerkadaFormCall $url $org_id $form_params
	} #end process
} #end function