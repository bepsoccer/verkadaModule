$myMod = 'verkadaModule'
$mypath = $PSScriptRoot | Split-Path -Parent
import-Module $mypath/$myMod/$myMod.psm1
update-ModuleManifest -Path "$mypath/$myMod/$myMod.psd1" -FunctionsToExport (Get-ChildItem -Path $mypath/$myMod/Public/*.ps1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty BaseName) -AliasesToExport (Get-Command -Module verkadaModule | ForEach-Object {Get-Alias -Definition $_.name -ea 0} | Select-Object -ExpandProperty Name)
import-Module $mypath/$myMod/$myMod.psm1 -Force
update-ModuleManifest -Path "$mypath/$myMod/$myMod.psd1" -FunctionsToExport (Get-ChildItem -Path $mypath/$myMod/Public/*.ps1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty BaseName) -AliasesToExport (Get-Command -Module verkadaModule | ForEach-Object {Get-Alias -Definition $_.name -ea 0} | Select-Object -ExpandProperty Name)