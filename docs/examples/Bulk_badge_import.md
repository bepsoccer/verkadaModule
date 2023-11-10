# Bulk Badge Import

Say you need to bulk import badges for users, even multiple badges per user.  First you need to issue the Connect command to make authentication easy:

```powershell
Connect-Verkada -org_id [your_orgId] -x_api_key (Get-Secret -Name VrkdApiKey -AsPlainText) -UserName [your_username] -MyPwd (Get-Secret -Name VrkdUsrPwd)
```

From here we need a csv (or however you want to bring in the data) with a line for each badge you want to import.  The headers required are userId, cardType, facilityCode, and cardNumber.  ***Note: Some card types require different fields, but that is outside of the scope of this example.***

If you don't have a list of the userId's ahead of time, you can simply grab them using this:

```powershell
Read-VerkadaAccessUsers -minimal | Select-Object userId,name,email | Export-Csv ./userlist.csv
```

If you are starting with a csv like pictured here to add multiple badges for a user ***Note: this can be as many users as you want.***

| **userId** | **email** | **cardType** | **facilityCode** | **cardNumber** |
|-|-|-|-|-|
| | `some.user@contoso.com` | HID | 123 | 45678 |
| | `some.user@contoso.com` | Corporate1000_35 | 100 | 9876 |

But simply lack the userId's for the users in question you can run this to populate the userId attrbute for each user:

```powershell
$myCsv = Import-Csv ~/Desktop/testing.csv

Foreach ($user in $myCsv){
  $user.userId = Find-VerkadaUserId -email $user.email | Select-Object -ExpandProperty userId
}
```

Once your `$myCsv` variable is populated with userId's you will run this to add the badges.  ***Note: you can stop at the import above if you already have the userId's ahead of time***:

```powershell
$myCsv | Add-VerkadaAccessUserCard

#or to simplify if you have the userId's in the CSV ahead of time

Import-Csv ~/Desktop/testing.csv | Add-VerkadaAccessUserCard
```
