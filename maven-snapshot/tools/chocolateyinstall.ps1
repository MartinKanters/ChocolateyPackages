# This function reads the registry key instead of the environment variable to avoid variable expansion.
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

$checksum = "341517bd8f0671e2d8fa8b79e232bb2d909f2b48080d98b9bc152b84df6a4b51"
$url = "https://repository.apache.org/content/groups/snapshots/org/apache/maven/apache-maven/3.9.3-SNAPSHOT/apache-maven-3.9.3-20230508.090901-2-bin.zip"
$tools = Split-Path $MyInvocation.MyCommand.Definition
$package = Split-Path $tools
$m2_home = Join-Path $package "apache-maven"
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
