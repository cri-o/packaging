# CRI-O Packaging

[![Publish package](https://img.shields.io/badge/publish-package-blue?logo=task&logoColor=white)](https://github.com/cri-o/packaging/actions/workflows/obs.yml)
[![OBS workflow](https://github.com/cri-o/packaging/actions/workflows/obs.yml/badge.svg)](https://github.com/cri-o/packaging/actions/workflows/obs.yml)
[![Schedule workflow](https://github.com/cri-o/packaging/actions/workflows/schedule.yml/badge.svg)](https://github.com/cri-o/packaging/actions/workflows/schedule.yml)
[![Test workflow](https://github.com/cri-o/packaging/actions/workflows/test.yml/badge.svg)](https://github.com/cri-o/packaging/actions/workflows/test.yml)

The intention of this project is to encapsulate CRI-O's packaging efforts into a
dedicated repository, following official Kubernetes guidelines by using the
[openSUSE Build Service (OBS)](https://build.opensuse.org).

## Motivation

The following resources are great to understand the motivation behind the latest
`deb` and `rpm` packaging efforts within the CRI-O and Kubernetes community:

- **CRI-O is moving towards pkgs.k8s.io**:

  https://k8s.io/blog/2023/10/10/cri-o-community-package-infrastructure

- **Kubernetes Legacy Package Repositories Will Be Frozen On September 13, 2023**:

  https://kubernetes.io/blog/2023/08/31/legacy-package-repository-deprecation/

- **pkgs.k8s.io: Introducing Kubernetes Community-Owned Package Repositories**:

  https://kubernetes.io/blog/2023/08/15/pkgs-k8s-io-introduction/

- **Installing Kubernetes via `kubeadm`**:

  https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#dpkg-k8s-package-repo

## Project Layout

CRI-O uses the same basic project layout in OBS as Kubernetes, but lives in a
dedicated umbrella subproject called [`isv:kubernetes:addons:cri-o`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o).

This project contains a bunch of other [subprojects](https://build.opensuse.org/project/subprojects/isv:kubernetes:addons:cri-o):

### Stable Versions

- [`isv:kubernetes:addons:cri-o:stable`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable): Stable Packages (Umbrella)
  - [`isv:kubernetes:addons:cri-o:stable:v1.30`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.30): `v1.30.z` tags (Stable)
    - [`isv:kubernetes:addons:cri-o:stable:v1.30:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.30:build): `v1.30.z` tags (Builder)
  - [`isv:kubernetes:addons:cri-o:stable:v1.29`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.29): `v1.29.z` tags (Stable)
    - [`isv:kubernetes:addons:cri-o:stable:v1.29:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.29:build): `v1.29.z` tags (Builder)
  - [`isv:kubernetes:addons:cri-o:stable:v1.28`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.28): `v1.28.z` tags (Stable)
    - [`isv:kubernetes:addons:cri-o:stable:v1.28:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.28:build): `v1.28.z` tags (Builder)

### Prereleases

- [`isv:kubernetes:addons:cri-o:prerelease`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease): Prerelease Packages (Umbrella)
  - [`isv:kubernetes:addons:cri-o:prerelease:main`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:main): [`main`](https://github.com/cri-o/cri-o/commits/main) branch (Prerelease)
    - [`isv:kubernetes:addons:cri-o:prerelease:main:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:main:build): [`main`](https://github.com/cri-o/cri-o/commits/main) branch (Builder)
  - [`isv:kubernetes:addons:cri-o:prerelease:v1.30`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.30): [`release-1.30`](https://github.com/cri-o/cri-o/commits/release-1.30) branch (Prerelease)
    - [`isv:kubernetes:addons:cri-o:prerelease:v1.30:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.30:build): [`release-1.30`](https://github.com/cri-o/cri-o/commits/release-1.30) branch (Builder)
  - [`isv:kubernetes:addons:cri-o:prerelease:v1.29`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.29): [`release-1.29`](https://github.com/cri-o/cri-o/commits/release-1.29) branch (Prerelease)
    - [`isv:kubernetes:addons:cri-o:prerelease:v1.29:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.29:build): [`release-1.29`](https://github.com/cri-o/cri-o/commits/release-1.29) branch (Builder)
  - [`isv:kubernetes:addons:cri-o:prerelease:v1.28`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.28): [`release-1.28`](https://github.com/cri-o/cri-o/commits/release-1.28) branch (Prerelease)
    - [`isv:kubernetes:addons:cri-o:prerelease:v1.28:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.28:build): [`release-1.28`](https://github.com/cri-o/cri-o/commits/release-1.28) branch (Builder)

The `prerelease` projects are mainly used for `release-x.y` branches as well as
the `main` branch of CRI-O. The `stable` projects are used for tagged releases.
The `build` projects are the builders for each project to be published, while
the main repositories for them are on top. For example, the builder project for
`main` is:

- `isv:kubernetes:addons:cri-o:prerelease:main:build`

But end-users will consume:

- `isv:kubernetes:addons:cri-o:prerelease:main`

All packages are based on the static binary bundles provided by the CRI-O CI.

## Usage

### Available Streams

[![v1.30](https://img.shields.io/badge/stable-v1.30-brightgreen?logo=github)](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.30)
[![v1.29](https://img.shields.io/badge/stable-v1.29-brightgreen?logo=github)](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.29)
[![v1.28](https://img.shields.io/badge/stable-v1.28-brightgreen?logo=github)](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.28)
[![main](https://img.shields.io/badge/prerelease-main-blue?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:main)
[![release-1.30](https://img.shields.io/badge/prerelease-release--1.30-blue?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.30)
[![release-1.29](https://img.shields.io/badge/prerelease-release--1.29-blue?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.29)
[![release-1.28](https://img.shields.io/badge/prerelease-release--1.28-blue?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.28)

### Distributions using `rpm` packages

#### Define the Kubernetes version and used CRI-O stream

```bash
KUBERNETES_VERSION=v1.30
PROJECT_PATH=prerelease:/main
```

#### Add the Kubernetes repository

```bash
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/repodata/repomd.xml.key
EOF
```

#### Add the CRI-O repository

```bash
cat <<EOF | tee /etc/yum.repos.d/cri-o.repo
[cri-o]
name=CRI-O
baseurl=https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH/rpm/repodata/repomd.xml.key
EOF
```

#### Install package dependencies from the official repositories

```bash
dnf install -y container-selinux
```

#### Install the packages

```bash
dnf install -y cri-o kubelet kubeadm kubectl
```

#### Start CRI-O

```bash
systemctl start crio.service
```

#### Bootstrap a cluster

```bash
swapoff -a
modprobe br_netfilter
sysctl -w net.ipv4.ip_forward=1

kubeadm init
```

### Distributions using `deb` packages

#### Install the dependencies for adding repositories

```bash
apt-get update
apt-get install -y software-properties-common curl
```

#### Define the Kubernetes version and used CRI-O stream

```bash
KUBERNETES_VERSION=v1.30
PROJECT_PATH=prerelease:/main
```

#### Add the Kubernetes repository

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list
```

#### Add the CRI-O repository

```bash
curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list
```

#### Install the packages

```bash
apt-get update
apt-get install -y cri-o kubelet kubeadm kubectl
```

#### Start CRI-O

```bash
systemctl start crio.service
```

#### Bootstrap a cluster

```bash
swapoff -a
modprobe br_netfilter
sysctl -w net.ipv4.ip_forward=1

kubeadm init
```

## Publishing

The [`obs` GitHub action workflow](https://github.com/cri-o/packaging/actions/workflows/obs.yml)
can be used to manually trigger release for a CRI-O tag, a `release-x.y` branch
or `main`. There is a [daily cron scheduled for release branches](.github/workflows/schedule.yml),
but it is also possible to trigger the package creation at a certain point in time. The
`obs` pipeline will:

1. Build a static binary bundle which contains all necessary files.
1. Push the bundle and [spec file](templates/latest/cri-o/cri-o.spec) into the
   corresponding `build` project.
1. Wait for the OBS builders to finish.
1. Run package installation and usage tests for [Kubernetes](scripts/test-kubernetes)
   and [available architectures](scripts/test-architectures) for various Distributions.
1. Publish the packages into the top level project.

## Using the static binary bundles directly

We always recommend to use `deb` and `rpm` packages over the static binary
bundle, but for some reason packages may not be a good fit. Every run in the
`obs` GitHub workflow will publish a static binary bundle on our [Google Cloud
Storage Bucket][bucket], which contains all necessary binaries and
configurations.

[bucket]: https://console.cloud.google.com/storage/browser/cri-o/artifacts

This means that the latest available CRI-O `main` commit can be installed via
our convenience script:

```console
> curl https://raw.githubusercontent.com/cri-o/packaging/main/get | bash
```

The script automatically verifies the uploaded sigstore signatures as well, if
the local system has [`cosign`](https://github.com/sigstore/cosign) available in
its `$PATH`. The same applies to the [SPDX](https://spdx.org) based bill of
materials (SBOM), which gets automatically verified if the
[bom](https://sigs.k8s.io/bom) tool is in `$PATH`.

Besides `amd64`, we also support the `arm64`, `ppc64le` and `s390x` bit
architectures. This can be selected via the script, too:

```shell
curl https://raw.githubusercontent.com/cri-o/packaging/main/get | bash -s -- -a arm64
```

It is also possible to select a specific git SHA or tag by:

```shell
curl https://raw.githubusercontent.com/cri-o/packaging/main/get | bash -s -- -t v1.29.0
```

The above script resolves to the download URL of the static binary bundle
tarball matching the format:

```text
https://storage.googleapis.com/cri-o/artifacts/cri-o.$ARCH.$REV.tar.gz
```

Where `$ARCH` can be `amd64`, `arm64`, `ppc64le` or `s390x` and `$REV`
can be any git SHA or tag.

We also provide a Software Bill of Materials (SBOM) in the [SPDX
format](https://spdx.org) for each bundle. The SBOM is available at the same URL
like the bundle itself, but suffixed with `.spdx`:

```text
https://storage.googleapis.com/cri-o/artifacts/cri-o.$ARCH.$REV.tar.gz.spdx
```
