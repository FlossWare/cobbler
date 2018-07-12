# FlossWare Cobbler Kickstarts and Snippets

Welcome to the FlossWare [Cobbler](http://cobbler.github.io/) [kickstarts](http://cobbler.github.io/manuals/2.6.0/3/5_-_Kickstart_Templating.html) and [snippets](http://cobbler.github.io/manuals/2.6.0/3/6_-_Snippets.html) project!

[![Build Status](http://flossware.no-ip.org:58080/buildStatus/icon?job=FlossWare-cobbler)](http://flossware.no-ip.org:58080/job/FlossWare-cobbler/?style=plastic)

## Concepts

### Kickstarts

All defined [kickstarts](https://github.com/FlossWare/cobbler/tree/master/kickstarts) are simple wrappers that call a corresponding [snippet](https://github.com/FlossWare/cobbler/tree/master/snippets) of a similar name (without the ```flossware_``` prefix and ```.ks``` file extension):
* [flossware_centos_atomic.ks](https://github.com/FlossWare/cobbler/blob/master/kickstarts/flossware_centos_atomic.ks):  kickstarting template for CentOS Atomic.
* [flossware_fedora_atomic.ks](https://github.com/FlossWare/cobbler/blob/master/kickstarts/flossware_fedora_atomic.ks):  kickstarting template for Fedora Atomic.
* [flossware_rhel_atomic.ks](https://github.com/FlossWare/cobbler/blob/master/kickstarts/flossware_rhel_atomic.ks):  kickstarting template for RHEL Atomic.
* [flossware_standard.ks](https://github.com/FlossWare/cobbler/blob/master/kickstarts/flossware_standard.ks):  standard kickstarting template for "normal" bare metal or VMs.

**Please note**  there is some uniqueness when templating Atomic kickstarts:
* No ```package``` section
* An ```ostreesetup``` option
* Each Atomic instance performs different operations in their respective ```post``` sections.
* The Fedora Atomic image uses ```addon``` and  ```anaconda``` sections.

Our initial work with Atomic kickstarts was performed by manually installing each image and reviewing the generated kickstart after the install was booted.

### Snippets

[Snippets](https://github.com/FlossWare/cobbler/tree/master/snippets) represent the bulk of all work.  We considered putting some templatization in the [kickstarts](https://github.com/FlossWare/cobbler/tree/master/kickstarts) but felt that keeping that functionality together made the most logical sense.  [Snippets](https://github.com/FlossWare/cobbler/tree/master/snippets) are broken up into the categories found below.  Each concept (with the exception of the Kickstart Counterparts) is contained in a directory of that name.

#### Kickstart Counterparts

As mentioned above, all [kickstarts](https://github.com/FlossWare/cobbler/tree/master/kickstarts) call a corresponding [snippet](https://github.com/FlossWare/cobbler/tree/master/snippets).  The job of these snippets is to set variables (where appropriate) and coordinate assembly of the [kickstart](http://cobbler.github.io/manuals/2.6.0/3/5_-_Kickstart_Templating.html) result as a whole.  The names correspond to the type of distro you are installing:
* [centos_atomic_kickstart](https://github.com/FlossWare/cobbler/blob/master/snippets/centos_atomic_kickstart)
* [fedora_atomic_kickstart](https://github.com/FlossWare/cobbler/blob/master/snippets/fedora_atomic_kickstart)
* [rhel_atomic_kickstart](https://github.com/FlossWare/cobbler/blob/master/snippets/rhel_atomic_kickstart)
* [standard_kickstart](https://github.com/FlossWare/cobbler/blob/master/snippets/standard_kickstart)

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

#### Yum 

To yum install, you will need to enable the FlossWare cobbler yum repo by performing one of the following:

* Get the repo file:  ```wget https://bintray.com/flossware/rpm/rpm -O bintray-flossware-rpm.repo```
* Create the ```/etc/yum.repos.d/bintray-flossware-rpm.repo``` file as:
```
#bintraybintray-flossware-rpm - packages by flossware from Bintray
[bintraybintray-flossware-rpm]
name=bintray-flossware-rpm
baseurl=https://dl.bintray.com/flossware/rpm
gpgcheck=0
repo_gpgcheck=0
enabled=1
```

Once the repo file exists, execute:  ```yum install flossware-cobbler```

### Default Use

By default, the [kickstarts](https://github.com/FlossWare/cobbler/tree/master/kickstarts) and [snippets](https://github.com/FlossWare/cobbler/tree/master/snippets) can be used upon deployment with no additions to ```ksmeta```.  The only caveat is your installed bare metal or VMs will use the root password ```cobbler```.

### Define the Root Password

* Using ```plaintext```:  ```ksmeta='rootpw="--plaintext mypassword"'```
* Using ```encrypted```:  ```ksmeta='rootpw="--iscrypted laskdjfaklkmcLKMCSDNKJANDF"'```

### Layout LVM partitions

Simply provide a space or comma separated list of the disks to use in the partition as a ```ksmeta``` variable ```lvmDisks```.  As an example assume you wish to use ```sda```, ```sdc``` and ```sdd```:   ```ksmeta='lvmDisks="sda sdc sdd"'```

## Examples

For more concrete examples, please see [Flossy's Cobbler Scripts](https://github.com/sfloess/scripts/blob/master/bash/cobbler.sh) for his home network. 
