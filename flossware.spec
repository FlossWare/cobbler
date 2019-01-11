Summary: A set of kickstarts and snippets for cobbler
Name: flossware-cobbler
Version:  1.0
Release: 25
URL: https://github.com/FlossWare/cobbler
License: GPLv3
Group: Applications/Systems
Source0: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: noarch
#Requires: cobbler

%description
A set of kickstarts and snippets for cobbler.

%prep
%setup -q

%build

%install
%{__rm} -rf %{buildroot}
%{__mkdir_p} %{buildroot}/var/lib/cobbler/kickstarts
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/modules/disk_partition_types
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/options
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/sections/addon_body
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/sections/anaconda_body
%{__mkdir_p} %{buildroot}/var/lib/cobbler/snippets/flossware/sections/post_body

%{__install} -p -m 0755 kickstarts/* %{buildroot}/var/lib/cobbler/kickstarts/
%{__install} -p -m 0755 snippets/*_kickstart %{buildroot}/var/lib/cobbler/snippets/flossware
%{__install} -p -m 0755 snippets/modules/atomic %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__install} -p -m 0755 snippets/modules/common %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__install} -p -m 0755 snippets/modules/defined_disk_partition %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__install} -p -m 0755 snippets/modules/disk_partition %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__install} -p -m 0755 snippets/modules/filesystem %{buildroot}/var/lib/cobbler/snippets/flossware/modules
%{__install} -p -m 0755 snippets/modules/disk_partition_types/* %{buildroot}/var/lib/cobbler/snippets/flossware/modules/disk_partition_types
%{__install} -p -m 0755 snippets/options/* %{buildroot}/var/lib/cobbler/snippets/flossware/options
%{__install} -p -m 0755 snippets/sections/addon %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__install} -p -m 0755 snippets/sections/anaconda %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__install} -p -m 0755 snippets/sections/packages %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__install} -p -m 0755 snippets/sections/post %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__install} -p -m 0755 snippets/sections/pre %{buildroot}/var/lib/cobbler/snippets/flossware/sections
%{__install} -p -m 0755 snippets/sections/addon_body/* %{buildroot}/var/lib/cobbler/snippets/flossware/sections/addon_body
%{__install} -p -m 0755 snippets/sections/anaconda_body/* %{buildroot}/var/lib/cobbler/snippets/flossware/sections/anaconda_body
%{__install} -p -m 0755 snippets/sections/post_body/* %{buildroot}/var/lib/cobbler/snippets/flossware/sections/post_body

%pre
rm -f /var/lib/cobbler/kickstarts/flossware_*.ks
rm -rf /var/lib/cobbler/snippets/flossware

%preun

%clean
rm -rf %{buildroot}

%files
%attr(0755, root, root) /var/lib/cobbler/kickstarts/flossware_*.ks
%attr(0755, root, root) /var/lib/cobbler/snippets/flossware/*

%changelog
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