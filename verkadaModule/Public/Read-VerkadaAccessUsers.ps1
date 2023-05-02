function Read-VerkadaAccessUsers{
	<#
		.SYNOPSIS
		Gathers all Access Users in an organization

		.DESCRIPTION
		This function will return all the active Access users in an organization.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Read-VerkadaAccessUsers.md

		.EXAMPLE
		Read-VerkadaAccessUsers
		This will return all the active access users in an organization.	The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Read-VerkadaAccessUsers -userId 'aefrfefb-3429-39ec-b042-userAC' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will return all the active access users in an organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		Read-VerkadaAccessUsers -refresh
		This will return all the active access users in an organization with the most recent data available from Command.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	param (
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#This is the graphql query to be submitted (do not use unless you know what you are doing)
		[Parameter(Position = 1)]
		[Object]$query,
		#This is the graphql variables to be submitted (do not use unless you know what you are doing)
		[Parameter(Position = 2)]
		[Object]$variables,
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
		#Switch to force a refreshed list of users from Command
		[Parameter()]
		[switch]$refresh
	)
	
	begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr is missing but is required!"}

		$url = "https://vgateway.command.verkada.com/graphql"

		if ([string]::IsNullOrEmpty($query)){
			$queryBase = 'query GetAccessUserProfile($filter: UsersFilter!, $pagination: PageOptions) {
		users(filter: $filter, pagination: $pagination) {
						nextPageToken
						users {
						...AccessUserProfile
						__typename
						}
						__typename
				}
}'
			$AccessUserProfileFragment = 'fragment AccessUserProfile on User {
		...AccessUser
		accessCardsRaw {
				cacheId
				organizationId
				userId
				active
				cardId
				cardType
				lastUsed
				modified
				cardParams {
						cardNumber
						cardNumberHex
						facilityCode
						__typename
				}
				__typename
		}
		userCodesRaw {
				code
				lastUsed
				__typename
		}
		__typename
}'
			
			$AccessUserFragment = 'fragment AccessUser on User {
		...AccessUserBasic
		employeeId
		employeeTitle
		department
		departmentId
		companyName
		employeeType
		mobileAccess
		bluetoothAccess
		accessUserRoles {
				role
				__typename
		}
		accessGroups {
				group {
						userGroupId
						name
						__typename
				}
				added
				__typename
		}
		accessCards {
				active
				cardId
				cardType
				lastUsed
				modified
				cardParams {
						cardNumber
						facilityCode
						__typename
				}
				__typename
		}
		userCodes {
				code
				lastUsed
				__typename
		}
		roleGrant: roleGrants(filter: {includeExpired: true}) {
				granteeId
				grantId
				entityId
				realGranteeId
				start
				expiration
				role {
						key
						name
						roleId
						permissions {
								permission
								permissionId
								__typename
						}
						__typename
				}
				__typename
		}
		__typename
}'

			$AccessUserBasicFragment = 'fragment AccessUserBasic on User {
		userId
		name
		phone
		firstName
		middleName
		lastName
		email
		emailVerified
		organizationId
		created
		modified
		provisioned
		lastLogin
		lastActiveAccess
		deactivated
		deleted
		roleGrant: roleGrants(filter: {includeExpired: true}) {
				granteeId
				grantId
				entityId
				organizationId
				realGranteeId
				roleId
				start
				expiration
				__typename
		}
		__typename
}'

			$query = $queryBase + "`n" + $AccessUserProfileFragment + "`n" + $AccessUserFragment + "`n" + $AccessUserBasicFragment
		}

		if ([string]::IsNullOrEmpty($variables)){
			$variables= "{
				'filter':{
					'organizationId':'',
					'groupIds':[],
					'roleGrants':[],
					'status':['active']
				},
				'pagination':{
					'pageSize':1,
					'pageToken':'',
					'pageSort':[
						{
							'field':'NAME',
							'direction':'ASC'
						},
						{
							'field':'EMAIL',
							'direction':'ASC'
						}
					]
				}
			}" | ConvertFrom-Json
		}
		$variables.filter.organizationId = $org_id
	}
	
	process {
		if ((!([string]::IsNullOrEmpty($global:verkadaAccessUsers))) -and (!($refresh.IsPresent))) { 
			$users = $Global:verkadaAccessUsers
		} else {
			$users = Invoke-VerkadaGraphqlCall $url -query $query -qlVariables $variables -org_id $org_id -method 'Post' -propertyName 'users' -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -pagination
			$global:verkadaAccessUsers = $users
		}
		return $users
	}
	
	end {
		
	}
}