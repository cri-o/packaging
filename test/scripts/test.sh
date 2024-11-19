#!/usr/bin/env bash

set -euxo pipefail

# This script bootstraps a Kubernetes cluster and tests it comes up successfully
# It expects all required packages (kube*, cri-o) are already installed
# It is referenced from ../deb/Vagrantfile and ../rpm/Vagrantfile

# Disable IPv6 for CI
CNI_CONFIG=/etc/cni/net.d/10-crio-bridge.conflist
jq 'del(.plugins[0].ipam.routes[1], .plugins[0].ipam.ranges[1])' $CNI_CONFIG >tmp
mv tmp $CNI_CONFIG

systemctl start crio

# Disable swap
swapoff -a

# Cluster setup
modprobe br_netfilter
sysctl -w net.ipv4.ip_forward=1
kubeadm init

# Check cluster
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl wait -n kube-system --timeout=180s --for=condition=available deploy coredns
kubectl wait --timeout=180s --for=condition=ready pods --all -A
kubectl get pods -A
kubectl run -i --restart=Never --image debian --rm debian -- echo test | grep test
