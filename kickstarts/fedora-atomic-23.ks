#version=DEVEL
# System authorization information
text
auth --enableshadow --passalgo=sha512
# OSTree setup
url --url=$tree
# ostreesetup --osname="fedora-atomic" --remote="fedora-atomic" --url="file:////run/install/repo/content/repo" --ref="fedora-atomic/f23/x86_64/docker-host" --nogpg
#ostreesetup --osname="fedora-atomic" --remote="fedora-atomic" --url="file:////run/install/repo/content" --ref="fedora-atomic/f23/x86_64/docker-host" --nogpg
ostreesetup --osname="fedora-atomic" --remote="fedora-atomic" --url="$tree/content/repo" --ref="fedora-atomic/f23/x86_64/docker-host" --nogpg
# ostreesetup --osname="fedora-atomic" --remote="fedora-atomic" --url="https://dl.fedoraproject.org/pub/fedora/linux/atomic/23" --ref="fedora-atomic/f23/x86_64/docker-host" --nogpg
# ostreesetup --osname="rhel-atomic-host" --remote="rhel-atomic-host" --url="file:///install/ostree" --ref="rhel-atomic-host/7/x86_64/standard" --nogpg
# Use graphical install
graphical
# Run the Setup Agent on first boot
firstboot --enable
#ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=ens3 --ipv6=auto --activate
network  --hostname=localhost.localdomain
# Root password
rootpw --iscrypted $6$KZhY0TlBxtPD8ZP5$V4H4KBHjQD/xPwk1Q/ov02MWEj4A7kEqkV0Zbeckx854SdA2tMlRWO6nLWxAW7yZ1oAb.x.YMYS1aFk9ip4gF1
# System services
services --disabled="cloud-init,cloud-config,cloud-final,cloud-init-local"
# System timezone
timezone America/New_York --isUtc
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
autopart --type=lvm
# Partition clearing information
clearpart --none --initlabel

%post --erroronfail
rm -f /etc/ostree/remotes.d/fedora-atomic.conf
ostree remote add --set=gpg-verify=false fedora-atomic 'http://dl.fedoraproject.org/pub/fedora/linux/atomic/23/'
%end

%addon com_redhat_kdump --disable --reserve-mb='128'

%end

%anaconda
pwpolicy root --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy user --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=0 --minquality=1 --notstrict --nochanges --emptyok
%end
