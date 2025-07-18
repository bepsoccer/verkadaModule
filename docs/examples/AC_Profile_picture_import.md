# Bulk Importing AC Profile Pictures

Say you want to bulk import AC profile pictures by dropping them in a folder and naming the image files using a unique identifier.  The first the first thing you need to do is authenticate:

```powershell
Connect-Verkada -org_id [your_orgId] -x_api_key (Get-Secret -Name VrkdApiKey -AsPlainText)

#or for simplicity when not using secrets.

Connect-Verkada -org_id [your_orgId] -x_api_key [your_api_key]
```

>Then if you've named the image files using the user's **user_id**, like fc6c3648-aa4a-4999-b1a0-a64b81e2cb76.jpg, you can use something like this:
>
>```powershell
>Get-ChildItem ~/Documents/AC_profile_pictures | ForEach-Object { Set-VerkadaAccessUserProfilePicture -userId $_.BaseName -imagePath $_.FullName }
>```

or

>If you've named the image files using the user's **external_id**, like emId98765.jpg, you can use something like this:
>
>```powershell
>Get-ChildItem ~/Documents/AC_profile_pictures | ForEach-Object { Set-VerkadaAccessUserProfilePicture -externalId $_.BaseName -imagePath $_.FullName }
>```

or

>If you've named the image files using the user's **email**, like some.user@contoso.com.jpg, we will need to find the user_id to set the picture with something like this:
>
>```powershell
>Get-ChildItem ~/Documents/AC_profile_pictures | ForEach-Object {$temp = $_; read-VerkadaAccessUsers -version v1 -refresh | Where-Object {$_.email -eq $temp.BaseName} | Set-VerkadaAccessUserProfilePicture -imagePath $temp.FullName; $temp = $null}
>```

or

>If you choose to use a csv mapping **user_id's** or **external_id's** to the file path cause there isn't a standard naming convention, a simple csv with the following format like the following will work with something like the line below:
>
>| **user_id** | **imagePath** |
>|-|-|
>| `fc6c3648-aa4a-4999-b1a0-a64b81e2cb76` | `~/Documents/AC_profile_pictures/some.user.jpg` |
>
>OR
>
>| **external_id** | **imagePath** |
>|-|-|
>| `emId98765` | `~/Documents/AC_profile_pictures/some.user.jpg` |
>
>```powershell
>Import-Csv ~/Documents/AC_profile_pictures/user_pictures.csv | Set-VerkadaAccessUserProfilePicture
>```
