ARG FROM=ubuntu:24.04
FROM $FROM

ARG PROJECT_PATH=prerelease:/main

COPY *.sh /tmp/

RUN apt-get update && \
    apt-get install -y curl gnupg && \
    cd /tmp && ./install-deb.sh --crio-only && \
    crio --version
