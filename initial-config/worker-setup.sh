#!/bin/bash

echo "* Join the worker node ..."
kubeadm join 192.168.1.131:6443 --token abcdef.0123456789abcdef --discovery-token-ca-cert-hash sha256:`cat /shared/.data/hash.txt`

echo "* Copy configuration for root ..."
mkdir -p /root/.kube
cp -i /shared/.data/admin-config.yaml /root/.kube/config
chown -R root:root /root/.kube

echo "* Copy configuration for vagrant ..."
mkdir -p /home/vagrant/.kube
cp -i /shared/.data/admin-config.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube