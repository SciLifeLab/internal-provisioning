# Ansible-Miniconda

Install miniconda and create conda virtual environments with packages installed.

Role Variables
--------------

Example variables for conda environments:
```
miniconda_path: /home/user_name/.miniconda
miniconda_environments:
  - name: virtual_env_name
    python_version: 2.7
    pkgs: 'pip numpy pandas'
  - name: another_virtual_env
    python_version: 3.3
    pkgs: 'pip ipython'
```

Default variables (in vars/main.yml):
* miniconda installer to use: url and installer script name
* miniconda path: defaults to `~/.miniconda`
