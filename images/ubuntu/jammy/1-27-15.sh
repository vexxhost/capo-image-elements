#!/bin/bash
# SPDX-License-Identifier: Apache-2.0

export ELEMENTS_PATH=$PWD/elements
export DIB_RELEASE=jammy
export DIB_KUBERNETES_VERSION=1.27.15
disk-image-create vm ubuntu kubernetes
