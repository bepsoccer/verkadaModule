function Add-VerkadaAccessBadgeToUser
{
	<#
		.SYNOPSIS
		Adds a badger to an Access User in an organization
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
		[ValidateNotNullOrEmpty()]
		[String]$userId,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[String]$cardType,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cardNumber')]
		[String]$cardNumber,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cardNumberHex')]
		[String]$cardNumberHex,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$facilityCode,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		[Parameter()]
		[int]$threads=$null
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}

		$url = "https://vcerberus.command.verkada.com/user/access_card/add"
	} #end begin
	
	Process {
		$body_params = @{
			"userId"					= $userId
			"organizationId"	= $org_id
			"cardType"				= $cardType
		}
		$body_params.cardParams = @{}
		if (!([string]::IsNullOrEmpty($cardNumber))){$body_params.cardParams.cardNumber = $cardNumber}
		if (!([string]::IsNullOrEmpty($cardNumberHex))){$body_params.cardParams.cardNumberHex = $cardNumberHex}
		if (!([string]::IsNullOrEmpty($facilityCode))){$body_params.cardParams.facilityCode = $facilityCode}
		
		Invoke-VerkadaRestMethod $url $org_id $body_params -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -Method 'POST' -UnPwd
	} #end process

	End {
		
	}
} #end function