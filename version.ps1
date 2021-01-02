
$versioningScripts=Join-Path $PSScriptRoot '_scripts\Versioning.ps1'
. $versioningScripts

$targetFiles | GetVersion -AsString
