# Copyright (c) 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: Apache-2.0

set -e

# Fetch the latest containerd versions
LATEST_VERSION=$(curl -s https://api.github.com/repos/containerd/containerd/releases/latest | jq -r .tag_name | sed 's/^v//')

# Update containerd with the latest version
sed -i "s/^DIB_CONTAINERD_VERSION=.*/DIB_CONTAINERD_VERSION=\${DIB_CONTAINERD_VERSION:-\"${LATEST_VERSION}\"}/" \
  elements/containerd/install.d/70-containerd

echo "Updated containerd to version ${LATEST_VERSION}."
