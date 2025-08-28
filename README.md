# CRI-O Packaging

[![Publish package](https://img.shields.io/badge/publish-package-blue?logo=task&logoColor=white)](https://github.com/cri-o/packaging/actions/workflows/obs.yml)
[![OBS workflow](https://github.com/cri-o/packaging/actions/workflows/obs.yml/badge.svg)](https://github.com/cri-o/packaging/actions/workflows/obs.yml)
[![Schedule workflow](https://github.com/cri-o/packaging/actions/workflows/schedule.yml/badge.svg)](https://github.com/cri-o/packaging/actions/workflows/schedule.yml)
[![Test workflow](https://github.com/cri-o/packaging/actions/workflows/test.yml/badge.svg)](https://github.com/cri-o/packaging/actions/workflows/test.yml)

The intention of this project is to encapsulate CRI-O's packaging efforts into a
dedicated repository, following official Kubernetes guidelines by using the
[openSUSE Build Service (OBS)](https://build.opensuse.org).

<!-- toc -->

- [Project Layout](#project-layout)
  - [Stable Versions](#stable-versions)
  - [Prereleases](#prereleases)
- [Usage](#usage)
  - [Available Streams](#available-streams)
    - [Stable](#stable)
      - [Deprecated](#deprecated)
    - [Prerelease](#prerelease)
      - [Deprecated](#deprecated-1)
    - [Define the Kubernetes version and used CRI-O stream](#define-the-kubernetes-version-and-used-cri-o-stream)
  - [Distributions using <code>rpm</code> packages](#distributions-using-rpm-packages)
    - [Add the Kubernetes repository](#add-the-kubernetes-repository)
    - [Add the CRI-O repository](#add-the-cri-o-repository)
    - [Install package dependencies from the official repositories](#install-package-dependencies-from-the-official-repositories)
    - [Install the packages](#install-the-packages)
    - [Configure a Container Network Interface (CNI) plugin](#configure-a-container-network-interface-cni-plugin)
    - [Start CRI-O](#start-cri-o)
    - [Bootstrap a cluster](#bootstrap-a-cluster)
  - [Distributions using <code>deb</code> packages](#distributions-using-deb-packages)
    - [Install the dependencies for adding repositories](#install-the-dependencies-for-adding-repositories)
    - [Add the Kubernetes repository](#add-the-kubernetes-repository-1)
    - [Add the CRI-O repository](#add-the-cri-o-repository-1)
    - [Install the packages](#install-the-packages-1)
    - [Start CRI-O](#start-cri-o-1)
    - [Bootstrap a cluster](#bootstrap-a-cluster-1)
- [Publishing](#publishing)
- [Using the static binary bundles directly](#using-the-static-binary-bundles-directly)
- [Uninstall the static binary bundles](#uninstall-the-static-binary-bundles)
- [CRI-O bundles as OCI artifacts](#cri-o-bundles-as-oci-artifacts)
- [More to read](#more-to-read)
<!-- /toc -->

## Project Layout

CRI-O uses the same basic layout in OBS as Kubernetes project [`isv:kubernetes`](https://build.opensuse.org/project/show/isv:kubernetes),
but lives in a dedicated umbrella project called [`isv:cri-o`](https://build.opensuse.org/project/show/isv:cri-o).

This project contains a bunch of other [subprojects](https://build.opensuse.org/project/subprojects/isv:cri-o).

> [!CAUTION]
> We switched from `https://pkgs.k8s.io/addons:/cri-o` to a new subproject
> `https://download.opensuse.org/repositories/isv:/cri-o` to work independently
> from the pkgs.k8s.io CDN. Please switch over if you haven't already (see the
> examples below).

### Stable Versions

- [`isv:cri-o:stable`](https://build.opensuse.org/project/show/isv:cri-o:stable): Stable Packages (Umbrella)
  - [`isv:cri-o:stable:v1.34`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.34): `v1.34.z` tags (Stable)
    - [`isv:cri-o:stable:v1.34:build`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.34:build): `v1.34.z` tags (Builder)
  - [`isv:cri-o:stable:v1.33`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.33): `v1.33.z` tags (Stable)
    - [`isv:cri-o:stable:v1.33:build`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.33:build): `v1.33.z` tags (Builder)
  - [`isv:cri-o:stable:v1.32`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.32): `v1.32.z` tags (Stable)
    - [`isv:cri-o:stable:v1.32:build`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.32:build): `v1.32.z` tags (Builder)
  - [`isv:cri-o:stable:v1.31`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.31): `v1.31.z` tags (Stable)
    - [`isv:cri-o:stable:v1.31:build`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.31:build): `v1.31.z` tags (Builder)
  - **End of life:**
    - [`isv:cri-o:stable:v1.30`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.30): `v1.30.z` tags (Stable)
      - [`isv:cri-o:stable:v1.30:build`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.30:build): `v1.30.z` tags (Builder)
    - [`isv:cri-o:stable:v1.29`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.29): `v1.29.z` tags (Stable)
      - [`isv:cri-o:stable:v1.29:build`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.29:build): `v1.29.z` tags (Builder)
    - [`isv:cri-o:stable:v1.28`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.28): `v1.28.z` tags (Stable)
      - [`isv:cri-o:stable:v1.28:build`](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.28:build): `v1.28.z` tags (Builder)

### Prereleases

- [`isv:cri-o:prerelease`](https://build.opensuse.org/project/show/isv:cri-o:prerelease): Prerelease Packages (Umbrella)
  - [`isv:cri-o:prerelease:main`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:main): [`main`](https://github.com/cri-o/cri-o/commits/main) branch (Prerelease)
    - [`isv:cri-o:prerelease:main:build`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:main:build): [`main`](https://github.com/cri-o/cri-o/commits/main) branch (Builder)
  - [`isv:cri-o:prerelease:v1.34`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.34): [`release-1.34`](https://github.com/cri-o/cri-o/commits/release-1.34) branch (Prerelease)
    - [`isv:cri-o:prerelease:v1.34:build`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.34:build): [`release-1.34`](https://github.com/cri-o/cri-o/commits/release-1.34) branch (Builder)
  - [`isv:cri-o:prerelease:v1.33`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.33): [`release-1.33`](https://github.com/cri-o/cri-o/commits/release-1.33) branch (Prerelease)
    - [`isv:cri-o:prerelease:v1.33:build`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.33:build): [`release-1.33`](https://github.com/cri-o/cri-o/commits/release-1.33) branch (Builder)
  - [`isv:cri-o:prerelease:v1.32`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.32): [`release-1.32`](https://github.com/cri-o/cri-o/commits/release-1.32) branch (Prerelease)
    - [`isv:cri-o:prerelease:v1.32:build`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.32:build): [`release-1.32`](https://github.com/cri-o/cri-o/commits/release-1.32) branch (Builder)
  - [`isv:cri-o:prerelease:v1.31`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.31): [`release-1.31`](https://github.com/cri-o/cri-o/commits/release-1.31) branch (Prerelease)
    - [`isv:cri-o:prerelease:v1.31:build`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.31:build): [`release-1.31`](https://github.com/cri-o/cri-o/commits/release-1.31) branch (Builder)
  - **End of life:**
    - [`isv:cri-o:prerelease:v1.30`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.30): [`release-1.30`](https://github.com/cri-o/cri-o/commits/release-1.30) branch (Prerelease)
      - [`isv:cri-o:prerelease:v1.30:build`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.30:build): [`release-1.30`](https://github.com/cri-o/cri-o/commits/release-1.30) branch (Builder)
    - [`isv:cri-o:prerelease:v1.29`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.29): [`release-1.29`](https://github.com/cri-o/cri-o/commits/release-1.29) branch (Prerelease)
      - [`isv:cri-o:prerelease:v1.29:build`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.29:build): [`release-1.29`](https://github.com/cri-o/cri-o/commits/release-1.29) branch (Builder)
    - [`isv:cri-o:prerelease:v1.28`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.28): [`release-1.28`](https://github.com/cri-o/cri-o/commits/release-1.28) branch (Prerelease)
      - [`isv:cri-o:prerelease:v1.28:build`](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.28:build): [`release-1.28`](https://github.com/cri-o/cri-o/commits/release-1.28) branch (Builder)

The `prerelease` projects are mainly used for `release-x.y` branches as well as
the `main` branch of CRI-O. The `stable` projects are used for tagged releases.
The `build` projects are the builders for each project to be published, while
the main repositories for them are on top. For example, the builder project for
`main` is:

- `isv:cri-o:prerelease:main:build`

But end-users will consume:

- `isv:cri-o:prerelease:main`

All packages are based on the static binary bundles provided by the CRI-O CI.

## Usage

### Available Streams

#### Stable

[![v1.34](https://img.shields.io/badge/stable-v1.34-yellow?logo=github)](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.34)
[![v1.33](https://img.shields.io/badge/stable-v1.33-brightgreen?logo=github)](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.33)
[![v1.32](https://img.shields.io/badge/stable-v1.32-brightgreen?logo=github)](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.32)
[![v1.31](https://img.shields.io/badge/stable-v1.31-brightgreen?logo=github)](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.31)

##### Deprecated

[![v1.30](https://img.shields.io/badge/end%20of%20life-v1.30-red?logo=github)](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.30)
[![v1.29](https://img.shields.io/badge/end%20of%20life-v1.29-red?logo=github)](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.29)
[![v1.28](https://img.shields.io/badge/end%20of%20life-v1.28-red?logo=github)](https://build.opensuse.org/project/show/isv:cri-o:stable:v1.28)

#### Prerelease

[![main](https://img.shields.io/badge/prerelease-main-blue?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:cri-o:prerelease:main)
[![release-1.34](https://img.shields.io/badge/prerelease-release--1.34-blue?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.34)
[![release-1.33](https://img.shields.io/badge/prerelease-release--1.33-blue?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.33)
[![release-1.32](https://img.shields.io/badge/prerelease-release--1.32-blue?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.32)
[![release-1.31](https://img.shields.io/badge/prerelease-release--1.31-blue?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.31)

##### Deprecated

[![release-1.30](https://img.shields.io/badge/end%20of%20life-release--1.30-red?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.30)
[![release-1.29](https://img.shields.io/badge/end%20of%20life-release--1.29-red?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.29)
[![release-1.28](https://img.shields.io/badge/end%20of%20life-release--1.28-red?logo=git&logoColor=white)](https://build.opensuse.org/project/show/isv:cri-o:prerelease:v1.28)

#### Define the Kubernetes version and used CRI-O stream

```bash
KUBERNETES_VERSION=v1.34
CRIO_VERSION=v1.33
```

### Distributions using `rpm` packages

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
baseurl=https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/rpm/
enabled=1
gpgcheck=1
gpgkey=https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/rpm/repodata/repomd.xml.key
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

#### Configure a Container Network Interface (CNI) plugin

CRI-O is capable of working with different [CNI plugins](https://github.com/containernetworking/cni),
which may require a custom configuration. The CRI-O package ships a default
[IPv4 and IPv6 (dual stack) configuration](templates/latest/cri-o/bundle/10-crio-bridge.conflist.disabled)
for the [`bridge`](https://www.cni.dev/plugins/current/main/bridge) plugin,
which is disabled by default. The configuration can be enabled by renaming the
disabled configuration file in `/etc/cni/net.d`:

```bash
mv /etc/cni/net.d/10-crio-bridge.conflist.disabled /etc/cni/net.d/10-crio-bridge.conflist
```

The bridge plugin is suitable for single-node clusters in CI and testing
environments. Different CNI plugins are recommended to use CRI-O in production.

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

#### Add the Kubernetes repository

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list
```

#### Add the CRI-O repository

```bash
curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
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
   1 Upload the bundle to the CNCF [Google Cloud Storage Bucket][bucket] as well
   as the [GitHub container image registry as OCI
   artifacts](https://github.com/cri-o/packaging/pkgs/container/bundle).
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
curl https://raw.githubusercontent.com/cri-o/packaging/main/get | bash -s -- -t v1.33.0
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

## Uninstall the static binary bundles

```console
> curl https://raw.githubusercontent.com/cri-o/packaging/main/get | bash -s -- -u
```

## CRI-O bundles as OCI artifacts

The [`obs` GitHub action workflow](https://github.com/cri-o/packaging/actions/workflows/obs.yml)
publishes OCI artifacts within [GitHub container image
registry](https://github.com/cri-o/packaging/pkgs/container/bundle). This means
that the whole bundle can be retrieved by consuming the OCI artifacts from
tools like [Podman](https://podman.io) or [ORAS](https://oras.land). All
artifacts are pushed as multi-architecture OCI image indexes, which means that
the corresponding tool can download the right architecture on the target
platform immediately. The following tags are available:

- `latest`, `main`: References the latest available commit on the CRI-O `main`
  branch, for example:
  - [`ghcr.io/cri-o/bundle:main`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:main)
  - [`ghcr.io/cri-o/bundle:latest`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:latest)

- A specific tag:
  - [`ghcr.io/cri-o/bundle:v1.33.0`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:v1.33.0)
  - [`ghcr.io/cri-o/bundle:v1.32.4`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:v1.32.4)
  - [`ghcr.io/cri-o/bundle:v1.31.8`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:v1.31.8)
  - [`ghcr.io/cri-o/bundle:v1.30.13`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:v1.30.13)

- A certain commit in long and short (7 characters) format:
  - [`ghcr.io/cri-o/bundle:17ac08c0c9976930f7d66896307bf46249223b1c`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:17ac08c0c9976930f7d66896307bf46249223b1c)
  - [`ghcr.io/cri-o/bundle:17ac08c`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:17ac08c)

- The latest minor version, release branch or development version:
  - [`ghcr.io/cri-o/bundle:v1.32`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:v1.32)
  - [`ghcr.io/cri-o/bundle:release-1.32`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:release-1.32)
  - [`ghcr.io/cri-o/bundle:v1.32.0-dev`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:v1.32.3-dev)

- The architecture derivates of the above:
  - [`ghcr.io/cri-o/bundle:main-arm64`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:main-arm64)
  - [`ghcr.io/cri-o/bundle:latest-ppc64le`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:latest-ppc64le)
  - [`ghcr.io/cri-o/bundle:17ac08c0c9976930f7d66896307bf46249223b1c-s390x`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:17ac08c0c9976930f7d66896307bf46249223b1c-s390x)
  - [`ghcr.io/cri-o/bundle:17ac08c-amd64`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:17ac08c-amd64)
  - [`ghcr.io/cri-o/bundle:v1.32-amd64`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:v1.32-amd64)
  - [`ghcr.io/cri-o/bundle:release-1.32-arm64`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:release-1.32-arm64)
  - [`ghcr.io/cri-o/bundle:v1.32.0-dev-s390x`](https://explore.ggcr.dev/?image=ghcr.io/cri-o/bundle:v1.32.3-dev-s390x)

All artifacts are annotated by corresponding metadata to allow proper
identification:

```console
> oras manifest fetch ghcr.io/cri-o/bundle:main | jq .annotations
{
  "org.cncf.cri-o.branch": "main",
  "org.cncf.cri-o.commit": "2fe75a93f6526cf5c649476692cdecfc982e13e8",
  "org.cncf.cri-o.project": "main",
  "org.cncf.cri-o.version": "v1.33.0-dev",
  "org.opencontainers.image.created": "2025-05-06T01:37:13Z"
}
```

The artifacts are also signed by [sigstore](https://www.sigstore.dev/):

```console
> cosign verify \
        --certificate-identity https://github.com/cri-o/packaging/.github/workflows/obs.yml@refs/heads/main \
        --certificate-oidc-issuer https://token.actions.githubusercontent.com \
        ghcr.io/cri-o/bundle:main

…
```

The corresponding Software Bill of Materials (SBOM) is attached to the related
artifact:

```console
> oras discover --platform linux/amd64 ghcr.io/cri-o/bundle:main

ghcr.io/cri-o/bundle@sha256:71c6fbca2330d73faeda5632bc8e1f137ecefc0faee644013009fd3104db146b
└── application/vnd.cncf.spdx.file.v1
    └── sha256:ca4ca75e9999997e5ab753bd606f81115678f67891611906d9a0ecfad42dfe07
        └── [annotations]
            ├── org.cncf.cri-o.project: main
            ├── org.cncf.cri-o.version: v1.33.0-dev
            ├── org.opencontainers.image.created: "2025-04-25T01:37:00Z"
            ├── org.cncf.cri-o.branch: main
            └── org.cncf.cri-o.commit: 17ac08c0c9976930f7d66896307bf46249223b1c

> oras pull $(oras discover --platform linux/amd64 --format json ghcr.io/cri-o/bundle:main | jq -r .referrers[0].reference)
…
```

## More to read

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
