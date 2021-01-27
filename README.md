# Maven-snapshot choco package

This package installs the latest built snapshot Maven distribution from the Apache Jenkins on the master branch. 
	
*Take care that these builds can be unstable!*
	
## Switching between existing Maven and Snapshot
This package will be installed next to an existing Maven installation. By uninstalling this package you will switch back to that Maven installation.

## Example

```
> mvn -v
Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)
...
> choco install maven-latest -y
> refreshenv
> mvn -v
Apache Maven 4.0.0-alpha-1-SNAPSHOT (bb916d0784c7631866167928e4d0615df3317567)
...
> choco uninstall maven-latest -y
> refreshenv
> mvn -v
Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)
...
```
	  
Have fun and reach out if you have any issues.
