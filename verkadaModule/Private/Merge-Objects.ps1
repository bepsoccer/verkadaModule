function Merge-Objects {
	[CmdletBinding()]
	param (
			[Object] $Object1,
			[Object] $Object2
	)
	$Object = [ordered] @{}
	foreach ($Property in $Object1.PSObject.Properties) {
			$Object += @{$Property.Name = $Property.Value}

	}
	foreach ($Property in $Object2.PSObject.Properties) {
			if((!$Object.$($Property.Name))){
				$Object += @{$Property.Name = $Property.Value}
			}
	}
	return [pscustomobject] $Object
}