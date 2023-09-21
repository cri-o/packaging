# vim: syn=dockerfile
FROM ubuntu:22.04

ENV KUBERNETES_VERSION=v1.28
ARG PROJECT_PATH=prerelease:/main

RUN apt-get update && \
    apt-get install -y software-properties-common curl

RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

RUN curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH:/build/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH:/build/deb/ /" | tee /etc/apt/sources.list.d/cri-o.list

RUN apt-get update && apt-get install -y cri-o

RUN crio --version
