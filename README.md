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
deb and rpm packaging efforts within the Kubernetes community:

- pkgs.k8s.io: Introducing Kubernetes Community-Owned Package Repositories:
  https://kubernetes.io/blog/2023/08/15/pkgs-k8s-io-introduction/

- Kubernetes Legacy Package Repositories Will Be Frozen On September 13, 2023:
  https://kubernetes.io/blog/2023/08/31/legacy-package-repository-deprecation/

- Installing Kubernetes via `kubeadm`:
  https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#dpkg-k8s-package-repo

## Project Layout

CRI-O uses the same basic project layout in OBS as Kubernetes, but lives in a
dedicated umbrella subproject called [`isv:kubernetes:addons:cri-o`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o).

This project contains a bunch of other [subprojects](https://build.opensuse.org/project/subprojects/isv:kubernetes:addons:cri-o):

### Prereleases

- [`isv:kubernetes:addons:cri-o:prerelease`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease): Prerelease Packages (Umbrella)
- [`isv:kubernetes:addons:cri-o:prerelease:main`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:main): [`main`](https://github.com/cri-o/cri-o/commits/main) branch (Prerelease)
  - [`isv:kubernetes:addons:cri-o:prerelease:main:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:main:build): [`main`](https://github.com/cri-o/cri-o/commits/main) branch (Builder)
- [`isv:kubernetes:addons:cri-o:prerelease:v1.29`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.29): [`release-1.29`](https://github.com/cri-o/cri-o/commits/release-1.29) (Prerelease)
  - [`isv:kubernetes:addons:cri-o:prerelease:v1.29:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.29:build): [`release-1.29`](https://github.com/cri-o/cri-o/commits/release-1.29) (Builder)
- [`isv:kubernetes:addons:cri-o:prerelease:v1.28`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.28): [`release-1.28`](https://github.com/cri-o/cri-o/commits/release-1.28) (Prerelease)
  - [`isv:kubernetes:addons:cri-o:prerelease:v1.28:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:prerelease:v1.28:build): [`release-1.28`](https://github.com/cri-o/cri-o/commits/release-1.28) (Builder)

### Stable Versions

- [`isv:kubernetes:addons:cri-o:stable`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable): Stable Packages (Umbrella)
- [`isv:kubernetes:addons:cri-o:stable:v1.29`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.29): `v1.29.z` tags (Stable)
  - [`isv:kubernetes:addons:cri-o:stable:v1.29:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.29:build): `v1.29.z` tags (Builder)
- [`isv:kubernetes:addons:cri-o:stable:v1.28`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.28): `v1.28.z` tags (Stable)
  - [`isv:kubernetes:addons:cri-o:stable:v1.28:build`](https://build.opensuse.org/project/show/isv:kubernetes:addons:cri-o:stable:v1.28:build): `v1.28.z` tags (Builder)

The `prerelease` projects are mainly used for `release-x.y` branches as well as
the `main` branch of CRI-O. The `stable` projects are used for tagged releases.
The `build` projects are the builders for each project to be published, while
the main repositories for them are on top. For example, the builder project for
`main` is:

- `isv:kubernetes:addons:cri-o:prerelease:main:build`

But end-users will consume:

- `isv:kubernetes:addons:cri-o:prerelease:main`

## Usage

### RPM

```bash
KUBERNETES_VERSION=v1.28
PROJECT_PATH=prerelease:/main

cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/repodata/repomd.xml.key
EOF

cat <<EOF | tee /etc/yum.repos.d/cri-o.repo
[cri-o]
name=CRI-O
baseurl=https://pkgs.k8s.io/addons:/cri-o:/"$PROJECT_PATH"/build/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/addons:/cri-o:/"$PROJECT_PATH"/build/rpm/repodata/repomd.xml.key
EOF

dnf install -y \
    cri-o \
    container-selinux \
    kubeadm \
    kubectl \
    kubelet \
    kubernetes-cni

systemctl enable --now crio.service
```

### DEB

```bash
apt-get update
apt-get install -y software-properties-common curl

KUBERNETES_VERSION=v1.28
PROJECT_PATH=prerelease:/main

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/"$PROJECT_PATH"/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/"$PROJECT_PATH"/deb/ /" | tee /etc/apt/sources.list.d/cri-o.list
apt-get update

apt-get install -y cri-o kubelet kubeadm kubectl
systemctl enable --now crio.service
```

## Publishing

The [`obs` GitHub action workflow](https://github.com/cri-o/packaging/actions/workflows/obs.yml)
can be used to manually trigger release for a CRI-O tag, a `release-x.y` branch
or `main`. There is a [daily cron scheduled for release branches](.github/workflows/schedule.yml),
but it is also possible to trigger the package creation at a certain point in time. The
`obs` pipeline will:

1. Bundle the sources and [spec file](https://github.com/kubernetes/release/blob/master/cmd/krel/templates/latest/cri-o/cri-o.spec)
   into the corresponding `build` project.
2. Wait for the OBS builders to finish.
3. Run a [package installation and usage test](scripts/test) on Ubuntu and Fedora by using `kubeadm`.
4. Publish the packages into the top level project.
