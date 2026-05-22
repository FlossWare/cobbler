#!/bin/bash

# Copyright (C) 2024 flossware
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
    if [ $exit_code -ne 0 ]; then
        echo "ERROR: DEB build failed with exit code ${exit_code}" >&2
    fi
    exit $exit_code
}

trap cleanup EXIT INT TERM

# Determine DEB build directory
if [ $# -eq 0 ]; then
    DEB_HOME=/tmp/flossware/cobbler/deb
else
    DEB_HOME=$1
fi

echo "Building DEB in ${DEB_HOME}..."

# Create DEB directory structure
mkdir -p "${DEB_HOME}"

# Extract version from debian/changelog (more robust)
if ! VERSION=$(dpkg-parsechangelog -l debian/changelog --show-field Version 2>/dev/null); then
    echo "ERROR: Failed to extract version from debian/changelog" >&2
    exit 1
fi

if [ -z "$VERSION" ]; then
    echo "ERROR: Version is empty" >&2
    exit 1
fi

echo "Building version: ${VERSION}"

# Build DEB package
if ! dpkg-buildpackage -us -uc -b; then
    echo "ERROR: dpkg-buildpackage failed" >&2
    exit 1
fi

# Move DEB to output directory
DEB_FILE="../flossware-cobbler_${VERSION}_all.deb"
if [ ! -f "${DEB_FILE}" ]; then
    echo "ERROR: Expected DEB not found: ${DEB_FILE}" >&2
    exit 1
fi

# Move to final location
mkdir -p "${DEB_HOME}"
mv "${DEB_FILE}" "${DEB_HOME}/"

echo "SUCCESS: Built ${DEB_HOME}/flossware-cobbler_${VERSION}_all.deb"
