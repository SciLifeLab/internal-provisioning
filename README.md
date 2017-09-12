# Ansible playbooks

This repository contains playbooks to deploy the preprocessing and NAS infrastructure at National Genomics
Infrastructure.

Please refer to [ansible documentation](http://docs.ansible.com/) for more details
about Ansible concepts and how it works.

The repository is structured following this structure
```
production                # inventory file for production servers
stage                     # inventory file for stage environment

group_vars/
   all                    # here we assign variables shared between all systems

processing.yml            # playbook for preprocessing servers
nas.yml                   # playbook for nas'es

roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- Main file for any given role
        templates/        #  <-- Any configs or scripts that uses variables set in the recipe
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #  <-- Any configs or scripts that require no modifications by the recipe
        vars/             #
            main.yml      #  <-- Variables uniquely associated with this role
```

In order to deploy any of the playbooks, clone this repository to a machine that
is able to `ssh` to the servers you want to deploy. Usually your local machine has enough access rights.

__NOTE__: Install ansible on your machine via:

```bash
$> sudo pip install ansible
```

### Create a testing environment
You don't want to mess around the production servers until you are sure that everything
works, don't you? Okay that's easy to solve. Either deploy on the staging server, or (if none are available) create a virtual mini-cluster
using vagrant and configure it [like this](http://hakunin.com/six-ansible-practices#build-a-convenient-local-playground)

# Ansible and 2-factor authentication
In order to run a playbook on a server with 2-factor authentication enabled you have 2 options:

1. Clone this repository onto the server and run the playbook locally
using `--connection=local`

2. _Slightly more complicated_: Tunnel the connection through an already opened
connection using [ControlMaster](http://www.anchor.com.au/blog/2010/02/ssh-controlmaster-the-good-the-bad-the-ugly/)
ssh option:

    * Create or edit your `~/.ssh/config` file and add the following to create a master connection
    per server:

    ```
    Host *
    ControlMaster auto
    ControlPath ~/.ssh/cm_socket/%r@%h:%p
    ```

    * Create or edit your `~/.ansible.cfg` configuration file to use that `ControlMaster` connection:

    ```
    [ssh_connection]
    ssh_args = -o ControlMaster=auto -o ControlPath=<your_home_directory>/.ssh/cm_socket/%r@%h:%p
    ```

    * Open a regular connection to the server, like `ssh user@server`, enter the vault token and your password.
    **Keep the connection opened.**

    * On a separate terminal, run the playbook as usual.


## Deploying a new preprocessing server

To deploy a new preprocessing server, execute the `processing` playbook. The requirements for deploying are:

* You need to be able to ssh passwordless into the NAS
* You need permission to `sudo` to the relevant production user account 

If requirements are met, simply use:
```bash
$> ansible-playbook processing.yml -u <your_username> -i <staging_servers | production_servers> --ask-vault-pass
```

## Deploying a new NAS
Currently the playbooks for deploying NASes are **under development**.
That means it's up to **you** to make sure that everything looks good **before** you replace the production cluster.

In order to deploy a new NAS, execute the `nas` playbook.
Same requirement as for deploying a preprocessing server apply.
Additionally the NASes use 2-factor authentication. So have fun with that.

In theory the same command as for deploying preprocessing servers should apply.

```bash
$> ansible-playbook nas.yml -u <your_username> -i <staging_servers | production_servers> --ask-vault-pass
```

## Roles rundown:

In short the roles provide the following features:

### Common

Creates a ssh key. 
Creates the directories config, log and .taca.
Sets a custom bash_profile file.
"Installs" and starts supervisord

### Processing

Creates sequencing archive directories.
Copies processing unique supervisord configuration
Starts cronjobs, which at the time of writing only concerns TACA

### Nas

Creates the .irods and nosync directories.
Creates configurations for logrotate, lsyncd, supervisord, taca and irodsEnv
Starts cronjobs, which at the time of writing concern `taca storage` and `logrotate`.

### Miniconda, bcl2fastq, taca, longranger, etc.

Downloads and installs the mentioned software.
Additionally the miniconda role creates the `master` venv if it does not already exist.



