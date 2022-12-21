# Kubernetes Cluster v1.25.x
#### Requirements:

 - VirtualBox 6.1+:  https://www.virtualbox.org/wiki/Downloads 
 - Vagrant 2.1+:  https://developer.hashicorp.com/vagrant/downloads

This is an automated solution for K8S cluster (v1.25.x) created through `kubeadm` and Vagrant. Follow the steps below:
 - clone the repository; 
 - open the directory in terminal;
 - execute the command `vagrant up`;
 - wait until the cluster is ready (up to 10 mins).

## Cluster Details
The architecture of the cluster looks like:
![general setup](cluster-architecture.png)

Every node in the cluster is based on the same Vagrant box (*merev/debian-k8s-node*). You can find detailed information about the box here - https://app.vagrantup.com/merev/boxes/debian-k8s-node.
### Nodes Specification
The operating system installed on the nodes is Debian 11. Each node has 2 GB RAM, 2 CPUs, and 60 GB disk space. The hardware parameters can be adjusted before provisioning in the `config.vm.provider` block of the Vagrantfile. Every node has 2 network interfaces:
 - 1 NIC in NAT Mode - connected to the host machine;
 - 1 NIC in Bridge Mode - connected to the local network.

#### Warning: The second NIC (Bridge mode) of the nodes has a static IP address that belongs to my local network. Don't forget to replace the IPs of these interfaces with the ones that belong to your network (in the initial configuration scripts and Vagrantfile).
Information about the installed software can be found in the box specification.

### Initial Configuration
The initial configuration of the cluster contains the following actions:
 - Control Plane Initialization;
 - Network Plugin Installation; 
 - Adding the Worker Nodes.

The additional configuration contains (not applied by default):
 - Running the K8s Dashboard;
 - Deploying 2-coponents test application (consumer-producer app).

You can have the additional configuration applied by uncommenting rows 41 and 42 in the Vagrantfile.
