#!/bin/bash
#
# Instead of executing the following script you, you can use the following Vagrant Box:
# https://app.vagrantup.com/merev/boxes/k8s-node
#
#
######################################################################
########################### BASIC SETTINGS ###########################
######################################################################

echo "* Check if the br_netfilter module is loaded ..."
lsmod | grep br_netfilter

echo "* If not, try to load it ..."
modprobe br_netfilter

echo "* Then prepare a configuration file to load it on boot ..."
echo "br_netfilter" | tee /etc/modules-load.d/k8s.conf

echo "* Adjust a few more network-related settings ..."
echo "net.bridge.bridge-nf-call-ip6tables = 1" | tee /etc/sysctl.d/k8s.conf
echo "net.bridge.bridge-nf-call-iptables = 1" | tee /etc/sysctl.d/k8s.conf
echo "net.ipv4.ip_forward = 1" | tee /etc/sysctl.d/k8s.conf

echo "* And then apply them ..."
sysctl --system

echo "* Install iptables ..."
apt-get update -y && apt-get install -y iptables

echo "* Check which variant of iptables is in use ..."
update-alternatives --query iptables

echo "* And switch it to the legacy version ..."
update-alternatives --set iptables /usr/sbin/iptables-legacy

echo "* As a final general step, turn off the SWAP both for the session and in general ..."
swapoff -a
sed -i '/swap/ s/^/#/' /etc/fstab

################################################################################
########################### CONTAINER RUNTIME CONFIG ###########################
################################################################################

echo "* Update the repositories information and install the required packages ..."
apt-get update -y && apt-get install -y ca-certificates curl gnupg lsb-release

echo "* Download and install the key ..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "* Add the repository ..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > dev/null

echo "* Install the required packages ..."
apt-get update -y && apt-get install -y docker-ce docker-ce-cli containerd.io

## The following steps should be performed if you are going to install а cluster with version greater than 1.23.x (1.24.x +)
#
# echo "* Make a copy of the container runtime config ..."
# cp /etc/containerd/config.toml /etc/containerd/config.toml.bak
#
# echo "* Generate and store the default configuration ..."
# containerd config default > /etc/containerd/config.toml
#
# echo "* Adjust the configuration file ..."
# sed -i '125s/false/true/' /etc/containerd/config.toml
#
# echo "* Restart the service ..."
# systemctl restart containerd

## The following steps are not needed under Debian 11 as these are the default setting for the Docker software
## Create the configuration folder if does not exist:
## echo "* mkdir /etc/docker ..."
##
## Then create the configuration file with the following location and name /etc/docker/daemon.json containing the following:
##
## {
##  "exec-opts": ["native.cgroupdriver=systemd"],
##  "log-driver": "json-file",
##  "log-opts": {
##   "max-size": "100m"
##  },
##  "storage-driver": "overlay2"
## }

echo "* Reload and restart the service ..."
systemctl enable docker
systemctl daemon-reload
systemctl restart docker

#############################################################################
########################### KUBERNETES COMPONENTS ###########################
#############################################################################

# We will refer to this source: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl

echo "* Install any packages that may be missing ..."
apt-get update -y && apt-get install -y apt-transport-https ca-certificates curl

echo "* Download and install the key ..."
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "* Add the repository ..."
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

echo "* Update repositories information ..."
apt-get update -y

echo "* Check available versions of the packages ..."
apt-cache madison kubelet

# echo "* If we want to install the latest version, we may use the following command ..."
# apt-get install -y kubelet kubeadm kubectl

echo "* Install particular version ..."
apt-get install -y kubelet=1.23.3-00 kubeadm=1.23.3-00 kubectl=1.23.3-00

echo "* Exclude the packages from being updated ..."
apt-mark hold kubelet kubeadm kubectl