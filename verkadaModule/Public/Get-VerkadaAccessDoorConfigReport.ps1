function Get-VerkadaAccessDoorConfigReport{
	<#
		.SYNOPSIS

		.DESCRIPTION
		
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.

		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessDoorConfigReport.md

		.EXAMPLE
		The org_id and tokens will be populated from the cached created by Connect-Verkada.

		.EXAMPLE
		The org_id and tokens are submitted as parameters in the call.
	#>
	[CmdletBinding(PositionalBinding = $true)]
	param (
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
		[string]$usr = $Global:verkadaConnection.usr,
		#This is a switch to indicate we're gonna try to make the report prettier
		[Parameter()]
		[switch]$beautify,
		#This is a switch to indicate we're gonna try to make the report a pretty html
		[Parameter()]
		[switch]$outReport,
		#This is the path the pretty html report will attempt to be saved to
		[Parameter()]
		[string]$reportPath,
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

		$acControllers = Read-VerkadaAccessEntities | select-Object -ExpandProperty accessControllers
		if(!($Global:verkadaBuildings) -or $refresh.IsPresent){
			Invoke-VerkadaCommandInit | Out-Null
		}
		$buildings = $Global:verkadaBuildings
		$floors = $Global:verkadaFloors

		function prettyGrouping {
			param (
				$myInput,
				$groupProperty1,
				$groupProperty2,
				$groupProperty3
			)
			$temp = @()
			$myInput | Group-Object -Property $groupProperty1 | ForEach-Object {$ob = @{"$($_.Name.toString())"=$_.Group;};$ob = $ob | ConvertTo-Json -Depth 10 | ConvertFrom-Json; $temp += $ob}
			[array]$temp = @(groupRemoveProp $temp $groupProperty1)
			foreach ($group in $temp){
				$temp2 = @()
				$group.($group.psobject.Properties.name) | Group-Object -Property $groupProperty2 | ForEach-Object {$ob = @{"$($_.Name.toString())"=$_.Group;};$ob = $ob | ConvertTo-Json -Depth 10 | ConvertFrom-Json; $temp2 += $ob}
				[array]$temp2 = @(groupRemoveProp $temp2 $groupProperty2)
				foreach ($group2 in $temp2){
					$temp3 = @()
					$group2.($group2.psobject.Properties.name) | Group-Object -Property $groupProperty3 | ForEach-Object {$ob = @{"$($_.Name.toString())"=$_.Group;};$ob = $ob | ConvertTo-Json -Depth 10 | ConvertFrom-Json; $temp3 += $ob}
					[array]$temp3 = @(groupRemoveProp $temp3 $groupProperty3)
					foreach ($name in $temp3){
						$names = $name.($name.psobject.Properties.name) | Select-Object -ExpandProperty name
						$name.($name.psobject.Properties.name) = $names
					}
					$group2.($group2.psobject.Properties.name) = $temp3
				}
				$group.($group.psobject.Properties.name) = $temp2
			}
			return $temp | ConvertTo-Json -Depth 10 -Compress
		}
		
		function groupRemoveProp {
			param (
				$myInput,
				$groupingProp
			)
			foreach ($group in $myInput){
				$thing = $group.($group.psobject.Properties.name)
				foreach ($prop in $thing){
					$prop.PSObject.Properties.Remove($groupingProp)
				}
			}
			return $myInput
		}

		function listFormatter {
			param (
				$myInput,
				$level=1,
				$a=$false,
				$arrayItem,
				$open,
				$close
			)
			switch ($level) {
				default {}
				1 {$class = 'building'}
				2 {$class = 'floor'}
				3 {$class = 'acController'}
				4 {$class = 'door'}
			}
			$s=''
			if ($myInput.GetType().baseType.name -eq 'Array'){
				for($i=0; $i -lt $myInput.count; $i++) {
					$close=$false
					$open=$false
					if($i -eq $($($myInput.count)-1)){
						$close = $true
					} elseif ($i -eq 0) {
						$open = $true
					} else {
						$a=$false
					}
					listFormatter $myInput[$i] $level $a $true $open $close
				}
			} elseif ($myInput.GetType().name -eq 'String') {
				if (!($arrayItem) -or $open){
					$s+="<ul>"
				}
				$s+="<li class=`"$class`">$myInput</li>"
				if (!($arrayItem) -or $close){
					$s+="</ul></ul>"
				}
				$s
			} else {
				if($level -eq 1){
					$s+="<li class=`"$class`">$($myInput.psobject.Properties.name)</li>"
					$a=$true
				} elseif ($level -eq 2) {
					Write-Host "variable a is $a"
					if($a){
						$s+="<ul><li class=`"$class`">$($myInput.psobject.Properties.name)</li>"
					} else {
						$s+="</ul><ul><li class=`"$class`">$($myInput.psobject.Properties.name)</li>"
					}
				} else {
					$s+="<ul><li class=`"$class`">$($myInput.psobject.Properties.name)</li>"
				}
				$s
				$level++
				listFormatter $myInput.($myInput.psobject.Properties.name) $level $a
			}
		}

		function jsonToList {
			param (
				$myJson
			)
			$json = $myJson | ConvertFrom-Json
			$s='<ul>'
			$s += (listFormatter $Json)
			$s+="</ul>"
			return $s
		}
	} #end begin
	
	process {
		$doors = Get-VerkadaAccessDoors
		foreach($door in $doors){
			$controllerInfo = $acControllers | Where-Object {$_.deviceId -eq $door.accessControllerId} | Select-Object name,serialNumber
			$door | Add-Member -NotePropertyName 'acControllerName' -NotePropertyValue $controllerInfo.name
			$door | Add-Member -NotePropertyName 'serialNumber' -NotePropertyValue $controllerInfo.serialNumber
			$door | Add-Member -NotePropertyName 'FloorName' -NotePropertyValue ($floors | Where-Object {$_.floorId -eq $door.floorId} | Select-Object -ExpandProperty name)
			$buildingid = $floors | Where-Object {$_.floorId -eq $door.floorId} | Select-Object -ExpandProperty buildingId
			$building = $buildings | Where-Object {$_.buildingId -eq $buildingid}
			$door | Add-Member -NotePropertyName 'buildingName' -NotePropertyValue $building.name
			$door | Add-Member -NotePropertyName 'buildingAddress' -NotePropertyValue $building.address
			$door | Add-Member -NotePropertyName 'buildingid' -NotePropertyValue $building.buildingId
			if ($beautify -or $outReport){
				$door.name = $door.name + " - Slot: " + $door.doorIndex
				$door.acControllerName = $door.acControllerName + " (" + $door.serialNumber + ")"
				$door.buildingName = $door.buildingName + " - " + $door.buildingAddress
			}
			
		}

		if ($beautify -or $outReport){
			$doors = prettyGrouping $doors 'buildingName' 'floorName' 'acControllerName'

			if($outReport){
				$doors = jsonToList $doors
			}
		}

		return $doors
	} #end process
	
	end {
		
	} #end end
} #end function