function Add-VerkadaAccessUserCard{
	<#
		.SYNOPSIS
		Creates and adds an Access credential to an Access user in an organization using https://apidocs.verkada.com/reference/postaccesscardviewv1

		.DESCRIPTION
		Create and add an access card for a specified user_id or external_id and org_id. Card object will be passed in the body of the request as a json.
		We require facility code and card number OR card_number_hex OR card_number_base36. The successful repsonse will be the created credential information.
		The org_id and reqired token can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Add-VerkadaAccessUserCard.md

		.EXAMPLE
		Add-VerkadaAccessUserCard -userId '801c9551-b04c-4293-84ad-b0a6aa0588b3' -type 'HID' -facilityCode 111 -cardNumber 55555
		This will add a badge in the HID format with facility code 111 and card number 55555 to the user specified.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Add-VerkadaAccessUserCard -externalId 'newUserUPN@contoso.com' -type 'HID' -facilityCode 111 -cardNumber 55555 -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_auth_api 'sd78ds-uuid-of-verkada-token'
		This will add an Access credential in the HID format with facility code 111 and card number 55555 to the user specified.  The org_id and tokens are submitted as parameters in the call.

		.EXAMPLE
		Import-Csv ./myUserBadges.csv |  Add-VerkadaAccessUserCard
		This will add an Access credential for every row in the csv file which contains userId, type, cardNumber(or cardNumberHex or cardNumberBase36), and facilityCode(optional).  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'cardNumber')]
	[Alias("Add-VrkdaAcUsrCrd","a-VrkdaAcUsrCrd")]
	param (
		#The UUID of the user
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[Alias('user_id')]
		[String]$userId,
		#unique identifier managed externally provided by the consumer
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('external_id')]
		[String]$externalId,
		#The card type of the credential
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateSet('HID','HID37wFacilityCode','HID37woFacilityCode','HID34','CasiRusco','Corporate1000_35','Corporate1000_48','iClass','DESFire','VerkadaDESFire','ThirdParty40X','AppleWalletPass','MiFareClassic1K_CSN','MiFareClassic4K_CSN','MDCCustom_64','HID36Keyscan','HID33DSX','HID33RS2','HID36Simplex','Cansec37','CreditCardBin','KantechXSF','Schlage34','Schlage37x','RBH50','GProxII36','AMAG32','Securitas37','Kastle32','PointGuardMDI37','Blackboard64','IDm64bit','Continental36','AWID34','LicensePlate64','HIDInfinity37','HIDCeridian26','IClass35','Andover37','Standard 26-bit Wiegand','HID 37-bit','HID 37-bit No Facility Code','HID 34-bit','Casi Rusco 40-Bit','HID Corporate 1000-35','HID Corporate 1000-48','HID iClass','DESFire CSN','Verkada DESFire','DESFire 40X','Apple Wallet Pass','MiFare 4-Byte (32 bit) CSN','MDC Custom 64-bit','HID 36-bit Keyscan','HID 33-bit DSX','HID 33-bit RS2','HID 36-bit Simplex','Cansec 37-bit','Credit Card BIN Number','Kantech XSF','Schlage 34-bit','Schlage 37-bit','RBH 50-bit','Guardall G-Prox II 36-bit','AMAG 32-bit','Securitas 37-bit','Kastle 32-bit','PointGuard MDI 37-bit','Blackboard 64-bit','IDm 64-bit','Continental 36-bit','AWID 34-bit','License Plate','HID Infinity 37-bit','HID Ceridian 26-bit','iClass 35-bit','Andover Controls 37-bit')]
		[Alias('type')]
		[String]$cardType,
		#The card number of the credential
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cardNumber')]
		[Alias('card_number')]
		[String]$cardNumber,
		#The card Number Hex of the credential
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cardNumberHex')]
		[Alias('card_number_hex')]
		[String]$cardNumberHex,
		#The card Number in base36 of the credential
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cardNumberBase36')]
		[Alias('card_number_base36')]
		[String]$cardNumberBase36,
		#The facility code of the credential
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('facility_code')]
		[String]$facilityCode,
		#Bool value specifying if the credential is currently active. Default value is False.
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[bool]$active=$true,
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The public API token obatined via the Login endpoint to be used for calls that hit the public API gateway
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$x_verkada_auth_api = $Global:verkadaConnection.x_verkada_auth_api,
		#The region of the public API to be used
		[Parameter()]
		[ValidateSet('api','api.eu','api.au')]
		[String]$region='api',
		#Switch to write errors to file
		[Parameter()]
		[switch]$errorsToFile
	)
	
	begin {
		$url = "https://$($region).verkada.com/access/v1/credentials/card"
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth_api)) {throw "x_verkada_auth_api is missing but is required!"}
		$myErrors = @()
	} #end begin
	
	process {
		if ([string]::IsNullOrEmpty($cardType)) {
			Write-Error "cardType is missing but is required!"
			return
		}
		if ([string]::IsNullOrEmpty($externalId) -and [string]::IsNullOrEmpty($userId)){
			Write-Error "Either externalId or userId required"
			return
		}

		$body_params = @{
			'type'	= $cardType
			'active'		= $active
		}
		if (!([string]::IsNullOrEmpty($cardNumber))){$body_params.card_number = $cardNumber}
		if (!([string]::IsNullOrEmpty($cardNumberHex))){$body_params.card_number_hex = $cardNumberHex}
		if (!([string]::IsNullOrEmpty($cardNumberBase36))){$body_params.card_number_base36 = $cardNumberBase36}
		if (!([string]::IsNullOrEmpty($facilityCode))){$body_params.facility_code = $facilityCode}
		
		$query_params = @{}
		if (!([string]::IsNullOrEmpty($userId))){
			$query_params.user_id = $userId
		} elseif (!([string]::IsNullOrEmpty($externalId))){
			$query_params.external_id = $externalId
		}
		
		try {
			$response = Invoke-VerkadaRestMethod $url $org_id $x_verkada_auth_api $query_params -body_params $body_params -method POST
			return $response
		}
		catch [Microsoft.PowerShell.Commands.HttpResponseException] {
			$err = $_.ErrorDetails | ConvertFrom-Json
			$errorMes = $_ | Convertto-Json -WarningAction SilentlyContinue
			$err | Add-Member -NotePropertyName StatusCode -NotePropertyValue (($errorMes | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue).Exception.Response.StatusCode) -Force
			$msg = "$($err.StatusCode) - $($err.message)"
			$msg += ": $(($query_params + $body_params) | ConvertTo-Json -Compress)"
			Write-Error $msg
			$myErrors += $msg
			$msg = $null
		}
		catch [VerkadaRestMethodException] {
			$msg = $_.ToString()
			$msg += ": $(($query_params + $body_params) | ConvertTo-Json -Compress)"
			Write-Error $msg
			$myErrors += $msg
			$msg = $null
		}
	} #end process
	
	end {
		if ($errorsToFile.IsPresent){
			if (![string]::IsNullOrEmpty($myErrors)){
				Get-Date | Out-File ./errors.txt -Append
				$myErrors | Out-File ./errors.txt -Append
			}
		}
	} #end end
} #end function