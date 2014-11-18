#Ansible playbooks

This reposiory contains playbooks to deploy the infrastructure at National Genomics
Infrastructure. 

Please refer to [ansible documentation](http://docs.ansible.com/) for more details
about Ansible concepts and how it works.

In order to deploy any of the playbooks, clone this repository to a machine that
has `ssh` connection to all the servers you want to deploy. Usually your local machine
should be enough.

__NOTE__: The following assume you have ansible installed in your machine, if not:

```bash
$> sudo pip install ansible
```

## Deploying a new NAS
In order to deploy a new NAS, you just need to execute the `nas` playbook. Some 
*important* considerations before doing that are:

* You need to be able to paswordless ssh into the NAS
* You need permission to `sudo` to the production user, i.e `hiseq.bioinfo`

Once this is clear:

```bash
$> ansible-playbook ansible/playbooks/nas/tasks/nas.yaml -u <your_username> -i ansible/inventory.yaml
```

This playbook will:

1. Install `miniconda` and create a virtual environment called `master` with all needed dependencies