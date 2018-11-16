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

# add repo key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# add sources
cat << EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

# update packages
apt update

# install packages
apt install -y kubelet kubeadm

# add node to master
kubeadm join ...
