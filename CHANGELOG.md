# Changelog

## [1.0.1] 2021-06-17

### Added

- N/A

### Changed

- N/A

### Fixed

- Template directory added because is used by custom data script

## [1.0.0] 2021-06-17

### Added

- Optional bastion host 
- Number of instances to create
- Network interface (nic)
- Linux virtual machine:

	* Ready to use service principal
	* Remote backend configuration for terraform tfstates into azure storate account
	* Parameterized admin username
	* Password authentication enabled
	* Password passed by variable
        * Possibility to choose between custom image or image offered by Azure to create virtual machines
	* Parameterized disks:
		- OS disk
		- Data disk (optional)
	* Boot diagnostic to storage account
	* Empty custom data
	* Extensions (possibility of enable or disable installation. Default: true):
		- OmsAgentForLinux (ship logs to azure logs analytics)
		- DependencyAgentLinux
	* Parameterized auto-shutdown (optional)
	* Alerts (optional disabling for each. Default: all alerts enabled):
		- CPU > 90%
		- IOPS > 90%
		- VM is restarted
		- VM is stopped
		- VM disk occupied 
	* Action group creation optional. It is contemplated to specify an existing one
	* VM backup from existing of the recovery services vault (optional)
        * VM Insights enabled (optional)
        * Public IP (optional)
        * IAM custom role assignment (optional):
		- Option to specify a list of email users
		- Option to specify a list of object id attribute of users

### Changed

- N/A

### Fixed

- N/A

