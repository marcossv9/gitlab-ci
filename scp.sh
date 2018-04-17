#!/bin/bash

export SSHPASS=$USER_PASS

sshpass -e scp -vo stricthostkeychecking=no -r /tmp/playbook.tar vagrant@192.168.10.11:/tmp