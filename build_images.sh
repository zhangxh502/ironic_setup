#!/bin/bash

sudo pip install diskimage-builder
sudo apt install -y qemu-utils

disk-image-create ubuntu baremetal dhcp-all-interfaces -o my-image

glance image-create --name my-kernel --visibility public \
  --disk-format aki --container-format aki < my-image.vmlinuz

glance image-create --name my-image.initrd --visibility public \
  --disk-format ari --container-format ari < my-image.initrd

MY_VMLINUZ_UUID=$(glance image-list|grep my-kernel|awk -F "| " '{print $2}')
MY_INITRD_UUID=$(glance image-list|grep my-image.initrd|awk -F "| " '{print $2}')

glance image-create --name my-image --visibility public \
  --disk-format qcow2 --container-format bare --property \
  kernel_id=$MY_VMLINUZ_UUID --property \
  ramdisk_id=$MY_INITRD_UUID < my-image.qcow2