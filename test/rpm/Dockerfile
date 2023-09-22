ARG FROM=fedora:38
FROM $FROM

ENV KUBERNETES_VERSION=v1.28
ARG PROJECT_PATH=prerelease:/main

RUN printf "[kubernetes]\n\
name=Kubernetes\n\
baseurl=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/repodata/repomd.xml.key\n\
" > /etc/yum.repos.d/kubernetes.repo

RUN printf "[cri-o]\n\
name=CRI-O\n\
baseurl=https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH:/build/rpm/\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH:/build/rpm/repodata/repomd.xml.key\n\
" > /etc/yum.repos.d/cri-o.repo

RUN dnf install -y iptables

RUN dnf install -y --repo cri-o --repo kubernetes \
    cri-o \
    kubernetes-cni

RUN crio --version
