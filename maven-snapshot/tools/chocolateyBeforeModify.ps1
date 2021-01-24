$tools = Split-Path $MyInvocation.MyCommand.Definition
$package = Split-Path $tools
$installFolder = Join-Path $package "apache-maven"

Remove-Item $installFolder -Force -Recurse