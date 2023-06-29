function ConvertFrom-PropertylessJson {
	[CmdletBinding()]
	param (
			[Object]$Object1,
			[string]$keyProperty
	)
	$things = $Object1 | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
	$newObject = @()
	foreach ($thing in $things){
		$newThing = $Object1 | Select-Object -ExpandProperty $thing
		$newThing | Add-Member -NotePropertyName $keyProperty -NotePropertyValue $thing
		$Object = [ordered] @{}
		$Object += @{'cameraId' = $newThing.cameraId}
		foreach ($Property in $newThing.PSObject.Properties) {
				if($Property.Name -ne 'cameraId'){
					$Object += @{$Property.Name = $Property.Value}
				}
		}
		$newObject += [pscustomobject] $Object
	}
	return $newObject
}