#version=RHEL7
# System authorization information
auth --enableshadow --passalgo=sha512

# Use CDROM installation media
cdrom
# Use graphical install
graphical
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=enp0s25 --onboot=off --ipv6=auto
network  --hostname=localhost.localdomain
repo --name="Server-HighAvailability" --baseurl=file:///run/install/repo/addons/HighAvailability
repo --name="Server-ResilientStorage" --baseurl=file:///run/install/repo/addons/ResilientStorage
# Root password
rootpw --iscrypted $6$YjZOE7m0jGeOSZaF$nRmbrxcbpw/ZDwLKSiHi96hTWB3CIfyvXNzcbIFkbYAFlNqepR7BCRsYAco5wmTxY33cOnU5MYAq/XNzZAUcs.
# System timezone
timezone America/New_York --isUtc
user --groups=wheel --homedir=/home/sfloess --name=sfloess --password=$6$oUquNy4gEP1DGkwv$aPWm7nfFPikUy8IX07yRyzo6Z3CRc.854RE6L/pE/fm/xOJ.ZKlaulX/eecNZGsdYd9lcKk20wVF5JvPI/Z/u. --iscrypted --gecos="Scot P. Floess"
# X Window System configuration information
xconfig  --startxonboot
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
autopart --type=lvm
# Partition clearing information
clearpart --all --initlabel --drives=sda

%packages
@base
@core
@desktop-debugging
@development
@dial-up
@fonts
@gnome-desktop
@guest-agents
@guest-desktop-agents
@input-methods
@internet-browser
@java-platform
@kde-desktop
@multimedia
@performance
@print-client
@virtualization-client
@virtualization-hypervisor
@virtualization-tools
@x11
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end
