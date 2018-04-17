#!/bin/bash

export SSHPASS=$USER_PASS # Importar password cargada en Gitlab como secret variable

sshpass -e ssh -o stricthostkeychecking=no vagrant@192.168.10.11 'tar -xf /tmp/playbook.tar -C /tmp/ | ansible-playbook /tmp/vagrant/playbook.yml' # Descomprimr en la VM de la app el archivo playbook.tar en /tmp y ejecutar ansible-playbook del archivo descomprimido. Todo por SSH