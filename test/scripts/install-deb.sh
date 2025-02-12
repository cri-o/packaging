#!/usr/bin/env bash

set -euxo pipefail

# This script installs the required deb packages to bootstrap a Kubernetes cluster
# It takes an optional --crio-only argument, that when set, it only installs the cri-o package; this is used from the Dockerfile
# It is referenced from ../deb/Vagrantfile and ../deb/Dockerfile

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
    curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
fi
curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/"$PROJECT_PATH":/build/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/$PROJECT_PATH:/build/deb/ /" | tee /etc/apt/sources.list.d/cri-o.list

apt-get update

apt-get install -y cri-o jq
if [ -z $CRIO_ONLY ]; then
    apt-get install -y kubelet kubeadm kubectl
fi
