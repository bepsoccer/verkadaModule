# Bulk Wireless Alarms Sensor Setting Changes

Say you want to bulk set all the panic buttons in an organization to use triple press for activation.  First we need to authenticate.

```powershell
Connect-Verkada -org_id [your_orgId] -x_api_key [your_api_key] -UserName [your_username] -password
```

Then gather a list of all the deviceId's of the panic buttons in the org and pipe that into the function to change panic button settings.

```powershell
Get-VerkadaAlarmsDevices | Select-Object -ExpandProperty panicButton | Set-VerkadaAlarmsPanicButtonSettings  -panicPressType 'triple'
```

If you wanted to change the sensativity of all the door contact sensors in the site named 'My Alarm Site' to be high you would similarly gather the list necessary and pipe it into the function to change door contact senor settings.

```powershell
#gather the siteId(zoneId) of our alarm site
$siteId = Read-VerkadaAlarmsSites | Where-Object {$_.siteName -eq 'My Alarm Site'} | Select-Object -ExpandProperty zoneId

#set all the door contact sensors in this site to high.
Get-VerkadaAlarmsDevices | Select-Object -ExpandProperty doorContactSensor | Where-Object {$_.zoneId -eq $siteId} | Set-VerkadaAlarmsDoorSensorSettings -sensitivity 'high'
```
