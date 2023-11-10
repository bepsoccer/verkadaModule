# Badge sync with Active Directory

```powershell
# Script to sync Verkada ID Badge numbers into a field in AD
# Contribution from Steve Schlomann
# Edited by Brad Parker
# 11-9-2023

Import-Module ActiveDirectory

#set Initial Verkada variables
$VKD_User = '[verkada admin username]'
$VKD_API_Key = Get-Secret -Name VrkdApiKey -AsPlainText #this can be done a myriad of ways.  SecretStore is a microsoft provided secret store, but others are available
$VKD_ORG_ID = '[your ORG ID]'
# Set login password
$Secure_String_Pwd = Get-Secret -Name VrkdPwd #this can be done a myriad of ways but needs to be a secure string.  SecretStore is a microsoft provided secret store, but others are available

#set Initial AD variables
$AttributeName = 'extensionAttribute11' # The name of the attribute you want to add/update

# Connect to the Verkada Server
Connect-Verkada -org_id $VKD_ORG_ID -x_api_key $VKD_API_Key -UserName $VKD_User -MyPwd $Secure_String_Pwd

#Gather all the Verkada Access users
Read-VerkadaAccessUsers -minimal -refresh | ForEach-Object {
  #for each user determine if they have a badge and if so set the $cards variable to the list of the cards property
  $cards=@()
  if($_.accessCards){
    $_.accessCards = Get-VerkadaAccessUser -userId $_.userId | Select-Object -ExpandProperty cards
    foreach($card in $_.accessCards){
      $cards += "$($card.type):$(if($card.facility_code){"$($card.facility_code)-"})$(if($card.card_number){"$($card.card_number)"})$(if($card.card_number_hex){"$($card.card_number_hex)"})$(if($card.card_number_base36){"$($card.card_number_base36)"})"
    }
    $cards = $cards -join ", "
  }
  $Username = $_.email -replace '@.*$',''

  $AttributeValue = $cards

  #Process The AD property
  if($AttributeValue) {
  $user = Get-ADUser -Identity $Username

    # Check if the attribute already has a value
    if ($user.$AttributeName) {
      # If the attribute already has a value, update it
      Set-ADUser -Identity $Username -Replace @{ $AttributeName = $AttributeValue }

      Write-Host "Attribute '$AttributeName' updated for user '$Username' with value: '$AttributeValue'"
    } else {
      # If the attribute doesn't have a value, add it
      Set-ADUser -Identity $Username -Add @{ $AttributeName = $AttributeValue }

      Write-Host "Attribute '$AttributeName' added for user '$Username' with value: '$AttributeValue'"
    }
  }

  # Reset the attributes to process the next user
  $Username = $null
  $AttributeValue = $null
}
```
