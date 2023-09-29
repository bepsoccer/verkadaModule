$myMod = 'verkadaModule'
$mypath = $PSScriptRoot | Split-Path -Parent
import-Module $mypath/$myMod/$myMod.psm1
update-ModuleManifest -Path "$mypath/$myMod/$myMod.psd1" -FunctionsToExport (Get-ChildItem -Path $mypath/$myMod/Public/*.ps1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty BaseName) -AliasesToExport (Get-Command -Module verkadaModule | ForEach-Object {Get-Alias -Definition $_.name -ea 0} | Select-Object -ExpandProperty Name)
import-Module $mypath/$myMod/$myMod.psm1 -Force
update-ModuleManifest -Path "$mypath/$myMod/$myMod.psd1" -FunctionsToExport (Get-ChildItem -Path $mypath/$myMod/Public/*.ps1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty BaseName) -AliasesToExport (Get-Command -Module verkadaModule | ForEach-Object {Get-Alias -Definition $_.name -ea 0} | Select-Object -ExpandProperty Name)
new-MarkdownHelp -Module $myMod -OutputFolder $mypath/docs/function-documentation -Force | Out-Null

Write-output "# Verkada PowerShell module" | Out-File $mypath/docs/reference.md -Force
Write-output "## Command Documentation" | Out-File $mypath/docs/reference.md -Append
Get-ChildItem -Path $mypath/$myMod/Public/*.ps1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty BaseName | ForEach-Object {write-output "* [$_](function-documentation/$_.md)"} | Out-File $mypath/docs/reference.md -Append

$manifest = Import-PowerShellDataFile "$mypath/$myMod/$myMod.psd1" 
[version]$version = $Manifest.ModuleVersion
switch ($Args[0]) {
	'major' {
		# Add one to the major of the version number
		[version]$NewVersion = "{0}.{1}.{2}" -f ($Version.Major + 1), '0', '0'
	}
	'minor' {
		# Add one to the minor of the version number
		[version]$NewVersion = "{0}.{1}.{2}" -f $Version.Major, ($Version.Minor + 1), '0'
	}
	default {
		# Add one to the build of the version number
		[version]$NewVersion = "{0}.{1}.{2}" -f $Version.Major, $Version.Minor, ($Version.Build + 1)
	}
}
# Update the manifest file
Update-ModuleManifest -Path "$mypath/$myMod/$myMod.psd1" -ModuleVersion $NewVersion
return $NewVersion.ToString()