ARG FROM=ubuntu:22.04
FROM $FROM

ARG PROJECT_PATH=prerelease:/main

RUN apt-get update && \
    apt-get install -y \
        curl \
        software-properties-common

RUN curl -fsSL "https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:/$PROJECT_PATH:/build/deb/Release.key" | gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:/$PROJECT_PATH:/build/deb/ /" | tee /etc/apt/sources.list.d/cri-o.list

RUN apt-get update && apt-get install -y cri-o

RUN crio --version
