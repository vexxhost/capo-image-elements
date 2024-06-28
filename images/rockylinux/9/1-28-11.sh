#!/bin/bash
# SPDX-License-Identifier: Apache-2.0

export ELEMENTS_PATH=$PWD/elements
export DIB_RELEASE=9
export DIB_KUBERNETES_VERSION=1.28.11
export DIB_CLOUD_INIT_GROWPART_DEVICES='["/"]'
disk-image-create vm rocky-container cloud-init cloud-init-growpart kubernetes
