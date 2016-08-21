#version=RHEL7
# System authorization information
auth --enableshadow --passalgo=sha512

# Run the Setup Agent on first boot
#firstboot --enable
firstboot --disable
ignoredisk --only-use=vda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=$hostname
# OSTree setup
ostreesetup --osname="centos-atomic-host" --remote="centos-atomic-host" --url="file:///install/ostree" --ref="centos-atomic-host/7/x86_64/standard" --nogpg
#url --url="http://host-2/cobbler/ks_mirror/centos-7-atomic-distro"
url --url=$tree
# Root password
rootpw --iscrypted $6$VMGZ1MnOqgnG.0ie$gAmG2iPW7bZcK6aTN6omYz0o4R29BVRxWOKwWmDGn19oHHcgM17Nmp85ztCfzYCFoGhw5h2yhWg6IQMKvxX1i0
# System services
services --disabled="cloud-init,cloud-config,cloud-final,cloud-init-local"
# System timezone
timezone America/New_York --isUtc
# System bootloader configuration
bootloader --location=mbr --boot-drive=vda
autopart --type=lvm
# Partition clearing information
clearpart --none --initlabel 

%post --erroronfail
fn=/etc/ostree/remotes.d/centos-atomic-host.conf; if test -f ${fn} && grep -q -e '^url=file:///install/ostree' ${fn}$; then rm ${fn}; fi
%end

