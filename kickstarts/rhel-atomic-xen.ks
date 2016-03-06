#version=RHEL7
# System authorization information
auth --enableshadow --passalgo=sha512

text

# Run the Setup Agent on first boot
#firstboot --enable
firstboot --disable
#ignoredisk --only-use=xvda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
#network  --hostname=$hostname --bootproto=dhcp --device=ens3 --onboot=off --ipv6=auto
network  --hostname=$hostname --bootproto=dhcp --device=eth0 --onboot=off --ipv6=auto
#network  --bootproto=dhcp --device=eth0 --onboot=off --ipv6=auto
#network  --hostname=$hostname
# OSTree setup
#ostreesetup --osname="rhel-atomic-host" --remote="rhel-atomic-host" --url="file:///install/ostree" --ref="rhel-atomic-host/7/x86_64/standard" --nogpg
ostreesetup --osname="rhel-atomic-host" --remote="rhel-atomic-host" --url="file:///install/ostree" --ref="rhel-atomic-host/7/x86_64/standard" --nogpg
#ostreesetup --osname="rhel-atomic-host" --remote="rhel-atomic-host" --url="http://admincloud/cblr/atomic/RHEL-7.2-Atomic-x86_64/ostree" --ref="rhel-atomic-host/7/x86_64/standard" --nogpg
# url --url=http://admincloud/cblr/links/RHEL-7.1-x86_64
#url --url="http://admincloud/cblr/links/RHEL-7.2-x86_64"
url --url=$tree
#url --url=$tree
# Root password
rootpw --iscrypted $6$dg9ndNXpPXcPaqKQ$P1v9Gfai5gxjH2th3v1b/KxErKjCVEZfCX8z7SB8fZ/zvG6oUgblb/NwLz7PLLK7q12nv4bJvNq0sUHMKyriN.
# System services
services --disabled="cloud-init,cloud-config,cloud-final,cloud-init-local"
# System timezone
timezone America/New_York --isUtc

bootloader --location=mbr --boot-drive=xvda
#autopart --type=lvm
#autopart
# Partition clearing information
#clearpart --none --initlabel 
clearpart --all

part swap --fstype="swap" --recommended
part /boot --fstype="ext3" --recommended --size="512"
part / --fstype="xfs" --recommended --size="1024" --grow

# System bootloader configuration
#bootloader --location=mbr --boot-drive=xvda
#autopart --type=lvm
# Partition clearing information
#clearpart --linux --initlabel --drives=xvda


# System bootloader configuration
#bootloader --location=mbr --boot-drive=xvda
#autopart
#autopart --type=plain --fstype=ext4
#autopart --type=lvm
# Partition clearing information
#clearpart --none --initlabel 
#clearpart --all

%post --erroronfail
rm -f /etc/ostree/remotes.d/*.conf
%end

