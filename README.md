# FlossWare Cobbler Kickstarts and Snippets

Welcome to the FlossWare [Cobbler](http://cobbler.github.io/) [kickstarts](http://cobbler.github.io/manuals/2.6.0/3/5_-_Kickstart_Templating.html) and [snippets](http://cobbler.github.io/manuals/2.6.0/3/6_-_Snippets.html) project!

![Build Status](http://flossware.no-ip.org:58080/buildStatus/icon?job=FlossWare-cobbler&style=plastic)

## Concepts

### Kickstarts

All defined [kickstarts](https://github.com/FlossWare/cobbler/tree/master/templates) are simple wrappers that call a corresponding [snippet](https://github.com/FlossWare/cobbler/tree/master/snippets):

* [flossware_standard.ks](https://github.com/FlossWare/cobbler/blob/master/templates/flossware_standard.ks): Standard kickstart template for modern Linux distributions.

**Supported Distributions:**
- Fedora 38, 39, 40+
- RHEL 8.x, 9.x, 10.x
- Rocky Linux 8.x, 9.x, 10.x
- AlmaLinux 8.x, 9.x, 10.x
- CentOS Stream 8, 9, 10

**Note on Fedora CoreOS:** Fedora CoreOS uses Ignition for configuration, not traditional kickstart. See the [Fedora CoreOS Support](#fedora-coreos-support) section below for provisioning guidance.

**Note on Atomic Host:** The old Atomic Host kickstart templates (Fedora/CentOS/RHEL Atomic) have been **removed** as Atomic Host has been discontinued. For container-optimized systems, use Fedora CoreOS or RHEL CoreOS instead.

### Snippets

[Snippets](https://github.com/FlossWare/cobbler/tree/master/snippets) represent the bulk of all work.  We considered putting some templatization in the [kickstarts](https://github.com/FlossWare/cobbler/tree/master/kickstarts) but felt that keeping that functionality together made the most logical sense.  [Snippets](https://github.com/FlossWare/cobbler/tree/master/snippets) are broken up into the categories found below.  Each concept (with the exception of the Kickstart Counterparts) is contained in a directory of that name.

#### Kickstart Counterparts

As mentioned above, all [kickstarts](https://github.com/FlossWare/cobbler/tree/master/templates) call a corresponding [snippet](https://github.com/FlossWare/cobbler/tree/master/snippets).  The job of these snippets is to set variables (where appropriate) and coordinate assembly of the [kickstart](http://cobbler.github.io/manuals/2.6.0/3/5_-_Kickstart_Templating.html) result as a whole:

* [standard_kickstart](https://github.com/FlossWare/cobbler/blob/master/snippets/standard_kickstart): For Fedora, RHEL 8/9/10, and derivatives

#### Options

The [option snippets](https://github.com/FlossWare/cobbler/tree/master/snippets/options) represent an [option](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/sect-kickstart-syntax.html#sect-kickstart-commands) that one may find in a kickstart file - for example [autopart](https://github.com/FlossWare/cobbler/blob/master/snippets/options/autopart) for automatically creating partitions.

Should an option afford parameters, simply denoting the name of the option in your ```ksmeta``` as the name with the value being what should end up in the resultant [kickstart](http://cobbler.github.io/manuals/2.6.0/3/5_-_Kickstart_Templating.html).  As an example, let's assume you wish to set the language to ```en_US``` in your [kickstart](http://cobbler.github.io/manuals/2.6.0/3/5_-_Kickstart_Templating.html):

```bash
ksmeta='lang="en_US"'
```

This will result in the kickstart to:

```bash
lang en_US
```

#### Modules

[Module snippets](https://github.com/FlossWare/cobbler/tree/master/snippets/modules) represent logically related snippets contained in a file (think of them like a [subroutine](https://en.wikipedia.org/wiki/Subroutine)):
* [atomic](https://github.com/FlossWare/cobbler/blob/master/snippets/modules/atomic): adds the ```ostreesetup``` option and disables some services.
* [common](https://github.com/FlossWare/cobbler/blob/master/snippets/modules/common): layout "common" kickstarting options, like ```text```, ```skipx```, etc.
* [defined_disk_partition](https://github.com/FlossWare/cobbler/blob/master/snippets/modules/defined_disk_partition): if not using ```autopart```, will layout a "good enough" disk structure.  If you denote ```lvmDisks``` as a ```ksmeta``` variable whose values are the disks to use, it will layout [LVM partitioning](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Logical_Volume_Manager_Administration/LVM_GUI.html) for you.  As an example ```ksmeta='lvmDisks="sda sdb sdc"'``` will use disks ```sda```, ```sdb``` and ```sdc``` as one [LVM](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Logical_Volume_Manager_Administration/LVM_GUI.html) partition spanning all those disks.
* [disk_partition](https://github.com/FlossWare/cobbler/blob/master/snippets/modules/disk_partition): "common" disk partitioning snippets.  If [autopart](https://github.com/FlossWare/cobbler/blob/master/snippets/options/autopart) is a ```ksmeta``` variable, it will use that [option](https://github.com/FlossWare/cobbler/tree/master/snippets/options) otherwise it will use use the [defined_disk_partition snippet](https://github.com/FlossWare/cobbler/blob/master/snippets/modules/defined_disk_partition).  
* [filesystem](https://github.com/FlossWare/cobbler/blob/master/snippets/modules/filesystem): "common" file system snippet for [zerombr](https://github.com/FlossWare/cobbler/blob/master/snippets/options/zerombr), [ignoredisk](https://github.com/FlossWare/cobbler/blob/master/snippets/options/ignoredisk) and [bootloader](https://github.com/FlossWare/cobbler/blob/master/snippets/options/bootloader) options as well as calling the [disk_partition snippet](https://github.com/FlossWare/cobbler/blob/master/snippets/modules/disk_partition).

*Please note we are investigating using [Cheetah defs](http://pythonhosted.org/Cheetah/users_guide/inheritanceEtc.html#def), per [issue #18](https://github.com/FlossWare/cobbler/issues/18), as a replacement for modules.*

### Fedora CoreOS Support

Fedora CoreOS uses [Ignition](https://coreos.github.io/ignition/) for system configuration instead of traditional kickstart/Anaconda. To provision Fedora CoreOS with Cobbler:

1. Create an Ignition configuration using [Butane](https://coreos.github.io/butane/) (formerly Fedora CoreOS Config)
2. Serve the Ignition file via HTTP from your Cobbler server
3. Configure Cobbler to pass the Ignition URL via kernel parameters:

```bash
cobbler system edit --name=fcos-node1 \
    --kopts="ignition.config.url=http://cobbler.example.com/ignition/node1.ign"
```

For more information, see the [Fedora CoreOS documentation](https://docs.fedoraproject.org/en-US/fedora-coreos/) on creating Ignition configurations.

**Important:** Fedora CoreOS uses a fundamentally different provisioning model than traditional kickstart. The kickstart templates in this project do not apply to Fedora CoreOS.

### Migration Guide

#### Upgrading from Atomic Host

**Atomic Host (Fedora/CentOS/RHEL Atomic) has been discontinued** and replaced by:
- **Fedora CoreOS**: For Fedora-based container-optimized systems
- **RHEL CoreOS**: For OpenShift/RHEL-based container systems (primarily for OpenShift)

If you were using the old `flossware_*_atomic.ks` templates:

1. **For Fedora CoreOS**: Use Ignition configuration (see [Fedora CoreOS Support](#fedora-coreos-support) above)
2. **For standard RHEL/Fedora workloads**: Use `flossware_standard.ks` which now supports RHEL 8/9/10 and Fedora 38+

#### Service Management Changes

The kickstarts have been updated to use modern `systemctl` commands instead of deprecated `chkconfig` (removed in Fedora 38+ and not present in RHEL 10):

**Old behavior** (chkconfig - hardcoded, disabled NetworkManager):
```bash
# NetworkManager was always disabled
# network service was always enabled
```

**New behavior** (systemctl - configurable):
```bash
# NetworkManager is now enabled by default (modern standard)
# To use legacy network service instead:
ksmeta='useNetworkManager="false"'
```

#### Authentication Configuration

The `authconfig` tool has been removed in RHEL 9+ and Fedora, replaced with `authselect`. The kickstart now automatically detects and uses the appropriate tool:

**Backward compatible usage:**
```bash
ksmeta='authconfig="--enablesssd --enablesssdauth"'
# Automatically uses authselect on RHEL 9/10/Fedora or authconfig on RHEL 8
```

The kickstart will:
- Check for `authselect` first (RHEL 9/10, Fedora 38+)
- Fall back to `authconfig` if available (RHEL 8, older systems)
- Your existing `authconfig` ksmeta parameters continue to work

**Note:** RHEL 10 only has `authselect` available; `authconfig` has been completely removed.

#### Modprobe Configuration

Configuration now uses `/etc/modprobe.d/` directory instead of deprecated `/etc/modprobe.conf`:

```bash
# maxLoop configuration now creates /etc/modprobe.d/loop.conf
ksmeta='maxLoop="64"'
```

#### RHEL 10 Compatibility

**RHEL 10 is now GA** and fully supported. All modernizations in this project are compatible with RHEL 10:

- ✅ **systemctl**: RHEL 10 uses systemd (chkconfig is not available)
- ✅ **authselect**: RHEL 10 only includes authselect; authconfig has been removed
- ✅ **NetworkManager**: Default network management tool in RHEL 10
- ✅ **modprobe.d**: Standard configuration location
- ✅ **DNF5**: RHEL 10 uses DNF5 by default (kickstart repo syntax unchanged)

The kickstart templates will work without modification on RHEL 10, Rocky Linux 10, AlmaLinux 10, and CentOS Stream 10.

**Tested with:** RHEL 10 GA and derivatives. No code changes required from RHEL 9 kickstarts.

#### Sections

[Section snippets](https://github.com/FlossWare/cobbler/tree/master/snippets/sections) correspond to sections in kickstarts like [package](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/sect-kickstart-syntax.html#sect-kickstart-packages), [pre](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/sect-kickstart-syntax.html#sect-kickstart-preinstall), [post](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/sect-kickstart-syntax.html#sect-kickstart-postinstall) and [add ons](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/sect-kickstart-syntax.html#sect-kickstart-addon).  To define values on [sections](https://github.com/FlossWare/cobbler/tree/master/snippets/sections):
* For the section itself, simply define a ```ksmeta``` variable whose name represents the section and whose value is what to put on the section.  As an example:   ```ksmeta='post="--errorfail"'```
* To provide a body, denote a [snippet](http://cobbler.github.io/manuals/2.6.0/3/6_-_Snippets.html) in your ```ksmeta``` variables that is named ```[section]_body```.  As an example:   ```ksmeta='post_body="flossware/sections/post_body/centos_atomic"'```

## How To

### Installing

#### Manual

Clone this git repo and:
* copy the contents of [kickstarts](https://github.com/FlossWare/cobbler/tree/master/kickstarts) to ```/var/lib/cobbler/kickstarts```.
* create a ```/var/lib/cobbler/snippets/flossware``` directory.
* copy the contents of [snippets](https://github.com/FlossWare/cobbler/tree/master/snippets) to ```/var/lib/cobbler/snippets/flossware```.

#### DNF/Yum Install

To install via DNF/Yum, enable the FlossWare Cobbler repository from packagecloud.io:

**Quick setup script:**
```bash
curl -s https://packagecloud.io/install/repositories/flossware/cobbler/script.rpm.sh | sudo bash
sudo dnf install flossware-cobbler
```

**Manual setup:**

For RHEL/Rocky/AlmaLinux/CentOS:
```bash
# Create repo file
sudo tee /etc/yum.repos.d/flossware-cobbler.repo <<EOF
[flossware-cobbler]
name=FlossWare Cobbler Repository
baseurl=https://packagecloud.io/flossware/cobbler/el/\$releasever/\$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/flossware/cobbler/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF

sudo dnf install flossware-cobbler
```

For Fedora:
```bash
# Create repo file
sudo tee /etc/yum.repos.d/flossware-cobbler.repo <<EOF
[flossware-cobbler]
name=FlossWare Cobbler Repository
baseurl=https://packagecloud.io/flossware/cobbler/fedora/\$releasever/\$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/flossware/cobbler/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF

sudo dnf install flossware-cobbler
```

### Default Use

By default, the [kickstarts](https://github.com/FlossWare/cobbler/tree/master/templates) and [snippets](https://github.com/FlossWare/cobbler/tree/master/snippets) can be used upon deployment with no additions to ```ksmeta```.

**Default behavior:**
- Root password: `cobbler` (you should change this!)
- NetworkManager: Enabled (modern default for RHEL 8/9/10/Fedora)
- SSH: Enabled
- Authentication: System defaults

**To customize, use ksmeta variables** (see examples below).

### Define the Root Password

* Using ```plaintext```:  ```ksmeta='rootpw="--plaintext mypassword"'```
* Using ```encrypted```:  ```ksmeta='rootpw="--iscrypted laskdjfaklkmcLKMCSDNKJANDF"'```

### Layout LVM partitions

Simply provide a space or comma separated list of the disks to use in the partition as a ```ksmeta``` variable ```lvmDisks```.  As an example assume you wish to use ```sda```, ```sdc``` and ```sdd```:   ```ksmeta='lvmDisks="sda sdc sdd"'```

### Use Legacy Network Service

By default, NetworkManager is enabled (modern standard for RHEL 8/9/10 and Fedora 38+). To use the legacy network service instead:

```bash
ksmeta='useNetworkManager="false"'
```

This will enable the `network` service and disable NetworkManager.

## Examples

For more concrete examples, please see [Flossy's Cobbler Scripts](https://github.com/sfloess/scripts/blob/master/bash/cobbler.sh) for his home network.