# block-device-kubernetes

We need this custom element for few reasons:

- No need to handle additional variable `DIB_BLOCK_DEVICE_CONFIG=file://$ELEMENTS_PATH/path/to/block-device-efi.yml`
- Skipping element `block-device-efi` and adding `DIB_BLOCK_DEVICE=efi` it's not enough because all `block-device-(mbr|efi|gpt)` elements are meta elements for `block-device`: <https://opendev.org/openstack/diskimage-builder/src/branch/master/diskimage_builder/block_device/blockdevice.py> with more logic under the hood.
- Using `block-device-efi`, regardless of whether there is a custom configuration or not, will add additional 512Mb to a final RAW image size: <https://opendev.org/openstack/diskimage-builder/commit/5492843aa8f06554d9a1eba452922ef4724cd43b>.
