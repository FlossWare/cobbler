Summary: A set of kickstarts and snippets for cobbler
Name: flossware-cobbler
Version:  1.0
Release:  39
URL: https://github.com/FlossWare/cobbler
License: GPLv3
Source0: %{name}-%{version}.tar.gz
BuildArch: noarch
#Requires: cobbler

%description
A set of kickstarts and snippets for cobbler supporting modern distributions:
- Fedora 38-40+
- RHEL 8/9/10 and derivatives (Rocky Linux, AlmaLinux, CentOS Stream)
- Ubuntu/Debian (via preseed templates)

%prep
%setup -q

%build

%install
%{__rm} -rf %{buildroot}
%{__mkdir_p} %{buildroot}/var/lib/cobbler/templates
%{__mkdir_p} %{buildroot}/var/lib/cobbler/autoinstall_templates
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/modules/disk_partition_types
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/options
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/sections/addon_body
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/sections/anaconda_body
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/sections/post_body

# Install kickstart templates (only standard, atomic variants removed)
%{__install} -p -m 0755 templates/flossware_standard.ks %{buildroot}/var/lib/cobbler/templates/

# Install preseed templates for Debian/Ubuntu
%{__install} -p -m 0755 preseed/flossware_ubuntu.preseed %{buildroot}/var/lib/cobbler/autoinstall_templates/
%{__install} -p -m 0755 preseed/flossware_debian.preseed %{buildroot}/var/lib/cobbler/autoinstall_templates/

# Install kickstart entry point (only standard, atomic variants removed)
%{__install} -p -m 0755 snippets/standard_kickstart %{buildroot}/var/lib/cobbler/snippets/flossware
# Install modules (atomic module removed)
%{__install} -p -m 0755 snippets/modules/common %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__install} -p -m 0755 snippets/modules/defined_disk_partition %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__install} -p -m 0755 snippets/modules/disk_partition %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__install} -p -m 0755 snippets/modules/filesystem %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__install} -p -m 0755 snippets/modules/disk_partition_types/* %{buildroot}/var/lib/cobbler/snippets/flossware/modules/disk_partition_types
%{__install} -p -m 0755 snippets/options/* %{buildroot}/var/lib/cobbler/snippets/flossware/options
# Install sections
%{__install} -p -m 0755 snippets/sections/addon %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__install} -p -m 0755 snippets/sections/anaconda %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__install} -p -m 0755 snippets/sections/packages %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__install} -p -m 0755 snippets/sections/post %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__install} -p -m 0755 snippets/sections/pre %{buildroot}/var/lib/cobbler/snippets/flossware/sections

# Install section bodies (only standard, atomic variants removed)
%{__install} -p -m 0755 snippets/sections/post_body/standard %{buildroot}/var/lib/cobbler/snippets/flossware/sections/post_body

%preun

%clean
rm -rf %{buildroot}

%files
%attr(0755, root, root) /var/lib/cobbler/templates
%attr(0755, root, root) /var/lib/cobbler/autoinstall_templates
%attr(0755, root, root) /var/lib/cobbler/snippets/flossware

%changelog
* Thu May 22 2026 Modernization <github-action@noreply.com> 1.0-40
- BREAKING: Removed all Atomic Host support (discontinued upstream)
- Updated to systemctl from deprecated chkconfig (required for RHEL 10)
- Updated to authselect from deprecated authconfig (RHEL 9/10 compatible)
- Fixed modprobe configuration to use modprobe.d directory
- Added support for RHEL 10 and Fedora 40+
- Added Debian 11/12 and Ubuntu 22.04/24.04 preseed templates
- Switched deployment from baltorepo.com to packagecloud.io
- Modernized GitHub Actions workflow and build script
- Cleaned up deprecated spec file tags (Group, BuildRoot)
- Removed destructive pre-install hook
* Sat Sep 26 2020 Action <github-action@noreply.com> 1.0-37
- No changes.
* Sat Sep 26 2020 Action <github-action@noreply.com> 1.0-36
- No changes.
* Mon Aug 03 2020 Solenopsis <no-reply@solenopsis.org> 1.0-35
- No changes.
* Tue Jan 14 2020 Solenopsis <no-reply@solenopsis.org> 1.0-34
- Scot P. floess <sfloess@nc.rr.com>  N/A - fixed problem with rpmbuld/flossware.spec
* Tue Jan 14 2020 Solenopsis <no-reply@solenopsis.org> 1.0-33
- Scot P. floess <sfloess@nc.rr.com>  N/A - fixed problem with rpmbuld/flossware.spec
* Tue Jan 14 2020 Solenopsis <no-reply@solenopsis.org> 1.0-32
- Scot P. floess <sfloess@nc.rr.com>  N/A - fixed problem with rpmbuld/flossware.spec
* Mon Jan 13 2020 Solenopsis <no-reply@solenopsis.org> 1.0-31
- No changes.
* Wed Jul 10 2019 Solenopsis <no-reply@solenopsis.org> 1.0-30
- GitHub <noreply@github.com>  Create CODE_OF_CONDUCT.md
* Thu Jun 06 2019 Bot <no-reply@solenopsis.org> 1.0-29
- No changes.
* Thu Jun 06 2019 Solenopsis <no-reply@solenopsis.org> 1.0-28
- No changes.
* Thu Jun 06 2019 Bot <no-reply@solenopsis.org> 1.0-27
- No changes.
* Thu Jun 06 2019 Bot <no-reply@solenopsis.org> 1.0-26
- No changes.
* Thu Jan 10 2019 Solenopsis <no-reply@solenopsis.org> 1.0-25
- Scot P. Floess <sfloess@redhat.com>  NA - checkin to test github webhook
* Thu Dec 13 2018 Solenopsis <no-reply@solenopsis.org> 1.0-24
- Scot P. Floess <sfloess@redhat.com>  NA - Fedora Atomic installs were failing
* Thu Jul 12 2018 Solenopsis <no-reply@solenopsis.org> 1.0-23
- GitHub <noreply@github.com>  Update README.md
* Thu Jul 12 2018 Solenopsis <no-reply@solenopsis.org> 1.0-22
- GitHub <noreply@github.com>  Update README.md
* Thu Jul 12 2018 Solenopsis <no-reply@solenopsis.org> 1.0-21
- GitHub <noreply@github.com>  Update README.md
* Thu Jul 12 2018 Solenopsis <no-reply@solenopsis.org> 1.0-20
- GitHub <noreply@github.com>  Update README.md
* Thu Jul 12 2018 Solenopsis <no-reply@solenopsis.org> 1.0-19
- GitHub <noreply@github.com>  Update README.md
* Thu Jul 12 2018 Solenopsis <no-reply@solenopsis.org> 1.0-18
- GitHub <noreply@github.com>  Turning on plastic style for build status...
* Thu Jul 12 2018 Solenopsis <no-reply@solenopsis.org> 1.0-17
- GitHub <noreply@github.com>  Fixing the build status
* Thu Jul 12 2018 Solenopsis <no-reply@solenopsis.org> 1.0-16
- GitHub <noreply@github.com>  tryomg embeddable build status
* Wed Jul 11 2018 Solenopsis <no-reply@solenopsis.org> 1.0-15
- Scot P. Floess <sfloess@redhat.com>  NA - testing a web hook
* Mon Jan 15 2018 Solenopsis <no-reply@solenopsis.org> 1.0-14
- No changes.
* Mon Jan 15 2018 Solenopsis <no-reply@solenopsis.org> 1.0-13
- No changes.
* Sun Dec 10 2017 OpenShift <solenopsis@deadlypenguin.com> 1.0-12
- Scot P. Floess <sfloess@redhat.com>  NA - added in flossware-scripts
* Mon Aug 07 2017 OpenShift <solenopsis@deadlypenguin.com> 1.0-11
- Scot P. Floess <sfloess@redhat.com>  NA - disabling NetworkManager
* Sun Aug 28 2016 OpenShift <solenopsis@deadlypenguin.com> 1.0-10
- Scot P. Floess <sfloess@redhat.com>  Resolves #23 - processing LVM partitions now fixed and README.md denotes the new way to deal with LVM (using spaces vs commas)
* Sun Aug 28 2016 OpenShift <solenopsis@deadlypenguin.com> 1.0-9
- Scot P. Floess <sfloess@redhat.com>  Resolves #22 - common_kickstart is no longer needed
* Sun Aug 28 2016 OpenShift <solenopsis@deadlypenguin.com> 1.0-8
- Scot P. Floess <sfloess@redhat.com>  Resolves #21 - section variables are included and denoted correctly
* Sun Aug 28 2016 OpenShift <solenopsis@deadlypenguin.com> 1.0-7
- Scot P. Floess <sfloess@redhat.com>  Resolves #19 - all variables are preceeded with $
* Sun Aug 28 2016 OpenShift <solenopsis@deadlypenguin.com> 1.0-6
- Scot P. Floess <sfloess@redhat.com>  Resolves #20 - now have GPLv3 license in all source
* Sat Aug 27 2016 OpenShift <solenopsis@deadlypenguin.com> 1.0-5
- Scot P. Floess <sfloess@redhat.com>  NA - type-o in README.md
- Scot P. Floess <sfloess@redhat.com>  NA - added yum installation information to the README.md
* Sat Aug 27 2016 OpenShift <solenopsis@deadlypenguin.com> 1.0-4
- No changes.
* Sat Aug 27 2016 OpenShift <solenopsis@deadlypenguin.com> 1.0-3
- No changes.
* Sat Aug 27 2016 OpenShift <solenopsis@deadlypenguin.com> 1.0-2
- Scot P. Floess <sfloess@redhat.com>  NA - adjusting spec file as the inital version auto revd was broken
* Sat Aug 27 2016 OpenShift <solenopsis@deadlypenguin.com> 1.0-1
- No changes.