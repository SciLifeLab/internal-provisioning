#Ansible playbooks

This reposiory contains playbooks to deploy the infrastructure at National Genomics
Infrastructure. 

Please refer to [ansible documentation](http://docs.ansible.com/) for more details
about Ansible concepts and how it works.

Also, take a look at the ansible [best practices](http://docs.ansible.com/playbooks_best_practices.html).

The repository is structured following this structure
```
production                # inventory file for production servers
stage                     # inventory file for stage environment

group_vars/
   group1                 # here we assign variables to particular groups
   group2                 # ""
host_vars/
   hostname1              # if systems need specific variables, put them here
   hostname2              # ""

site.yml                  # master playbook
webservers.yml            # playbook for webserver tier
dbservers.yml             # playbook for dbserver tier

roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
        meta/             #
            main.yml      #  <-- role dependencies

    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/               # ""
```

In order to deploy any of the playbooks, clone this repository to a machine that
has `ssh` connection to all the servers you want to deploy. Usually your local machine
should be enough.

__NOTE__: The following assume you have ansible installed in your machine, if not:

```bash
$> sudo pip install ansible
```

### Create a testing environment
You don't want to mess around the production servers until you are sure that everything
works, don't you? Okay that's easy to solve: just create a virtual mini-cluster
using vagrant and configure it [like this](http://hakunin.com/six-ansible-practices#build-a-convenient-local-playground)

## Deploying a new NAS
In order to deploy a new NAS, you just need to execute the `nas` playbook. Some 
*important* considerations before doing that are:

* You need to be able to paswordless ssh into the NAS
* You need permission to `sudo` to the production user, i.e `hiseq.bioinfo`

Once this is clear:

```bash
$> ansible-playbook nas.yml -u <your_username> -i production
```

This playbook will:

1. Install `miniconda` and create a virtual environment called `master` with all needed dependencies
2. Create `config` directory and put there all configuration files
3. Create `log` directory
4. Install several repositories from `/srv/mfs/opt/`
5. Configure cronjobs
6. Start `supervisord`, which will start all necessary services