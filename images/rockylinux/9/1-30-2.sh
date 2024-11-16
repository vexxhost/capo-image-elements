#!/bin/bash
# SPDX-License-Identifier: Apache-2.0

export ELEMENTS_PATH=$PWD/elements
export DIB_RELEASE=9
export DIB_BOOTLOADER_DEFAULT_CMDLINE="transparent_hugepage=madvise"
export DIB_KUBERNETES_VERSION=1.30.2
export DIB_CLOUD_INIT_GROWPART_DEVICES='["/"]'
disk-image-create vm rocky-container bootloader epel cloud-init cloud-init-growpart kubernetes
