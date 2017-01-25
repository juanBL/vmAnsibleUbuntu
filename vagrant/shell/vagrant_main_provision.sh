#!/usr/bin/env bash

if ! ansible --version | grep ansible;
then
    echo "-> Installing Ansible"
    # Add Ansible Repository & Install Ansible
    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get -y install ansible
else
        echo "-> Ansible already Installed!"
fi

# Install Ansible Galaxy modules
# To review in furure: http://docs.ansible.com/ansible/galaxy.html#id12
echo "-> Installing Ansibe Galaxy Modules"
roles_list[0]='geerlingguy.mysql'
roles_list[1]='geerlingguy.memcached,1.0.7'
roles_list[2]='geerlingguy.ntp,1.4.0'

for role_and_version in "${roles_list[@]}"
do
    role_and_version_for_grep="${role_and_version/,/, }"

    if ! sudo ansible-galaxy list | grep -qw "$role_and_version_for_grep";
    then
            echo "Installing ${role_and_version}"
            sudo ansible-galaxy -f install $role_and_version
    else
        echo "Already installed ${role_and_version}"
    fi
done

# Execute Ansible
echo "-> Execute Ansible"
ansible-playbook /ansible/playbook_development.yml -i /ansible/inventories/development --connection=local
