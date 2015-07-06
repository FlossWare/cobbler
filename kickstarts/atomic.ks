lang en_US.UTF-8
keyboard us
timezone America/New_York
rootpw --plaintext 'cobbler'

firstboot --disable

zerombr

ignoredisk --only-use=sda
clearpart --all --initlabel
bootloader --location=mbr --boot-drive=sda
autopart --type=lvm

# Network information
network  --bootproto=dhcp --device=enp0s3 --onboot=on --ipv6=auto

logging --level=debug
firewall --disabled
selinux --disabled

auth --useshadow --enablemd5 --enablenis --nisdomain=flossware.com

skipx

install

reboot

# %pre
# $kickstart_start
# %end

%include /usr/share/anaconda/interactive-defaults.ks

# %post
# authconfig --update nisdomain=flossware.com

# $kickstart_done
# %end
