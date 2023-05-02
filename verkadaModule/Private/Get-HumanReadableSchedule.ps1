function Get-HumanReadableSchedule {
	param (
		$events
	)
	$sched = @()
	$output = @()
	$events | %{
		switch ($_.weekday) {
			1 {$weekday = 'M'}
			2 {$weekday = 'Tu'}
			3 {$weekday = 'W'}
			4 {$weekday = 'Th'}
			5 {$weekday = 'F'}
			6 {$weekday = 'Sa'}
			7 {$weekday = 'Su'}
		}
		$time = "$(get-date($_.startTime) -Format "h:mmt")-$(get-date($_.endTime) -Format "h:mmt")"
		$day = @{
			'weekday'	= $weekday
			'time'		= $time
		}
		$day = $day | ConvertTo-Json | ConvertFrom-Json
		$sched += $day
	}
	$uniTime = $sched | Select-Object time -Unique
	foreach ($t in $uniTime){
		$temp = @()
		$temp += $sched | ? {$_.time -eq $t.time} | Select-Object -ExpandProperty weekday
		$temp = $temp -join ','
		$out = "($temp $($t.time))"
		$output += $out
	}
	return ($output -join ',').Replace(':00','')
}