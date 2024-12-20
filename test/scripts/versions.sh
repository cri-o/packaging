#!/usr/bin/env bash

# shellcheck disable=SC2034 # variables are used in sourcing scripts

# Package configs
KUBERNETES_VERSION=v1.32
# allows to be set externally e.g. from a Dockerfile
PROJECT_PATH=${PROJECT_PATH:-prerelease:/main}
