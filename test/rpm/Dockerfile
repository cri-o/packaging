ARG FROM=fedora:39
FROM $FROM

ARG PROJECT_PATH=prerelease:/main

COPY *.sh /tmp/

RUN cd /tmp && ./install-rpm.sh --crio-only && \
    crio --version
