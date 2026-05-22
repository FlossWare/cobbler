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

set -euo pipefail

# Cleanup function
cleanup() {
    local exit_code=$?
    if [ -n "${VERSION:-}" ] && [ -d "/tmp/flossware-cobbler-${VERSION}" ]; then
        rm -rf "/tmp/flossware-cobbler-${VERSION}"
    fi
    if [ $exit_code -ne 0 ]; then
        echo "ERROR: Build failed with exit code ${exit_code}" >&2
    fi
    exit $exit_code
}

trap cleanup EXIT INT TERM

# Determine RPM build directory
if [ $# -eq 0 ]; then
    RPM_HOME=/tmp/flossware/cobbler
else
    RPM_HOME=$1
fi

echo "Building RPM in ${RPM_HOME}..."

# Create RPM directory structure
mkdir -p "${RPM_HOME}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Extract version from spec file (more robust)
if ! VERSION=$(rpm -q --queryformat '%{VERSION}\n' --specfile flossware.spec 2>/dev/null | head -1); then
    echo "ERROR: Failed to extract version from flossware.spec" >&2
    exit 1
fi

if [ -z "$VERSION" ]; then
    echo "ERROR: Version is empty" >&2
    exit 1
fi

echo "Building version: ${VERSION}"

# Create source tarball
TARBALL_DIR="/tmp/flossware-cobbler-${VERSION}"
mkdir -p "${TARBALL_DIR}"

cp -a templates "${TARBALL_DIR}/"
cp -a snippets "${TARBALL_DIR}/"

tar czf "${RPM_HOME}/SOURCES/flossware-cobbler-${VERSION}.tar.gz" \
    -C /tmp "flossware-cobbler-${VERSION}"

# Build RPM
if ! rpmbuild --verbose --define "_topdir ${RPM_HOME}" -ba flossware.spec; then
    echo "ERROR: rpmbuild failed" >&2
    exit 1
fi

# Verify build artifacts exist
RELEASE=$(rpm -q --queryformat '%{RELEASE}\n' --specfile flossware.spec 2>/dev/null | head -1)
RPM_FILE="${RPM_HOME}/RPMS/noarch/flossware-cobbler-${VERSION}-${RELEASE}.noarch.rpm"

if [ ! -f "${RPM_FILE}" ]; then
    echo "ERROR: Expected RPM not found: ${RPM_FILE}" >&2
    exit 1
fi

echo "SUCCESS: Built ${RPM_FILE}"
