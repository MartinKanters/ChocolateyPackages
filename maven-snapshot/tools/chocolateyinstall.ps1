﻿# This function reads the registry key instead of the environment variable to avoid variable expansion.
function IsM2HomeBinInPath ([string]$pathToAdd) {
	try {
		$regKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', $true)
		$unexpandedPath = $regKey.GetValue('Path', $null, 'DoNotExpandEnvironmentNames')

		foreach ($path in "$unexpandedPath".split(';')) {
			if ($pathToAdd -ieq $path -or "$pathToAdd\" -ieq $path) {
				return $true
			}
		}
		return $false;
	}
	finally {
		$regKey.Dispose()
	}
}

$checksum = "23e17927b7863ac709a2da79e1b4f8e250823e3b2336d3226134f4052094c835"
$url = "https://repository.apache.org/content/groups/snapshots/org/apache/maven/apache-maven/4.0.0-rc-4-SNAPSHOT/apache-maven-4.0.0-rc-4-20250330.212707-38-bin.zip"
$tools = Split-Path $MyInvocation.MyCommand.Definition
$package = Split-Path $tools
$m2_home = Join-Path $package "apache-maven-apache-maven-4.0.0-rc-4-SNAPSHOT"
$pathToAdd = Join-Path '%M2_HOME%' 'bin'
$m2_repo = Join-Path $env:USERPROFILE '.m2'

Install-ChocolateyZipPackage `
    -PackageName 'Maven Snapshot' `
    -Url $url `
    -Checksum $checksum `
    -ChecksumType 'sha256' `
    -UnzipLocation $package

# install ~/.m2 folder if it does not exist yet
New-Item -Path $m2_repo -type directory -Force

# save the original M2_HOME in order to switch back to the latest maven when maven-snapshot is uninstalled
$current_m2_home = $env:M2_HOME;
$orig_m2_home = $env:ORIG_M2_HOME;
if (![string]::IsNullOrEmpty($current_m2_home) -and [string]::IsNullOrEmpty($orig_m2_home)) {
	Install-ChocolateyEnvironmentVariable -VariableName "ORIG_M2_HOME" -VariableValue $current_m2_home -VariableType Machine
}

# Overwrite M2_HOME to maven-latest
Install-ChocolateyEnvironmentVariable -VariableName "M2_HOME" -VariableValue $m2_home -VariableType Machine

# Add "%M2_HOME%\bin in %PATH% if it's not yet there
$alreadyInPath = IsM2HomeBinInPath($pathToAdd)
if ($alreadyInPath -eq $false) {
	Install-ChocolateyPath -PathToInstall $pathToAdd -PathType 'Machine'
}
