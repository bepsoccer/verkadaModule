function Find-VerkadaUserId
{
	<#
		.SYNOPSIS
		Finds the userID of a user in an organization
		
		.DESCRIPTION
		This function is used to find a Verkaka userId using firstName/lastName or email address.  
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Find-VerkadaUserId.md

		.EXAMPLE
		Find-VerkadaUserId -email 'newUser@contoso.com' 
		This will attempt to find theuserId of the user with email address newUser@contoso.com.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Find-VerkadaUserId -email 'newUser@contoso.com' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will attempt to find theuserId of the user with email address newUser@contoso.com.  The org_id and tokens are submitted as parameters in the call.
		
		.EXAMPLE
		Find-VerkadaUserId -firstName 'New' -lastName 'User'
		This will attempt to find theuserId of the user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Find-VerkadaUserId -firstName 'New' -lastName 'User' -email 'newUser@contoso.com' 
		This will attempt to find theuserId of the user with the name "New User".  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'email')]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The email address of the user being searched for
		[Parameter(Mandatory = $true, ParameterSetName = 'email')]
		[String]$email,
		#The first name of the user being searched for
		[Parameter(Mandatory = $true, ParameterSetName = 'name')]
		[String]$firstName,
		#The last name of the user being searched for
		[Parameter(Mandatory = $true, ParameterSetName = 'name')]
		[String]$lastName,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
	} #end begin
	
	Process {
		if ($PSCmdlet.ParameterSetName -eq 'name') {
			$user = Read-VerkadaCommandUsers -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth | Where-Object {($_.firstName -eq $firstName) -and ($_.lastName -eq $lastName)}
			if ($user.count -gt 1){
        Write-Host "Multiple users were found" -ForegroundColor Yellow
        Write-Host "Please select a user" -ForegroundColor Yellow
        for($i = 0; $i -lt $user.count; $i++){
            Write-Host "$($i): $($user[$i].firstName) $($user[$i].lastName) | $($user[$i].email) | $($user[$i].phone) | $($user[$i].userId) | SCIM:$($user[$i].provisioned)"
        }
        $selection = Read-Host -Prompt "Enter the number of the user"
        $user = $user[$selection]
    	}
			$user | Select-Object	-Property userId,firstName,lastName,email,@{Name='scimUser'; Expression = {$_.provisioned}}
		} elseif ($PSCmdlet.ParameterSetName -eq 'email') {
			Read-VerkadaCommandUsers -org_id $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth | Where-Object {$_.email -eq $email} | Select-Object	-Property userId,firstName,lastName,email,@{Name='scimUser'; Expression = {$_.provisioned}}
		}
	} #end process

	End {
		
	}
} #end function