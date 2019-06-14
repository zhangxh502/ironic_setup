#!/bin/bash


EXT_NET_CIDR='192.168.1.0/24'
EXT_NET_RANGE='start=192.168.1.20,end=192.168.1.100'
EXT_NET_GATEWAY='192.168.1.253'
EXT_NET_CIDR_DNS='192.168.1.253'


# ironic init setup
# create ironic manage network
openstack network create --provider-physical-network physnet1 \
    --provider-network-type flat public1

openstack subnet create  \
    --allocation-pool ${EXT_NET_RANGE} --network public1 \
    --subnet-range ${EXT_NET_CIDR} --gateway ${EXT_NET_GATEWAY}  --dns-nameserver ${EXT_NET_CIDR_DNS} -- public1-subnet

openstack image create --disk-format aki --container-format aki --public \
  --file /etc/kolla/config/ironic/ironic-agent.kernel deploy-vmlinuz
openstack image create --disk-format ari --container-format ari --public \
  --file /etc/kolla/config/ironic/ironic-agent.initramfs deploy-initrd


