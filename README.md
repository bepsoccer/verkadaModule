# Verkada PowerShell Module - USE AT YOUR OWN RISK

This is a personal project that provides an easier way to interact with Verkada Command's various endpoints in a programatic way for ad-hoc tasks.  While I have invested time and effort to ensuring proper functionality and error handling, the user of this module is solely responsible of any outcome from it's use.

## How to install

Install the latest version of the Verkada module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/verkadaModule):

`Install-Module -Name verkadaModule`

## Getting started

To use this module you will need a valid API key for some tasks and username/password for others.  Every function will allow you to specify the required credential information directly within the call, however `Connect-Verkada` exists to make use of this module easier.  It will cache the pertent connection information for the session.  If you need to switch orgs you are interaction with or use a different token, you can use `Disconnect-Verkada` to remove the cached session info and start over.

To connect via API key use:

`Connect-Verkada -org_id [your org_id] -x_api_key [your API key]`

To connect via username/password use:

`Connect-Verkada -org_id [your org_id] -userName [your username] -Password`

To connect via both(commonly needed) use:

`Connect-Verkada -org_id [your org_id] -x_api_key [your API key] -userName [your username] -Password`

To connect via both for unattentended use you can now submit your password without prompt.  This requires that you first store the password as a SecureString variable and pass that to the MyPwd parameter:

`Connect-Verkada -org_id [your org_id] -x_api_key [your API key] -userName [your username] -MyPwd $yourPwd`

## The Docs

All available functions can be found in [Public](verkadaModule/Public) and can also be enumerated using `Get-Command -Module verkadaModule`

Common uses and reference documentation can be found [here](docs/README.md)
