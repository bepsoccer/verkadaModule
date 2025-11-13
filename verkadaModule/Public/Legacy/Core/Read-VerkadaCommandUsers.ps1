function Read-VerkadaCommandUsers
{
	<#
		.SYNOPSIS
		Gathers all Command Users in an organization
		
		.DESCRIPTION
		This function will return all the active Command users in an organization.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Read-VerkadaCommandUsers.md

		.EXAMPLE
		Read-VerkadaCommandUsers
		This will return all the active users in an organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Read-VerkadaCommandUsers -userId 'aefrfefb-3429-39ec-b042-userAC' -org_id '7cd47706-f51b-4419-8675-3b9f0ce7c12d' -x_verkada_token 'a366ef47-2c20-4d35-a90a-10fd2aee113a' -x_verkada_auth 'auth-token-uuid-dscsdc' -usr 'a099bfe6-34ff-4976-9d53-ac68342d2b60'
		This will return all the active users in an organization.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Read-VerkadaCommandUsers -refresh
		This will return all the active users in an organization with the most recent data available from Command.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(Position = 0)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$org_id = $Global:verkadaConnection.org_id,
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

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
		if ([string]::IsNullOrEmpty($usr)) {throw "usr_id is missing but is required!"}
		
		$url = "https://vgateway.command.verkada.com/graphql"

		if ([string]::IsNullOrEmpty($query)){
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

			$query = $queryBase + "`n" + $userFragment + "`n" + $baseGroupFragment
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
	} #end begin
	
	Process {	
		if ((!([string]::IsNullOrEmpty($global:verkadaUsers))) -and (!($refresh.IsPresent))) { 
			$users = $Global:verkadaUsers
		} else {
			$users = Invoke-VerkadaGraphqlCall $url -query $query -qlVariables $variables -org_id $org_id -method 'Post' -propertyName 'users' -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr $usr -pagination
			$global:verkadaUsers = $users
		}
		return $users
	} #end process
} #end function