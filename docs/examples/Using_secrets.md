# Working with SecretStore

[Start with Microsoft's SecretStore](https://learn.microsoft.com/en-us/powershell/utility-modules/secretmanagement/how-to/using-secrets-in-automation?view=ps-modules)

If you need to retrieve an API key and submit it as plain text.

```powershell
$vrkdApiKey = Get-Secret -Name VrkdApiKey -AsPlainText
Connect-Verkada -org_id [your_orgId] -x_api_key $vrkdApiKey

#or

Connect-Verkada -org_id [your_orgId] -x_api_key (Get-Secret -Name VrkdApiKey -AsPlainText)
```

If you need to retrieve a user password and submit it as a SecureString.

```powershell
$vrkdUsrPwd = Get-Secret -Name VrkdUsrPwd
Connect-Verkada -org_id [your_orgId] -UserName [your_username] -MyPwd $vrkdUsrPwd

#or

Connect-Verkada -org_id [your_orgId] -UserName [your_username] -MyPwd (Get-Secret -Name VrkdUsrPwd)
```
