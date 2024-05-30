#!/usr/bin/env bash

set -euxo pipefail

# This script installs the required deb packages to bootstrap a Kubernetes cluster
# It is referenced from ../rpm/Vagrantfile

# Package configs
KUBERNETES_VERSION=v1.30
PROJECT_PATH=prerelease:/main

cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/repodata/repomd.xml.key
EOF

cat <<EOF | tee /etc/yum.repos.d/cri-o.repo
[cri-o]
name=CRI-O
baseurl=https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:/$PROJECT_PATH:/build/rpm/
enabled=1
gpgcheck=1
gpgkey=https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:/$PROJECT_PATH:/build/rpm/repodata/repomd.xml.key
EOF

# Official package dependencies
dnf install -y container-selinux

dnf install -y cri-o kubelet kubeadm kubectl
