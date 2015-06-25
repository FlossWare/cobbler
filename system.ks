## Simplifying the computation of operating system name
## and version...

#if $getVar('$operatingSystem', '') == '' and $getVar('$os_version', '') != ''
    #if $os_version.startswith('fedora')
        #set $operatingSystem = 'fedora'
    #else if $os_version.startswith('rhel')
        #set $operatingSystem = 'rhel'
    #end if
#end if

#if $getVar('$operatingSystemVersion', '') == ''
#set $operatingSystemVersion = float($os_version.replace($operatingSystem, '0'))
#end if

## Networking stuff...

#set $networkDevice = $getVar('$networkDevice', 'eth0')


#platform=x86, AMD64, or Intel EM64T
# System authorization information
#if $getVar('$auth', '') != ''
auth $auth.replace(',', ' ')
#end if

# System bootloader configuration
bootloader --location=mbr

## Should we clearout the master boot record?

#if $getVar('$noZerombr', '') == ''
# Clear the Master Boot Record
zerombr
#end if

# Use text mode install
text

# Firewall configuration
firewall --$getVar('$firewall', 'disabled')

# Run the Setup Agent on first boot
firstboot --$getVar('$firstboot', 'disable')

## By default, we will use the US keyboard type...

# System keyboard
keyboard $getVar('$keyboard', 'us')

## By default we will use the US as a system language

# System language
lang $getVar('$lang', 'en_US')

## By default we will use a debug log level...

# Installation logging level
logging --level=$getVar('$loggingLevel', 'debug')

# Use network installation
url --url=$tree

# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza

## By default use DHCP and eth0...

# Network information
#if $getVar('$network', '') != ''
network --$network.replace('&&', ' --')
#else
network --hostname=$hostname --bootproto=dhcp --device=$networkDevice
#end if

# Reboot after installation
reboot

#if $operatingSystem == 'rhel' and $operatingSystemVersion < 6.0
    #set $unencryptedPasswordOption = ''
#else
    #set $unencryptedPasswordOption = '--plaintext'
#end if    

# Root password
#if $getVar('$encryptedRootPassword', '') != ''
rootpw --iscrypted $encryptedRootPassword
#else
rootpw $unencryptedPasswordOption $getVar('$rootPassword', 'cobbler')
#end if

# SELinux configuration
selinux --$getVar('$selinux', 'disabled')

# Do not configure the X Window System
skipx

## By default, use NY as the time zone...

# System timezone
timezone  $getVar('$timezone', 'America/New_York')

# Install OS instead of upgrade
install

#if $getVar('$ignoredisk', '') != ''
ignoredisk --drives=$ignoredisk
#end if

# Disk partitioning information

#if $getVar('$clearpart', '') != ''
clearpart --$clearpart.replace('&&', ' --')
#else
# clearpart --linux
clearpart --all
#end if

#if $operatingSystem == 'fedora' and $operatingSystemVersion > 15
part biosboot --fstype=biosboot --size=$getVar('biosbootPartitionSize', '1')
#end if
#if $getVar('$bootDisk','') != ''
part /boot --fstype="$getVar('$bootPartition', 'ext3')" --recommended --size=$getVar('bootPartitionSize', '250') --ondisk=$bootDisk
#else
part /boot --fstype="$getVar('$bootPartition', 'ext3')" --recommended --size=$getVar('bootPartitionSize', '250')
#end if
#if $getVar('$diskPartitions', '') 
part $diskPartitions.replace(',', '\\npart ').replace('&&',' ')
#end if

## Only dealing with LVM if requested!

#if $getVar('$lvmDisks', '') != ''
    #set allPv = ''
	#set $allLvmDisks = $lvmDisks.split( ',' )

	#set $pv = 1

	#for $anLvmDisk in $allLvmDisks
part pv.$pv --grow --ondisk=$anLvmDisk --size=$getVar('lvmPartitionSize', '10')
		#set $allPv = $allPv + ' pv.' + str($pv)
		#set $pv += 1
	#end for

volgroup VolGroup00 $allPv
logvol swap --fstype="swap" --name=lv_swap --vgname=VolGroup00 --recommended
logvol / --fstype="$getVar('$rootPartition', 'ext3')" --name=lv_root --vgname=VolGroup00 --size=$getVar('rootPartitionSize', '1024') --recommended --grow
#else
#if $getVar('$swapDisk','') != ''
part swap --fstype="swap" --recommended --ondisk=$swapDisk
#else
part swap --fstype="swap" --recommended
#end if
#if $getVar('$rootDisk','') != ''
part / --fstype="$getVar('$rootPartition', 'ext3')" --size=$getVar('rootPartitionSize', '1024') --recommended --grow --ondisk=$rootDisk
#else
part / --fstype="$getVar('$rootPartition', 'ext3')" --size=$getVar('rootPartitionSize', '1024') --recommended --grow
#end if
#end if

%pre
$kickstart_start
%end

%packages
@core
#if $getVar('$packages', '') != ''
$packages.replace(',', '\\n')
#end if
%end

%post

# grep HOSTNAME /etc/sysconfig/network
# if [ $? == 0 ]
# then
#     sed -i -e "s/\(HOSTNAME=\).*/\1$hostname/" /etc/sysconfig/network
# else
#     echo "HOSTNAME=$hostname" >> /etc/sysconfig/network
# fi

# grep NISDOMAIN /etc/sysconfig/network
# if [ $? == 0 ]
# then
#     sed -i -e "s/\(NISDOMAIN=\).*/\1flossware.com/" /etc/sysconfig/network
# else
#     echo "NISDOMAIN=flossware.com" >> /etc/sysconfig/network
# fi

# grep DHCP_HOSTNAME /etc/sysconfig/network-scripts/ifcfg-$networkDevice
# if [ $? == 0 ] 
# then
#     sed -i -e "s/\(DHCP_HOSTNAME=\).*/\1$hostname/" /etc/sysconfig/network-scripts/ifcfg-eth0
# else
#     echo "DHCP_HOSTNAME=$hostname" >> /etc/sysconfig/network-scripts/ifcfg-eth0
# fi

# sed -i -e "s/\(^hosts:\).*/\1      files dns/" /etc/nsswitch.conf

#if $getVar('$isGraphical', '') != ''  
if [ -d /lib/systemd/system ]
then
    rm -rf /etc/systemd/system/default.target
    ln -s /lib/systemd/system/graphical.target /etc/systemd/system/default.target

#	rm -rf /lib/systemd/system/default.target
#	ln -s /lib/systemd/system/graphical.target /lib/systemd/system/default.target
else
	sed -i -e "s/\(^id:\).*/\15:initdefault:/" /etc/inittab
fi
#else
if [ -d /lib/systemd/system ]
then
	rm -rf /lib/systemd/system/default.target
	ln -s /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
fi
#end if

#if $getVar('$enableInitScripts','') == ''
for aScript in /etc/init.d/*
do
        /sbin/chkconfig `basename $aScript` off
done
#end if

#  $yum_config_stanza

/sbin/chkconfig --add network
/sbin/chkconfig network on

/sbin/chkconfig --add sshd
/sbin/chkconfig sshd on

/sbin/chkconfig --add puppet
/sbin/chkconfig puppet on

ln -s /home/root/ssh /root/.ssh

/bin/dbus-uuidgen > /var/lib/dbus/machine-id

#if $getVar('$maxLoop', '') != ''
    echo "options loop max_loop=$maxLoop" >> /etc/modprobe.conf
#end if

#if $operatingSystem == 'fedora' and $operatingSystemVersion > 15.0
cp /boot/grub2/grub.cfg /boot/grub
/bin/sed -i -e "s/set default.*/set default=\"0\"/" /boot/grub/grub.cfg
#end if

#if $getVar('$authconfig', '') != ''
/usr/sbin/authconfig --update $authconfig
#end if

$kickstart_done

%end
