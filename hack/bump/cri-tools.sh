# Copyright (c) 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: Apache-2.0

set -e

# Fetch the latest cri-tools versions
LATEST_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/cri-tools/releases/latest | jq -r .tag_name | sed 's/^v//')

# Update cri-tools with the latest version
sed -i "s/^DIB_CRI_TOOLS_VERSION=.*/DIB_CRI_TOOLS_VERSION=\${DIB_CRI_TOOLS_VERSION:-\"${LATEST_VERSION}\"}/" \
  elements/cri-tools/install.d/70-cri-tools

echo "Updated cri-tools to version ${LATEST_VERSION}."
