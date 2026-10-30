#!/usr/bin/env bash

# shellcheck disable=SC2034 # variables are used in sourcing scripts

# Package configs
KUBERNETES_VERSION=v1.37
# allows to be set externally e.g. from a Dockerfile
PROJECT_PATH=${PROJECT_PATH:-prerelease:/main}

# CRI-O minor versions follow the Kubernetes ones, so test a release branch
# with its matching Kubernetes version. Newer branches stay on the latest one
# above, because Kubernetes packages only exist after its release.
if [[ $PROJECT_PATH =~ /v1\.([0-9]+)$ ]] && ((BASH_REMATCH[1] < ${KUBERNETES_VERSION#v1.})); then
    KUBERNETES_VERSION=v1.${BASH_REMATCH[1]}
fi
