# -*- mode: ruby -*-
# vi: set ft=ruby :

$k8scp = <<SCRIPT 

kubeadm init --apiserver-advertise-address=192.168.1.131 --pod-network-cidr 10.244.0.0/16 --token abcdef.0123456789abcdef

echo "* Save the hash to a file ..."
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //' > /vagrant/hash.txt

echo "* Copy configuration for root ..."
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown -R root:root /root/.kube

echo "* Copy configuration for vagrant ..."
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Pod Network plugin - comment/uncomment one of the following blocks
# Currently set to Flannel

# echo "* Install Pod Network plugin (Flannel) ..."
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# wget -q https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -O /tmp/kube-flannel.yaml
# sed -i '/--kube-subnet-mgr/ a CHANGEME' /tmp/kube-flannel.yaml
# sed -i "s/CHANGEME/        - --iface=$(ip a | grep 192.168.99.101 | tr -s ' ' | cut -d ' ' -f 8)/" /tmp/kube-flannel.yaml 
# kubectl apply -f /tmp/kube-flannel.yaml

# echo "* Install Pod Network plugin (Calico) ..."
# kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
# wget -q https://docs.projectcalico.org/manifests/custom-resources.yaml -O /tmp/custom-resources.yaml
# sed -i 's/192.168.0.0/10.244.0.0/g' /tmp/custom-resources.yaml
# kubectl create -f /tmp/custom-resources.yaml

SCRIPT

$k8swk = <<SCRIPT

echo "* Join the worker node ..."
kubeadm join 192.168.1.131:6443 --token abcdef.0123456789abcdef --discovery-token-ca-cert-hash sha256:`cat /vagrant/hash.txt`

SCRIPT

$common = <<SCRIPT

echo "* Add hosts ..."
echo "192.168.1.131 node1.k8s node1" >> /etc/hosts
echo "192.168.1.132 node2.k8s node2" >> /etc/hosts
echo "192.168.1.133 node3.k8s node3" >> /etc/hosts

SCRIPT

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
    node1.vm.synced_folder "vagrant/", "/vagrant"
    node1.vm.provision "shell", inline: $common
    node1.vm.provision "shell", inline: $k8scp
  end

  config.vm.define "node2" do |node2|
    node2.vm.box = "merev/debian-k8s-node"
    #node2.vm.box_version = "1.1"
    node2.vm.hostname = "node2.k8s"
    node2.vm.network "public_network", ip: "192.168.1.132"
    node2.vm.synced_folder "vagrant/", "/vagrant"
    node2.vm.provision "shell", inline: $common
    node2.vm.provision "shell", inline: $k8swk
  end

  config.vm.define "node3" do |node3|
    node3.vm.box = "merev/debian-k8s-node"
    #node3.vm.box_version = "1.1"
    node3.vm.hostname = "node3.k8s"
    node3.vm.network "public_network", ip: "192.168.1.133"
    node3.vm.synced_folder "vagrant/", "/vagrant"
    node3.vm.provision "shell", inline: $common
    node3.vm.provision "shell", inline: $k8swk
  end
end
