#version=RHEL7
# System authorization information
auth --enableshadow --passalgo=sha512
# Install OS instead of upgrade
install
# Reboot after installation
reboot
# Use text mode install
text
# Firewall configuration
firewall --disabled
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
# old format: keyboard us
# new format:
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8
# Installation logging level
logging --level=debug
# Network information
network  --bootproto=dhcp --device=enp0s3 --ipv6=auto
network  --hostname=localhost.localdomain
# OSTree setup
ostreesetup --osname="centos-atomic-host" --remote="centos-atomic-host" --url="file:///install/ostree" --ref="centos-atomic-host/7/x86_64/standard" --nogpg
# Root password
rootpw --plaintext cobbler
# SELinux configuration
selinux --disabled
# System services
services --disabled="cloud-init,cloud-config,cloud-final,cloud-init-local"
# Do not configure the X Window System
skipx
# System timezone
timezone America/New_York --isUtc
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
autopart --type=lvm
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel 

%post --erroronfail
fn=/etc/ostree/remotes.d/centos-atomic-host.conf; if test -f ${fn} && grep -q -e '^url=file:///install/ostree' ${fn}$; then rm ${fn}; fi
%end

