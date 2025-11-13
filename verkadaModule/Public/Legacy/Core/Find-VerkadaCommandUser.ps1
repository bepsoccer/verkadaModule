function Find-VerkadaCommandUser {
	<#
		.SYNOPSIS
		Finds the Command users' details in an organization
		
		.DESCRIPTION
		This function is used to find all the details of Command users.  
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Find-VerkadaCommandUser.md

		.EXAMPLE
		Find-VerkadaCommandUser -userId '3651fbcb-f8ba-4248-ad70-3f6512fd7b6c' 
		This will attempt to get the user details of a user with the userId of '3651fbcb-f8ba-4248-ad70-3f6512fd7b6c'.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Find-VerkadaCommandUser -email 'bob.smith@contoso.com' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will attempt to find the user details of a user with email address bob.smith@contoso.com.  The org_id and tokens are submitted as parameters in the call.
		
		.EXAMPLE
		Find-VerkadaCommandUser -Name 'Bob Smith'
		This will attempt to find the user details of a user named "Bob Smith".  Depending of the name submitted, i.e. could just be a first or last name, multiple results could be returned.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>

	[CmdletBinding(PositionalBinding = $true, DefaultParameterSetName = 'userId')]
	param (
		#The userId of the user being searched for
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'userId')]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$userId,	
		#The email address of the user being searched for
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'email')]
		[String]$email,
		#The name of the user being searched for
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'name')]
		[String]$Name,
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
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

		$url = "https://vgateway.command.verkada.com/graphql"

		$userFragment = 'fragment CommandUser on User {
	created
	email
	emailVerified
	firstName
	groups {
		...BaseGroup
		__typename
	}
	roleGrants {
		grantId
		entityId
		start
		expiration
		role {
			roleId
			key
			__typename
		}
		__typename
	}
	isOrganizationAdmin
	lastName
	name
	modified
	lastLogin
	organizationId
	phone
	phoneVerified
	provisioned
	deactivated
	deleted
	userId
	__typename
}'
			
		$baseGroupFragment = 'fragment BaseGroup on SecurityEntityGroup {
	name
	entityGroupId
	provisioned
	__typename
}'
	} #end begin
	
	process {
		$queryBase = 'query GetCommandUsers($filter: UsersFilter!, $pagination: PageOptions) {
	users(filter: $filter, pagination: $pagination) {
		nextPageToken
		users {
			...CommandUser
			__typename
		}
		__typename
	}
}'

		$variables= '{
			"filter": {
					"organizationId": "",
					"groupIds": [],
					"roleGrants": [],
					"query":{
							"conjunction":"OR",
							"predicates":[
									{
									"operator":"WILDCARD",
									"field":"",
									"value":""
									}
							]
					},
					"status": [
							"active"
					]
			},
			"pagination": {
					"pageSize":100,
					"pageToken":"",
					"pageSort": [
							{
									"field": "NAME",
									"direction": "ASC"
							},
							{
									"field": "EMAIL",
									"direction": "ASC"
							}
					]
			}
	}' | ConvertFrom-Json

		$variables.filter.organizationId = $org_id
		if ($email){
			$variables.filter.query.predicates[0].field = 'EMAIL'
			$variables.filter.query.predicates[0].value = "*$email*"
			$callType = 'query'
		} elseif ($Name) {
			$variables.filter.query.predicates[0].field = 'NAME'
			$variables.filter.query.predicates[0].value = "*$name*"
			$callType = 'query'
		} elseif ($userId) {
			$queryBase = 'query GetCommandUser($id: ID) {
					user(id: $id) {
							...CommandUser
							__typename
					}
			}'
			$variables = '{"id":""}' | ConvertFrom-Json
			$variables.id = $userId
			$callType = 'userId'
		}

		$query = $queryBase + "`n" + $userFragment + "`n" + $baseGroupFragment

		if ($callType -eq 'userId'){
			$users = Invoke-VerkadaGraphqlCall $url -query $query -qlVariables $variables -org_id $org_id -method 'Post' -propertyName 'user' -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr
		} else {
			$users = Invoke-VerkadaGraphqlCall $url -query $query -qlVariables $variables -org_id $org_id -method 'Post' -propertyName 'users' -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -pagination
		}

		return $users
	} #end process
	
	end {
		#still needs work if needed
	} #end end
} #end function