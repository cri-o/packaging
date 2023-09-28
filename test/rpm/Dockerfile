ARG FROM=fedora:38
FROM $FROM

ARG PROJECT_PATH=prerelease:/main

RUN printf "[cri-o]\n\
name=CRI-O\n\
baseurl=https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:/$PROJECT_PATH:/build/rpm/\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH:/build/rpm/repodata/repomd.xml.key\n\
" > /etc/yum.repos.d/cri-o.repo

RUN dnf install -y \
    containernetworking-plugins \
    iptables

RUN dnf install -y --repo cri-o cri-o

RUN crio --version
