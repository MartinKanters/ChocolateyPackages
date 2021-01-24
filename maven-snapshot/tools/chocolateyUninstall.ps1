# restore original maven M2_HOME if present
$orig_m2_home = $env:ORIG_M2_HOME;
if (![string]::IsNullOrEmpty($orig_m2_home)) {
	Install-ChocolateyEnvironmentVariable -VariableName "M2_HOME" -VariableValue $orig_m2_home -VariableType Machine
	Install-ChocolateyEnvironmentVariable -VariableName "ORIG_M2_HOME" -VariableValue $null -VariableType Machine
} else {
	Install-ChocolateyEnvironmentVariable -VariableName "M2_HOME" -VariableValue $null -VariableType Machine
}