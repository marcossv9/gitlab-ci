#!/bin/bash

export SSHPASS=$USER_PASS

sshpass -e ssh -o stricthostkeychecking=no vagrant@192.168.10.11 'tar -xf /tmp/playbook.tar -C /tmp/ | ansible-playbook /tmp/vagrant/playbook.yml'