#!/bin/bash

export SSHPASS=$USER_PASS # Importar password cargada en Gitlab como secret variable

sshpass -e scp -vo stricthostkeychecking=no -r /tmp/playbook.tar vagrant@192.168.10.11:/tmp # Copiar por SCP desde Gitlab a VM con app el playbook comprimido en el directorio tar