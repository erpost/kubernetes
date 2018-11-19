#!/bin/bash

############ run as root user ############

# install Docker
apt install -y docker.io

# set cgroup driver
cat << EOF >> /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

# add kubernetes repo key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# add sources
cat << EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

# update packages
apt update

# install packages
apt install -y kubelet kubeadm kubectl

# initialize kubeadm with flannel
kubeadm init --pod-network-cidr=10.244.0.0/16

############ run as standard user ############

# exit to standard user and set up directories and configurations
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# download flannel configuration file for networking
kubectl apply -f https://raw.githubusercontent.com/erpost/kubernetes/master/kube-flannel-master.yml