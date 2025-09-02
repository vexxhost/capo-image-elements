# Copyright (c) 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: Apache-2.0

set -e

# Fetch the latest cni-plugins versions
LATEST_VERSION=$(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest | jq -r .tag_name | sed 's/^v//')

# Update cni-plugins with the latest version
sed -i "s/^DIB_CNI_PLUGINS_VERSION=.*/DIB_CNI_PLUGINS_VERSION=\${DIB_CNI_PLUGINS_VERSION:-\"${LATEST_VERSION}\"}/" \
  elements/cni-plugins/install.d/70-cni-plugins

echo "Updated cni-plugins to version ${LATEST_VERSION}."
