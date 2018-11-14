#!/bin/bash

# sudo to root
sudo su -

# install Docker
apt-get install -y docker.io

# set cgroup driver
cat << EOF >> /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

# add repo key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# add sources
cat << EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

# update packages
apt-get update

# install packages
apt-get install -y kubelet kubeadm kubectl

# initialize kubeadm with flannel
kubeadm init --pod-network-cidr=10.244.0.0/16

# exit to standard user and set up directories and configurations
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# download flannel configuration file
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
