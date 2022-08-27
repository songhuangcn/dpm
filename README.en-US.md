[简体中文](README.md) | [English](README.en-US.md)

# DPM

Docker Package Manager, makes using your Docker as easy as package managers (`apt`, `yum`, `brew`).

## Installation

Dependency:
- Docker
- Ruby >= 2.6

Install command:
```bash
gem install dpmrb
```

## Usage

```bash
dpm pacakges                   # List all supported packages
dpm start mysql                # Start the package `mysql` by the config `packages/mysql.yml`
dpm stop mysql                 # Stop the package `mysql`
dpm status mysql               # Show the status of the package `mysql`
dpm help                       # Get help to show all the features
```

## Package Config

DPM supports two types of package configs:
1. The "System Package Config" in the directory `packages/` of repo
2. The "User Package Config" in the directory `~/.dpm/packages/` of user

### System Package Config

The goal of "System Package Config" is to make a Docker service run the same as the natively installed one. Take MySQL as an example:
- After the native MySQL is installed and run, it will bind port 3306 by default, so our MySQL package configuration should also expose the service port to the host by default
- After the native MySQL is installed, there are fixed configuration directories and log directories, so our MySQL package configuration must also map these directories in the container to fixed directories

### User Package Config

"User Package Config" has the following usage scenarios:
1. If the default package configuration of DPM is unreasonable and you want to change it, you can use "User Package Config" to debug and view the results, and then submit MR to the repo.
2. DPM does not provide the package you need, you need to add your own package configuration. (Contributions of your new package configuration to DPM are welcome).
3. DPM default package configuration is not suitable for local environment, need to override "System Package Config". For example, if I need to run two MySQL services locally, then I need to change the port of one of the services to the other to avoid conflicts.

#### Add User Package Config

"User Package Config" provides the following commands for quick creation:
```bash
dpm configure PACKAGE
```

The function of this command is to add a new package configuration file `PACKAGE.yml` under the user directory `~/.dpm/`.
If the package already exists in the "system package configuration", the contents will be initialized into this file.

**Note:** If the PACKAGE parameter is `package`, the "Global Package Config" `config/package.yml` is configured, and the configuration here will be merged into all packages.

## Related Tools

- [Visual Studio Code Plugin](https://marketplace.visualstudio.com/items?itemName=UoooBarry.dpm-vscode)

## Development

### Setup environment

```bash
git clone git@github.com:songhuangcn/dpm.git
cd dpm
bin/setup # Need Ruby >= 2.6
```

### Development Skills

- Adding ENV `DEBUG` to all commands will show detailed error stack to help locate the problem
- After development, use the command `bin/check` to check code specifications and tests, and resolve some CI failures in advance
