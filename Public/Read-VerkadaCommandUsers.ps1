function Read-VerkadaCommandUsers
{
	<#
		.SYNOPSIS
		Gathers all Command Users in an organization
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		[Parameter(Position = 0)]
		[string]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Position = 1)]
		[Object]$query,
		[Parameter(Position = 2)]
		[Object]$variables,
		[Parameter()]
		[switch]$withGroups,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$usr_id = $Global:verkadaConnection.usr
	)

	Begin {
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

			$query = $queryBase + "`n" + $userFragment
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
		$response = Invoke-VerkadaGraphqlCall $url -query $query -qlVariables $variables -org_id $org_id -method 'Post' -propertyName 'users' -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -usr_id $usr_id
		return $response
	} #end process
} #end function