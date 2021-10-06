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
	RPM_HOME=/tmp/flossware/cobbler
else
	RPM_HOME=$1
fi

# -------------------------------------------------------

mkdir -p ${RPM_HOME}

echo "Building RPM in ${RPM_HOME}..."

# -------------------------------------------------------

mkdir -p ${RPM_HOME}/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# -------------------------------------------------------

VERSION=`grep 'Version:' flossware.spec | tr -d ' ' | cut -f 2 -d ':'`

# -------------------------------------------------------

mkdir -p /tmp/flossware-cobbler-${VERSION}

cp -a templates /tmp/flossware-cobbler-${VERSION}
cp -a snippets  /tmp/flossware-cobbler-${VERSION}

tar czf ${RPM_HOME}/SOURCES/flossware-cobbler-${VERSION}.tar.gz -C /tmp flossware-cobbler-${VERSION}

#cp -a templates ${RPM_HOME}/SOURCES/flossware-cobbler-${VERSION}
#cp -a snippets  ${RPM_HOME}/SOURCES/flossware-cobbler-${VERSION}

#cp -a * ${RPM_HOME}/SOURCES/flossware-cobbler-${VERSION}
#rm -rf /tmp/flossware/cobbler

# -------------------------------------------------------

OLD_DIR=`pwd`

cd `dirname $0`

# -------------------------------------------------------

rpmbuild --verbose  --define "_topdir ${RPM_HOME}" -ba flossware.spec

# -------------------------------------------------------

cd ${OLD_DIR}