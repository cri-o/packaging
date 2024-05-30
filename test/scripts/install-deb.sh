#!/usr/bin/env bash

set -euxo pipefail

# This script installs the required deb packages to bootstrap a Kubernetes cluster
# It is referenced from ../deb/Vagrantfile

# Package configs
KUBERNETES_VERSION=v1.30
PROJECT_PATH=prerelease:/main

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:/"$PROJECT_PATH":/build/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:/$PROJECT_PATH:/build/deb/ /" | tee /etc/apt/sources.list.d/cri-o.list
apt-get update

apt-get install -y cri-o kubelet kubeadm kubectl
