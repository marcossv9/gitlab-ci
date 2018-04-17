# Devops-Challenge - GitlabCI

Un despliegue de dos VMs con Vagrant, una de ellas con una app web y la otra con un gitlab local con CI funcional. El proyecto está basado en el repositorio [devops-challenge](https://github.com/marcossv9/devops-challenge/)

## Requisitos de versión de herramientas que usaremos:

1. Version VirtualBox: 5.2-5.2.8_121009
2. Version Vagrant: 2.0.3
3. Version GitlabCI: GitLab Community Edition 10.6.4
4. Version Runner CI: 10.6.0 

## Para poner todo en marcha y ejecutar un pipeline:

1. Instalar VirtualBox & Vagrant (si no están instalado ya)
2. Clonar el repo devops-challenge con ```# git clone https://github.com/marcossv9/gitlab-ci``` y colóquelo en el directorio desde el que desea iniciar la VM.
3. Navegar al directorio de repo local e iniciar las VMs con Vagrant usando el comando ```# vagrant up```
4. Pruebe el sitio web usando un navegador de preferencia y vaya a la siguiente URL desde su máquina Host: [http://192.168.10.10](http://192.168.10.10) 
5. Ingrese a gitlab local accediendo a la URL:
[https://192.168.10.11](https://192.168.10.11) 
6. Completar TODOS los siguientes pasos en el orden indicado:

**Pasos A VM app**

1. Ingresar por ssh con usuario vagrant a la vm usando el comando ```# vagrant ssh app```
2. Generar par de llaves con el comando: 
```# echo -e "\n\n\n" | ssh-keygen -t rsa -N ""```
3. Copiar llave publica de la salida del comando:
```# cat ~/.ssh/id_rsa.pub```

**Pasos A VM gitlab**

1. Ingresar a la consola web de gitlab
2. Cambiar password de root (gitlab18)
3. Loguearse como root
4. Crear grupo (devops-challenge)
5. Crear proyecto (test-ci)
6. Agregar del la llave pública copiada anteriormente de la VM app, al proyecto creado, en la sección SSH Keys de GitLab
7. Ingresar al server gitlab por ssh con usuario vagrant utilizando el comando ```# vagrant ssh gitlab```
8. Registar Runner:
- Ejecutar ```# sudo gitlab-runner register```
- Rellenar los datos en este orden:
- Please enter the gitlab-ci coordinator URL:
  https://gitlab
- Please enter the gitlab-ci token for this runner:
  copiar token desde gitlab web console -> Proyecto -> Settings ->CI/CD -> Runner Settings
- Please enter the gitlab-ci description for this runner:
  [gitlab]: new-runner
- Please enter the gitlab-ci tags for this runner (comma separated):
  Presionar enter
- Whether to lock the Runner to current project [true/false]:
  [true]: 
  Presionar enter
- Please enter the executor: docker, docker-ssh, virtualbox, docker+machine, parallels, shell, ssh, docker-ssh+machine, kubernetes:
  shell

9. setear variable secreta de la manera que se informa en el siguiente link para el usuario vagrant: https://codeburst.io/gitlab-build-and-push-to-a-server-via-ssh-6d27ca1bf7b4

NOTA: Usuario ¨vagrant¨, Password: ¨vagrant¨ | variable secreta: USER_PASS, valor: vagrant

**Pasos B VM app**

1. Ingresar por SSH con el comando ¨vagrant ssh app¨ al server app y ejecutar los siguientes comandos desde el directorio /vagrant:

* ```# git config --global user.name "Administrator"```
* ```# git config --global user.email "admin@example.com"```
* ```# git init```
* ```# git remote add origin git@192.168.10.10:devops-challenge/test-ci.git```
* ```# git add .```
* ```# git commit -m "Initial commit"```
* ```# echo -e "yes\n" | git push -u origin master```
* Ingresar yes para aceptar la llave de ssh

NOTA: Luego de lo anterior se ejecutará un pipeline con lo solicitado en el challenge
