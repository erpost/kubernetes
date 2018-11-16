#!/bin/bash

# modify selinux
sudo cp -p /etc/sysconfig/selinux /etc/sysconfig/selinux.bak
sudo cp -p /etc/selinux/config /etc/selinux/config.bak
sudo setenforce 0
sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/sysconfig/selinux
sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# disable swapfile
sudo swapoff -a
cp -p /etc/fstab /etc/fstab.bak
sed -i 's/\/root\/swap/#\/root\/swap/' /etc/fstab

# add kubernetes repo
sudo bash -c 'cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF'

# update and install packages
sudo yum -y update
sudo yum -y install kubeadm kubelet kubectl docker

# enable services
sudo systemctl enable docker
sudo systemctl enable kubelet

# configure iptables
sudo bash -c 'cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF'

# configure kubeadm
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# run as standard user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config