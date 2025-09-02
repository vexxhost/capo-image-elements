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

### Pre-release images

Upon every merge to the main branch, a new pre-release image will be built and published
as a GitHub pre-release.  In addition, contributors of this repository are able to trigger
builds by using the workflow dispatch trigger.

### Release images

Once a pre-release is created, a CI workflow will start up a DevStack instance with the
Cluster API provider for OpenStack, spin up a cluster with this image and ensure that
it can spin up a cluster successfully.

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
export DIB_KUBERNETES_VERSION=1.34.0
disk-image-create vm block-device-efi ubuntu-minimal kubernetes
```

For Rocky Linux variant, `DIB_RELEASE` should be changed to `9` and the `ubuntu-minimal` element to `rocky-container`.

You can add any other elements that you require for your image by adding them
to the command.
