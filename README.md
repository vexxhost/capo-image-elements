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
export DIB_KUBERNETES_VERSION=1.33.4
disk-image-create vm ubuntu kubernetes
```

You can add any other elements that you require for your image by adding them
to the command.
