#!/bin/bash 

# Copyright (C) 2016 flossware
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [ $# = "0" ]
then
	RPM_HOME=~/.flossware/cobbler
else
	RPM_HOME=$1
fi

# -------------------------------------------------------

mkdir -p ${RPM_HOME}

echo "Building RPM in ${RPM_HOME}/rpm..."

# -------------------------------------------------------

export RPM_BUILD_ROOT=${RPM_HOME}/rpm
export RPM_BUILD_DIR=${RPM_HOME}/rpm/BUILD
export RPM_ROOT_DIR=${RPM_HOME}/rpm
export RPM_SOURCE_DIR=${RPM_HOME}/rpm/SOURCES

# -------------------------------------------------------

mkdir -p ${RPM_BUILD_ROOT}/BUILD
mkdir -p ${RPM_BUILD_ROOT}/RPMS
mkdir -p ${RPM_BUILD_ROOT}/SOURCES
mkdir -p ${RPM_BUILD_ROOT}/SPECS
mkdir -p ${RPM_BUILD_ROOT}/SRPMS

# -------------------------------------------------------

VERSION=`grep 'Version:' flossware.spec | tr -d ' ' | cut -f 2 -d ':'`

# -------------------------------------------------------

mkdir -p /tmp/flossware/cobbler/flossware-cobbler-${VERSION}
cp -a templates /tmp/flossware/cobbler/flossware-cobbler-${VERSION}
cp -a snippets /tmp/flossware/cobbler/flossware-cobbler-${VERSION}
tar czf flossware-cobbler-${VERSION}.tar.gz -C /tmp/flossware/cobbler flossware-cobbler-${VERSION}
mv flossware-cobbler-${VERSION}.tar.gz ${RPM_BUILD_ROOT}/SOURCES
rm -rf /tmp/flossware/cobbler

# -------------------------------------------------------

OLD_DIR=`pwd`

cd `dirname $0`

# -------------------------------------------------------

rpmbuild --define "_topdir ${RPM_BUILD_ROOT}" -ba flossware.spec

# -------------------------------------------------------

cd ${OLD_DIR}