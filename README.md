# capo-image-elements

This repository contains `diskimage-builder` elements for building images for
Cluster API provider for OpenStack.

These images take a different approach than the upstream
[image-builder](https://github.com/kubernetes-sigs/image-builder)
project in that they are built using `diskimage-builder` and not Packer.

These images were primarily built to be consumed by the
[Cluster API driver for Magnum](https://github.com/vexxhost/magnum-cluster-api),
however, they will likely generate `qcow2` images that should work directly
with the Cluster API provider for OpenStack.

## Releases

### Automatic updates

This repository runs nightly updates to grab the latest maintained Kubernetes versions
and creates a pull request to update the versions in the CI workflow.

### Release images

Upon every merge to the main branch, a CI workflow will start up a DevStack instance
with the Cluster API provider for OpenStack. For all maintained Kubernetes releases on
different Linux distributions, it will spin up a cluster with the image and ensure that
it can create a cluster successfully. After this, new images will be built and
published as a GitHub release. In addition, contributors to this repository can trigger
builds by using the workflow dispatch trigger.

## Building the images

To build the images, you will need to have `diskimage-builder` installed. You
can install it using pip:

```shell
pip install diskimage-builder
```

Once you have `diskimage-builder` installed, you can build the images by
exporting the `ELEMENTS_PATH` and running the following command:

```shell
export ELEMENTS_PATH=$PWD/elements
export DIB_RELEASE=jammy
export DIB_CLOUD_INIT_GROWPART_DEVICES="/"
export DIB_SKIP_BASE_PACKAGE_INSTALL=1
export DIB_KUBERNETES_VERSION=1.35.0
disk-image-create vm ubuntu-minimal block-device-kubernetes kubernetes
```

For Debian variant, `DIB_RELEASE` should be changed to `trixie` and the `ubuntu-minimal` element to `debian-minimal`.

For Rocky Linux variant, `DIB_RELEASE` should be changed to `9` and the `ubuntu-minimal` element to `rocky-container`.

With `block-device-kubernetes` element we are trimming `/boot/efi` partition to 100MiB. If you need a larger EFI boot partition size or planning to use MBR boot only, change this item to `block-device-efi` or `block-device-mbr`.

You can add any other elements that you require for your image by adding them
to the command.
