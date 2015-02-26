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
            common.yml        # Common role variable file
        webservers            # here we assign variables to webservers groups
            nginx.yml         # Each file will corspond to a role i.e. nginx
        postgresql            # here we assign variables to postgresql groups
            postgresql.yml    # Each file will corspond to a role i.e. postgresql
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



#License
MIT License.



