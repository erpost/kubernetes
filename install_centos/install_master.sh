#!/usr/bin/env bash

# turn off swapfile
echo "############Turning of Swap File############"
sudo swapoff -a
sudo cp -p /etc/fstab /etc/fstab.bak
sudo sed -i 's/\/root\/swap/#\/root\/swap/' /etc/fstab

# update and install docker
echo "############Updating and Installing Docker############"
sudo yum -y update
sudo yum -y install docker
sudo systemctl start docker
sudo systemctl enable docker

# add the kubernetes repo
echo "############Adding Kubernetes Repo############"
sudo bash -c 'cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF'

# modify selinux
echo "############Disabling SELinux############"
sudo setenforce 0
sudo cp -p /etc/selinux/config /etc/selinux/config.bak
sudo cp -p /etc/sysconfig/selinux /etc/sysconfig/selinux.bak
sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# configure iptables
echo "############Configuring IPTables############"
sudo bash -c 'cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF'

# install kubernetes
echo "############Installing Kubernetes############"
sudo yum -y install kubelet kubeadm kubectl

# initialize network
echo "############Initialize Network############"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# start kubelet
echo "############Enable and Start Kubelet############"
sudo systemctl start kubelet
sudo systemctl enable kubelet

# set up directories and configurations
echo "############Setting up Directories and Configurations############"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# configuring flannel
echo "############Configuring Flannel############"
kubectl apply -f https://raw.githubusercontent.com/erpost/kubernetes/master/kube-flannel-master.yml
