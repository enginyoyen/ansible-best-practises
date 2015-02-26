##Ansible Best Practises
Problem that is being addressed is to complexity of the ansible projects, soon as the project starts grow. Organization of the code in this repository shows how it is possible solve following issues:

* How to manage external roles
* Usage of variables
* Naming 
* Staging
* Complexity of plays




##Directory Layout

    production.ini            # inventory file for production stage
    development.ini           # inventory file for development stage
    test.ini                  # inventory file for test stage
    group_vars/
        all                   # variables under this directory belongs all the groups
            apt.yml           # ansible-apt role variable file for all groups
        webservers            # here we assign variables to webservers groups
            apt.yml           # Each file will correspond to a role i.e. apt.yml
            nginx.yml         # ""
        postgresql            # here we assign variables to postgresql groups
            postgresql.yml    # Each file will correspond to a role i.e. postgresql
    plays
        ansible.cfg           # Ansible.cfg file that holds all ansible config
        webservers.yml        # playbook for webserver tier
        postgresql.yml        # playbook for postgresql tier

    roles/
        requirements.yml      # All the infromation about the roles
        external              # All the roles that are in git or ansible galaxy
                              # This directory is in ignored by git and all the roles in the 
                              # requirements.yml will be downloaded into this directory
        internal              # All the roles that are not public 



##TL;DR
* Do not keep external roles in your repository, use ansible-galaxy
* Do not use pre_task, task or post_tasks in your play, use roles to reuse the code
* Keep all your variables in one place, if possible
* Do not use variables in your play
* Use variables in the roles instead of hardcoding
* Keep the names consistent between groups, plays, variables, and roles
* Different environments(development,test,production) must be close as possible, if not equal
* Use tags in your play



##1. How to Manage Roles
It is a bad habit to keep the copy of roles, that are developed by other developers, in your git repository. Therefore, you can use ansible-galaxy for installing the roles you need, at the location you need, by simply defining them in the requirements.yml:

```
---
- src: ANXS.build-essential
  version: "v1.0.1"
  path : external
```

Roles can be downloaded with this command:

```
ansible-galaxy install -r requirements.yml
```


##2. Keep your plays simple
If you want to take the advantage of the roles, you have to keep your plays simple. 
Therefore do not add any tasks in your main play. Your play should only consist of the list of roles that it depends on. Here is an example:

```
---

- name: postgresql.yml | All roles
  hosts: postgresql
  sudo: True

  roles:
    - { role: common,                   tags: ["common"] }
    - { role: ANXS.postgresql,          tags: ["postgresql"] }
```

As you can see there are also no variables in this play, you can use variables in many different ways in ansible, and to keep it simple and easier to maintain do not use variables in plays. Furthermore, use tags, they give wonderful control over role execution.


##3. Stages
Most likely you will need different stages(e.g. test, development, production) for the product you are either developing or helping to develop. A good way to manage different stages is to have multiple inventory files. As you can see in this repository, there are three inventory files. Each stage you have must be identical as possible, that also means, you should try to use few as possible host variables. It is best to not use at all.


##4. Variables
Variables are wonderful, that allows you to use all this existing code by just setting some values. Ansible offers many different ways to use variables. However, soon as your project starts to get bigger, and more you spread variables here and there, more problems you will encounter. Therefore it is good practice to keep all your variables in one place, and this place happen to be group_vars. They are not host dependent, so it will help you to have a better staging environment as well. Furthermore, if you have internal roles that you have developed, keep the variables out of them as well, so you can reuse them easily.



##5. Name consistency
If you want to maintain your code, keep the name consistency between, play and inventories, roles and group variables. Use the name of the roles to separate different variables in each group. If you have a role called nginx keep the variables under your group_vars/webservers/nginx.yml group_vars support directory and every file inside the group will be loaded



#TODO
* ansible-vault example

#License
MIT License.



