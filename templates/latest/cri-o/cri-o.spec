%global debug_package %{nil}
%undefine _missing_build_ids_terminate_build

Name: cri-o
Version: {{ .RPMVersion }}
Release: {{ .Revision }}
Summary: Open Container Initiative-based implementation of Kubernetes Container Runtime Interface
Packager: Kubernetes Authors <dev@kubernetes.io>
License: Apache-2.0
URL: https://kubernetes.io
Source0: %{name}_%{version}.orig.tar.gz
BuildRequires: sed
BuildRequires: systemd
%{?systemd_requires}

%if "%{_vendor}" == "debbuild"
Group: admin
BuildRequires: systemd-deb-macros
# The _unitdir macro does not exist on debbuild
%define _unitdir %{_prefix}/lib/systemd/system
Recommends: kubernetes-cni
%else
BuildRequires: systemd-rpm-macros
Recommends: kubernetes-cni
%endif

Requires: iptables

%description
%{summary}.

%prep
%setup -q -c

%build
# Nothing to build

%install
%define archive_root "$(uname -m)"/cri-o
cp %{archive_root}/LICENSE .
cp %{archive_root}/README.md .

# Directories
install -dp %{buildroot}%{_sharedstatedir}/crio

# Binaries
install -dp %{buildroot}%{_bindir}
install -p -m 755 %{archive_root}/bin/crio %{buildroot}%{_bindir}/crio
install -p -m 755 %{archive_root}/bin/pinns %{buildroot}%{_bindir}/pinns
install -p -m 755 %{archive_root}/bin/crio-crun %{buildroot}%{_bindir}/crio-crun
install -p -m 755 %{archive_root}/bin/crio-runc %{buildroot}%{_bindir}/crio-runc
install -p -m 755 %{archive_root}/bin/crio-conmon %{buildroot}%{_bindir}/crio-conmon
install -p -m 755 %{archive_root}/bin/crio-conmonrs %{buildroot}%{_bindir}/crio-conmonrs

# Completions
install -d -m 755 %{buildroot}%{_datadir}/bash-completion/completions
install -D -m 644 -t %{buildroot}%{_datadir}/bash-completion/completions %{archive_root}/completions/bash/crio

install -d -m 755 %{buildroot}%{_datadir}/fish/completions
install -D -m 644 -t %{buildroot}%{_datadir}/fish/completions %{archive_root}/completions/fish/crio.fish

install -d -m 755 %{buildroot}%{_datadir}/zsh/site-functions
install -D -m 644 -t %{buildroot}%{_datadir}/zsh/site-functions %{archive_root}/completions/zsh/_crio

# Configurations
install -dp %{buildroot}%{_sysconfdir}/containers
install -dp %{buildroot}%{_sysconfdir}/containers/registries.conf.d
install -p -m 644 %{archive_root}/contrib/registries.conf %{buildroot}%{_sysconfdir}/containers/registries.conf.d/crio.conf
install -p -m 644 %{archive_root}/etc/crictl.yaml %{buildroot}%{_sysconfdir}/crictl.yaml

install -dp %{buildroot}%{_sysconfdir}/crio/crio.conf.d
install -p -m 644 %{archive_root}/etc/10-crio.conf %{buildroot}%{_sysconfdir}/crio/crio.conf.d/10-crio.conf
install -p -m 644 %{archive_root}/contrib/policy.json %{buildroot}%{_sysconfdir}/crio/policy.json

install -dp %{buildroot}%{_datadir}/oci-umount/oci-umount.d
install -p -m 644 %{archive_root}/etc/crio-umount.conf %{buildroot}%{_datadir}/oci-umount/oci-umount.d/crio-umount.conf

install -dp %{buildroot}%{_sysconfdir}/cni/net.d
install -p -m 644 %{archive_root}/contrib/11-crio-ipv4-bridge.conflist %{buildroot}%{_sysconfdir}/cni/net.d/11-crio-ipv4-bridge.conflist

# Fix the prefix in crio.service
sed -i 's;/usr/local/bin;/usr/bin;g' %{archive_root}/contrib/crio.service

# Fix the /etc/sysconfig path for debian based distributions
%if "%{_vendor}" == "debbuild"
sed -i 's;/etc/sysconfig/crio;/etc/default/crio;g' %{archive_root}/contrib/crio.service %{archive_root}/etc/crio
%define systemconfigdir default
%else
%define systemconfigdir sysconfig
%endif
install -dp %{buildroot}%{_sysconfdir}/%{systemconfigdir}
install -p -m 644 %{archive_root}/etc/crio %{buildroot}%{_sysconfdir}/%{systemconfigdir}/crio
install -D -m 644 -t %{buildroot}%{_unitdir} %{archive_root}/contrib/crio.service

# Docs
install -D -m 644 -t %{buildroot}%{_mandir}/man5 %{archive_root}/man/crio.conf.5
install -D -m 644 -t %{buildroot}%{_mandir}/man5 %{archive_root}/man/crio.conf.d.5
install -D -m 644 -t %{buildroot}%{_mandir}/man8 %{archive_root}/man/crio.8

%post
%systemd_post crio.service

%preun
%systemd_preun crio.service

%postun
%systemd_postun_with_restart crio.service

%files

# Directories
%dir %{_sharedstatedir}/crio

# Binaries
%{_bindir}/crio
%{_bindir}/crio-conmon
%{_bindir}/crio-conmonrs
%{_bindir}/crio-crun
%{_bindir}/crio-runc
%{_bindir}/pinns

# Completions
%{_datadir}/bash-completion/completions/crio
%dir %{_datadir}/fish
%dir %{_datadir}/fish/completions
%{_datadir}/fish/completions/crio.fish
%dir %{_datadir}/zsh
%dir %{_datadir}/zsh/site-functions
%{_datadir}/zsh/site-functions/_crio

# Configurations
%dir %{_sysconfdir}/containers
%dir %{_sysconfdir}/containers/registries.conf.d
%config(noreplace) %{_sysconfdir}/containers/registries.conf.d/crio.conf
%config(noreplace) %{_sysconfdir}/crictl.yaml
%dir %{_sysconfdir}/cni
%dir %{_sysconfdir}/cni/net.d
%config(noreplace) %{_sysconfdir}/cni/net.d/11-crio-ipv4-bridge.conflist
%{_unitdir}/crio.service
%dir %{_sysconfdir}/crio
%dir %{_sysconfdir}/crio/crio.conf.d
%{_sysconfdir}/crio/crio.conf.d/10-crio.conf
%{_sysconfdir}/crio/policy.json
%dir %{_datadir}/oci-umount
%dir %{_datadir}/oci-umount/oci-umount.d
%{_datadir}/oci-umount/oci-umount.d/crio-umount.conf

# Docs
%{_mandir}/man5/crio.conf*5*
%{_mandir}/man8/crio*.8*

%license LICENSE
%doc README.md

%changelog
