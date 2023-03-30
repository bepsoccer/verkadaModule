function Add-VerkadaAccessBadgeToUser
{
	<#
		.SYNOPSIS
		Adds a badge to an Access User in an organization

		.DESCRIPTION
		This function is used to add a badge to a Verkada access user.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessBadgeToUser.md

		.EXAMPLE
		Add-VerkadaAccessBadgeToUser -userId 'gjg547-uuid-of-user' -cardType 'HID' -facilityCode 111 -cardNumber 55555
		This will add a badge in the HID format with facility code 111 and card number 55555 to the user specified.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaAccessBadgeToUser -userId 'gjg547-uuid-of-user' -cardType 'HID' -facilityCode 111 -cardNumber 55555 -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will add a badge in the HID format with facility code 111 and card number 55555 to the user specified.  The org_id and tokens are submitted as parameters in the call.
		
		.EXAMPLE
		Import-Csv ./myUserBadges.csv |  Add-VerkadaAccessBadgeToUser
		This will add a badge for every row in the csv file which contains userId, cardType, cardNumber(or cardNumberHex), and facilityCode(optional).  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'cardNumber')]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The UUID of the user the badge is being added to
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$userId,
		#The card type of the card being added
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateSet('HID','HID33DSX','HID33RS2','HID34','HID36Keyscan','HID37wFacilityCode','HID37woFacilityCode','Corporate1000_35','Corporate1000_48','CasiRusco','MiFareClassic1K_CSN','DESFire','PointGuardMDI37','GProxII36','KantechXSF','Schlage34','HID36Simplex','Kastle32','RBH50')]
		[String]$cardType,
		#The card number of the card being added
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cardNumber')]
		[String]$cardNumber,
		#The card Number Hex of the card being added
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cardNumberHex')]
		[String]$cardNumberHex,
		#The facility code of the card being added
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[String]$facilityCode,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
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
		
		try {
			Invoke-VerkadaRestMethod $url $org_id $body_params -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -Method 'POST' -UnPwd
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force

			throw "$($err.StatusCode) - $($err.message)"
		}
	} #end process

	End {
		
	}
} #end function