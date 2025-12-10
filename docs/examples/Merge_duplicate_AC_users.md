# Merge Duplicate AC Users

Say you want to find duplicate AC users and merge their group membership, cards, and profile pictures.  First thing to do is to get an export of the AC users from Command.  Then, add a new field to the CSV, **duplicate_userId**.  Then we will use that CSV for the import in the script.

```powershell
Connect-Verkada -x_api_key (Get-Secret -Name VrkdApiKey -AsPlainText)

#or for simplicity when not using secrets.

Connect-Verkada -x_api_key [your_api_key]
```

After connecting, we will import the user CSV and create our logic for determining duplicate Ids and which user we want to live on.

```powershell
# import users
$exportedUsers = Import-Csv ~/command-user-export.csv

# find users with emails that have duplicate users with the same first and last names
# this logic can be changed to meet the needs to determine duplicates
foreach ($user in $exportedUsers){
  if (!([string]::IsNullOrEmpty($user.email))){
    $user.duplicate_userId = $exportedUsers | Where-Object {[string]::IsNullOrEmpty($_.email) -and $_.firstName -ieq $user.firstName -and $_.lastName -ieq $user.lastName} | Select-Object -ExpandProperty userId
  }
}
$duplicateSCIMusers = $exportedUsers | Where-Object {!([string]::IsNullOrEmpty($_.duplicate_userId))}
```

Once we have the duplicate_userId field added to our CSV the logic below will describe what will be done in the output and perform it in Command.

```powershell
Start-Transcript -Path ~/transcript_output.txt
$doWork = $false
foreach ($dupe in $duplicateSCIMusers){
  foreach ($dupeId in $dupe.duplicate_userId){
    # determine if duplicate is active
    if ($dupe.status -ieq 'active'){
      if (($exportedUsers | Where-Object {$_.userId -eq $dupeId}).status -ieq 'active'){
        write-host "$($dupe.firstName) $($dupe.lastName) - $($dupe.userId) SCIM user is active and has the duplicate account $($dupeId) for us to work on"
        $doWork = $true
      } else {
        write-host "Will do nothing, $($dupe.firstName) $($dupe.lastName) - $($dupe.userId) SCIM user is active but the duplicate account $($dupeId) is $(($exportedUsers | Where-Object {$_.userId -eq $dupeId}).status)."
        $doWork = $false
      }
    } else {
      if (($exportedUsers | Where-Object {$_.userId -eq $dupeId}).status -ieq 'active'){
        write-host "$($dupe.firstName) $($dupe.lastName) - $($dupe.userId) SCIM user is $($dupe.status) but the duplicate account $($dupeId) is active, what should we do?"
        $doWork = $false
      } else {
        write-host "Will do nothing, Neither $($dupe.firstName) $($dupe.lastName) - $($dupe.userId) SCIM user or the duplicate account $($dupeId) is active."
        $doWork = $false
      }
    }

    if($doWork){
      # gather all the groups the duplicate is a part of
      try {
        $groups = Get-VerkadaAccessUser -userId $dupeId -ErrorAction Stop | Select-Object -ExpandProperty access_groups
        Write-host "$($dupeId) is part of the following AC Groups: $($groups.name -join ',')"
        $scimUserGroups = Get-VerkadaAccessUser -userId $dupe.userId | Select-Object -ExpandProperty access_groups | Select-Object -ExpandProperty group_id
        foreach ($group in $groups){
          # determine if the user is already apart of that group
          If ($scimUserGroups -contains $group.group_id ){
            Write-Host "$($dupe.firstName) $($dupe.lastName) - $($dupe.userId) is already a part of $($group.name) and doesn't need to be added"
          } else {
            Write-Host "$($dupe.firstName) $($dupe.lastName) - $($dupe.userId) needs to be added to $($group.name)"
            # add user to group if necessary
            Set-VerkadaAccessUserGroup -userId $dupe.userId -groupId $group.group_id
          }
        }
        $scimUserGroups = $null
      } catch {
        $groups = @()
        Write-Host "$($dupeId) is not part of any AC groups"
      }

      # gather all the cards the duplicate has
      $cards = Get-VerkadaAccessUser -userId $dupeId | Select-Object -ExpandProperty cards | Where-Object {$_.active -eq $true}
      if ([string]::IsNullOrEmpty($cards)){
        Write-Host "$($dupeId) has no active cards to move"
      } else {
        Write-host "$($dupeId) has the following cards to move to $($dupe.firstName) $($dupe.lastName) - $($dupe.userId): $($cards.card_number -join ',')"
        # assign those cards to the SCIM user
        foreach ($card in $cards){
          Add-VerkadaAccessUserCard -userId $dupe.userId -cardType $card.type -cardNumber $card.card_number -facilityCode $card.facility_code -active $true
        }
      }

      # determine if duplicate has a photo and the SCIM user doesn't
      if (!(Get-VerkadaAccessUser -userId $dupe.userId | Select-Object -ExpandProperty has_profile_photo)){
        if (Get-VerkadaAccessUser -userId $dupeId | Select-Object -ExpandProperty has_profile_photo){
          Write-Host "$($dupeId) has a profile photo to copy to $($dupe.firstName) $($dupe.lastName) - $($dupe.userId)"
          # get profile photo
          Get-VerkadaAccessUserProfilePicture -userId $dupeId -original $true -outPath ~/Downloads/tempPics/

          # add profile photo to SCIM user
          Set-VerkadaAccessUserProfilePicture -userId $dupe.userId -imagePath "~/Downloads/tempPics/$dupeId.jpg"
        }
      }
      # deactivtate the duplicate user
      Set-VerkadaAccessUserEndDate -userId $dupeId -endDate (Get-Date)
    }
    $doWork = $false
    
    Write-Host ""
  }

}
Stop-Transcript
```
