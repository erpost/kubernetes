#!/bin/bash

# 1.1.1
# Ensure that the --anonymous-auth argument is set to false
echo "############ 1.1.1 ############"
grep anonymous-auth=true /etc/kubernetes/manifests/kube-apiserver.yaml

# 1.1.2
# Ensure that the --basic-auth-file argument is not set
echo "############ 1.1.2 ############"
grep basic-auth-file /etc/kubernetes/manifests/kube-apiserver.yaml

# 1.1.3
# Ensure that the --insecure-allow-any-token argument is not set
echo "############ 1.1.3 ############"
grep insecure-allow-any-token /etc/kubernetes/manifests/kube-apiserver.yaml

# 1.1.4
# Ensure that the --kubelet-https argument is set to true
echo "############ 1.1.4 ############"
grep kubelet-https /etc/kubernetes/manifests/kube-apiserver.yaml

# 1.1.5
# Ensure that the --insecure-bind-address argument is not set
echo "############ 1.1.5 ############"
grep insecure-bind-address /etc/kubernetes/manifests/kube-apiserver.yaml

# 1.1.6
# Ensure that the --insecure-port argument is set to 0
echo "############ 1.1.6 ############"
grep insecure-port /etc/kubernetes/manifests/kube-apiserver.yaml

# 1.1.7
# Ensure that the --secure-port argument is not set to 0
echo "############ 1.1.7 ############"
grep \-secure-port /etc/kubernetes/manifests/kube-apiserver.yaml

