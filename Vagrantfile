# -*- mode: ruby -*-
# vi: set ft=ruby :

#Configurar VM para App
Vagrant.configure("2") do |config|

  config.vm.define "app" do |app| # Definir valores de VM
    app.vm.hostname = "app" # Nombre de la VM
    app.vm.box = "ubuntu/trusty64" # Usar template para Ubuntu 14.04 descargado del catálogo de Vagrant
    app.vm.box_version = "20180404.0.0" # Version del template de Ubuntu
    app.vm.network "private_network", ip: "192.168.10.11" # Setear IP privada
    #app.vm.network :forwarded_port, guest: 80, host: 8080 ## Port Forwarding desde la VM (80) al localhost (8080)
    app.vm.provision "shell", inline: <<-SHELL # Instalar pip y usar comandos integrados de shell contra la VM
      echo -e "\n\n\n" | ssh-keygen -t rsa -N "" # Generar par de keys para SSH sin interacción
      cat ~/.ssh/id_rsa.pub # Key SSH para usar con repo local GitLab
      sudo apt-get -y install python-pip
      sudo pip install --ignore-installed six
      sudo apt-get update -qq && apt-get install -y -qq sshpass
    SHELL
    app.vm.provision "ansible_local" do |ansible| # Usar Ansible como un aprovisionador local
        ansible.playbook = "playbook.yml" # Ruta al Ansible-playbook para instalar Docker
        #ansible.install_mode = "pip" # Opcional: instalar Ansible en la VM usando pip
        #ansible.version = "2.5.0"  # Opcional: elegir version específica de Ansible a instalar
    # added rsync__auto  to enable detect changes on host and sync to guest machine and exclude .git/
    app.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"#, rsync__auto: true
    end
  end

# Configurar VM para GitLab
# read configurable cpu/memory/port/swap/host/edition settings from environment variables
memory = ENV['GITLAB_MEMORY'] || 3072
cpus = ENV['GITLAB_CPUS'] || 2
port = ENV['GITLAB_PORT'] || 8443
swap = ENV['GITLAB_SWAP'] || 0
host = ENV['GITLAB_HOST'] || "gitlab"
edition = ENV['GITLAB_EDITION'] || "community"

  config.vm.define :gitlab do |gitlab|
    # Configure some hostname here
    gitlab.vm.hostname = "gitlab"
    gitlab.vm.box = "bento/ubuntu-16.04" 	# bento/ubuntu-16.04 provides boxes for virtualbox.
    gitlab.vm.network "private_network", ip: "192.168.10.10" # Setear IP privada
    gitlab.vm.provision :shell, :path => "install-gitlab.sh",
      env: { "GITLAB_SWAP" => swap, "GITLAB_HOSTNAME" => host, "GITLAB_PORT" => port, "GITLAB_EDITION" => edition }
    # On Linux, we cannot forward ports <1024
    # We need to use higher ports, and have port forward or nginx proxy
    # or access the site via hostname:<port>, in this case 127.0.0.1:8080
    # By default, Gitlab is at https + port 8443
    gitlab.vm.network :forwarded_port, guest: 443, host: port

    # use rsync for synced folder to avoid the need for provider tools
	# added rsync__auto  to enable detect changes on host and sync to guest machine and exclude .git/
  #  gitlab.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/", rsync__auto: true
    gitlab.vm.provision "shell", inline: <<-SHELL # Instalar RUNNER en la VM de GitLab para ejecutar los pipeline
      sudo apt-get -y update
      sudo wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
      sudo chmod +x /usr/local/bin/gitlab-runner
      sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
      sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
      sudo gitlab-runner start
      sudo apt-get update -qq && apt-get install -y -qq sshpass
    SHELL
  # GitLab recommended specs
    gitlab.vm.provider "virtualbox" do |v|
      v.cpus = cpus
      v.memory = memory
    end
  end
end