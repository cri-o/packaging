#!/usr/bin/env bash

set -euxo pipefail

# This script installs the required deb packages to bootstrap a Kubernetes cluster
# It takes an optional --crio-only argument, that when set, it only installs the cri-o package; this is used from the Dockerfile
# It is referenced from ../rpm/Vagrantfile and ../rpm/Dockerfile

CRIO_ONLY=
while [ $# -gt 0 ]; do
    case $1 in
    --crio-only)
        CRIO_ONLY=1
        shift
        ;;
    esac
done

# shellcheck source=test/scripts/versions.sh
source ./versions.sh

if [ -z $CRIO_ONLY ]; then
    cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/repodata/repomd.xml.key
EOF
fi

cat <<EOF | tee /etc/yum.repos.d/cri-o.repo
[cri-o]
name=CRI-O
baseurl=https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:/$PROJECT_PATH:/build/rpm/
enabled=1
gpgcheck=1
gpgkey=https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:/$PROJECT_PATH:/build/rpm/repodata/repomd.xml.key
EOF

dnf install -y cri-o jq
if [ -z $CRIO_ONLY ]; then
    dnf install -y container-selinux kubelet kubeadm kubectl
fi
