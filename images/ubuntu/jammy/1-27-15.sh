#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Image-Rebuild-Time: 2024-06-28T18:14:42Z

export ELEMENTS_PATH=$PWD/elements
export DIB_RELEASE=jammy
export DIB_KUBERNETES_VERSION=1.27.15
disk-image-create vm block-device-gpt ubuntu kubernetes
