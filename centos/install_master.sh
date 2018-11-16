#!/usr/bin/env bash

############ run as root user ############

# turn of swapfile
swapoff -a
cp -p /etc/fstab /etc/fstab.bak
sed -i 's/\/root\/swap/#\/root\/swap/' /etc/fstab

# update and install docker
sudo yum -y update
yum -y install docker
systemctl start docker
systemctl enable docker

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

# modify selinux
setenforce 0
cp -p /etc/selinux/config /etc/selinux/config.bak
cp -p /etc/sysconfig/selinux /etc/sysconfig/selinux.bak
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=permissive/' /etc/sysconfig/selinux

# install and enable kubernetes
yum -y install kubelet kubeadm kubectl
systemctl start kubelet
systemctl enable kubelet

# configure iptables
sudo bash -c 'cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF'

# initialize kubeadm with flannel
kubeadm init --pod-network-cidr=10.244.0.0/16

############ run as standard user ############

# exit to standard user and set up directories and configurations
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

