# Maven-snapshot choco package

This package installs the latest built snapshot Maven distribution from the Apache Jenkins on the master branch. 
	
*Take care that these builds can be unstable!*
	
## Switching between existing Maven and Snapshot
This package will be installed next to an existing Maven installation. By uninstalling this package you will switch back to that Maven installation.

## Example

```
> mvn -v
Apache Maven 3.8.4 (9b656c72d54e5bacbed989b64718c159fe39b537)
...
> choco install maven-snapshot -y
> refreshenv
> mvn -v
Apache Maven 4.0.0-alpha-1-SNAPSHOT (bb916d0784c7631866167928e4d0615df3317567)
...
> choco uninstall maven-snapshot -y
> refreshenv
> mvn -v
Apache Maven 3.8.4 (9b656c72d54e5bacbed989b64718c159fe39b537)
...
```
	  
Have fun and reach out if you have any issues.
