# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    
  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.define "node1" do |node1|
    node1.vm.box = "merev/debian-k8s-node"
    #node1.vm.box_version = "1.1"
    node1.vm.hostname = "node1.k8s"
    node1.vm.network "public_network", ip: "192.168.1.131"
    node1.vm.synced_folder "shared/", "/shared"
    node1.vm.provision "shell", path: "initial-config/add-hosts.sh"
    node1.vm.provision "shell", path: "initial-config/control-plane-setup.sh"
  end

  config.vm.define "node2" do |node2|
    node2.vm.box = "merev/debian-k8s-node"
    #node2.vm.box_version = "1.1"
    node2.vm.hostname = "node2.k8s"
    node2.vm.network "public_network", ip: "192.168.1.132"
    node2.vm.synced_folder "shared/", "/shared"
    node2.vm.provision "shell", path: "initial-config/add-hosts.sh"
    node2.vm.provision "shell", path: "initial-config/worker-setup.sh"
  end

  config.vm.define "node3" do |node3|
    node3.vm.box = "merev/debian-k8s-node"
    #node3.vm.box_version = "1.1"
    node3.vm.hostname = "node3.k8s"
    node3.vm.network "public_network", ip: "192.168.1.133"
    node3.vm.synced_folder "shared/", "/shared"
    node3.vm.provision "shell", path: "initial-config/add-hosts.sh"
    node3.vm.provision "shell", path: "initial-config/worker-setup.sh"
    node3.vm.provision "shell", path: "additional-config/dashboard-run.sh"
    node3.vm.provision "shell", path: "additional-config/consumer-producer-deploy.sh"
  end
end
