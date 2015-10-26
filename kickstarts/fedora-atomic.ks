#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512

# OSTree setup
ostreesetup --osname="fedora-atomic" --remote="fedora-atomic" --url="file:////run/install/repo/content/repo" --ref="fedora-atomic/f22/x86_64/docker-host" --nogpg
# Use graphical install
graphical
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=vda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=localhost.localdomain
# Root password
rootpw --iscrypted $6$CNFuYCs27KWQpt.p$Cdw5y6ILKyeYQJ.O2VPMJRgGTdQpDUQUioMDayl1GQeTdkYADSHk9XoaET6zzmuEk7XTXSuJE7vIWKLcP2iol1
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
rm -f /etc/ostree/remotes.d/fedora-atomic.conf
ostree remote add --set=gpg-verify=false fedora-atomic 'http://dl.fedoraproject.org/pub/fedora/linux/atomic/22/'
%end

%addon com_redhat_kdump --disable --reserve-mb='128'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=50 --notstrict --nochanges --emptyok
pwpolicy user --minlen=6 --minquality=50 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=50 --notstrict --nochanges --emptyok
%end
