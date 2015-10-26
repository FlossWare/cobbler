#version=RHEL7
# System authorization information
auth --enableshadow --passalgo=sha512

# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=vda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=$hostname
# OSTree setup
ostreesetup --osname="rhel-atomic-host" --remote="rhel-atomic-host" --url="file:///install/ostree" --ref="rhel-atomic-host/7/x86_64/standard" --nogpg
url --url=$tree
# Root password
rootpw --iscrypted $6$ItvFd.oCON0/MHjN$7Kb3A4jdRpAQz0PWY96GGhbuluFy9KgyBj5SIITQrIq9BU9ODQ0cHHL6eH5OyoVv1vKqgtS47GLDPBED/eXgA/
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
rm -f /etc/ostree/remotes.d/rhel-atomic-host.conf
%end

