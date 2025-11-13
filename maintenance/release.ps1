$myMod = 'verkadaModule'
$mypath = $PSScriptRoot | Split-Path -Parent
import-Module $mypath/$myMod/$myMod.psm1
update-ModuleManifest -Path "$mypath/$myMod/$myMod.psd1" -FunctionsToExport (Get-ChildItem -Path $mypath/$myMod/Public/ -Recurse -Include *.ps1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty BaseName) -AliasesToExport (Get-Command -Module verkadaModule | ForEach-Object {Get-Alias -Definition $_.name -ea 0} | Select-Object -ExpandProperty Name)
import-Module $mypath/$myMod/$myMod.psm1 -Force
update-ModuleManifest -Path "$mypath/$myMod/$myMod.psd1" -FunctionsToExport (Get-ChildItem -Path $mypath/$myMod/Public/ -Recurse -Include *.ps1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty BaseName) -AliasesToExport (Get-Command -Module verkadaModule | ForEach-Object {Get-Alias -Definition $_.name -ea 0} | Select-Object -ExpandProperty Name)
Get-ChildItem -Path $mypath/docs/function-documentation -Recurse | Remove-Item -Force -Recurse -Confirm:$false | Out-Null
New-MarkdownHelp -Module $myMod -OutputFolder $mypath/docs/function-documentation -Force | Out-Null

Write-output "# Verkada PowerShell module`n" | Out-File $mypath/docs/reference.md -Force
Write-output "## Command Documentation" | Out-File $mypath/docs/reference.md -Append

Get-ChildItem $mypath/$myMod/Public/ | ForEach-Object {
	If(!($_.BaseName -eq 'Legacy')){
		Write-Output "`n### $($_.BaseName)`n" | Out-File $mypath/docs/reference.md -Append
		$tempDir=$_.BaseName
		Get-ChildItem $_ | ForEach-Object {
			if (!(Test-Path -Path "$mypath/docs/function-documentation/$tempDir/" -PathType Container)) {
					New-Item -Path "$mypath/docs/function-documentation/$tempDir/" -ItemType Directory -Force
			}
			Move-Item -Path "$mypath/docs/function-documentation/$($_.BaseName).md" -Destination "$mypath/docs/function-documentation/$tempDir/" -Force
			Write-Output "* [$($_.BaseName)](function-documentation/$tempDir/$($_.BaseName).md)" | Out-File $mypath/docs/reference.md -Append
		}
	} else {
		Write-Output `n"### Legacy" | Out-File $mypath/docs/reference.md -Append
		$tempDir=$_.BaseName
		Get-ChildItem $_ | ForEach-Object {
			Write-Output "`n#### Legacy $($_.BaseName)`n" | Out-File $mypath/docs/reference.md -Append
			$tempDir2=$_.BaseName
			Get-ChildItem $_ | ForEach-Object {
				if (!(Test-Path -Path "$mypath/docs/function-documentation/$tempDir/$tempDir2/" -PathType Container)) {
						New-Item -Path "$mypath/docs/function-documentation/$tempDir/$tempDir2/" -ItemType Directory -Force
				}
				Move-Item -Path "$mypath/docs/function-documentation/$($_.BaseName).md" -Destination "$mypath/docs/function-documentation/$tempDir/$tempDir2/" -Force
				Write-Output "* [$($_.BaseName)](function-documentation/$tempDir/$tempDir2/$($_.BaseName).md)" | Out-File $mypath/docs/reference.md -Append
			}
		}
	}
}

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