# Copyright (c) 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: Apache-2.0

set -e

# Fetch the latest runc versions
LATEST_VERSION=$(curl -s https://api.github.com/repos/opencontainers/runc/releases/latest | jq -r .tag_name | sed 's/^v//')

# Update runc with the latest version
sed -i "s/^DIB_RUNC_VERSION=.*/DIB_RUNC_VERSION=\${DIB_RUNC_VERSION:-\"${LATEST_VERSION}\"}/" \
  elements/runc/install.d/70-runc

echo "Updated runc to version ${LATEST_VERSION}."
