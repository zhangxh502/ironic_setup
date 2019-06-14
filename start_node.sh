#!/bin/bash

source server_ipmi

#small than real value
RAM=65536
DISK=800
VCPUS=32
HOST_CPU_ARCH=x86_64
export IRONIC_API_VERSION=1.20

nova quota-class-update --instances 50 default
nova quota-class-update --ram 5120000 default
nova quota-class-update --cores 2000 default

DEPLOY_VMLINUZ_UUID=$(glance image-list|grep deploy-vmlinuz|awk -F "| " '{print $2}')
DEPLOY_INITRD_UUID=$(glance image-list|grep deploy-initrd|awk -F "| " '{print $2}')

# node1
nova flavor-create ai-bm-node1 1 ${RAM} ${DISK} ${VCPUS}
nova flavor-key ai-bm-node1 set cpu_arch=x86_64
nova flavor-key ai-bm-node1 set resources:CUSTOM_BAREMETAL_NODE1_AI=1
nova flavor-key ai-bm-node1 set resources:VCPU=0
nova flavor-key ai-bm-node1 set resources:MEMORY_MB=0
nova flavor-key ai-bm-node1 set resources:DISK_GB=0


ironic node-create -d pxe_ipmitool  -n node1
NODE1_UUID=$(ironic node-list|grep node1|awk -F "| " '{print $2}')

ironic node-update $NODE1_UUID add  driver_info/ipmi_username=$s1_ipmi_username   \
driver_info/ipmi_password=$s1_ipmi_password  driver_info/ipmi_address=$s1_ipmi_address \
driver_info/ipmi_terminal_port=623

ironic node-update $NODE1_UUID add driver_info/deploy_kernel=$DEPLOY_VMLINUZ_UUID \
    driver_info/deploy_ramdisk=$DEPLOY_INITRD_UUID

ironic node-update $NODE1_UUID add properties/cpus=${VCPUS}  properties/memory_mb=${RAM} \
 properties/local_gb=${DISK} properties/cpu_arch=${HOST_CPU_ARCH}

openstack --os-baremetal-api-version 1.21 baremetal node set $NODE1_UUID \
  --resource-class  CUSTOM_BAREMETAL_NODE1_AI

ironic port-create -n $NODE1_UUID -a $s1_nic_mac_address

ironic --ironic-api-version 1.20 node-set-provision-state $NODE1_UUID manage
ironic --ironic-api-version 1.20 node-set-provision-state $NODE1_UUID provide

nova quota-class-update --ram 512000 default
nova quota-class-update --cores 200 default

openstack server create --image my-image --flavor ai-bm-node1 \
 --key-name mykey --network public1  node1



# node2

nova flavor-create ai-bm-node2 2 ${RAM} ${DISK} ${VCPUS}
nova flavor-key ai-bm-node2 set cpu_arch=x86_64
nova flavor-key ai-bm-node2 set resources:CUSTOM_BAREMETAL_NODE2_AI=1
nova flavor-key ai-bm-node2 set resources:VCPU=0
nova flavor-key ai-bm-node2 set resources:MEMORY_MB=0
nova flavor-key ai-bm-node2 set resources:DISK_GB=0


ironic node-create -d pxe_ipmitool  -n node2
NODE2_UUID=$(ironic node-list|grep node2|awk -F "| " '{print $2}')

ironic node-update $NODE2_UUID add  driver_info/ipmi_username=$s2_ipmi_username   \
driver_info/ipmi_password=$s2_ipmi_password  driver_info/ipmi_address=$s2_ipmi_address \
driver_info/ipmi_terminal_port=623

ironic node-update $NODE2_UUID add driver_info/deploy_kernel=$DEPLOY_VMLINUZ_UUID \
    driver_info/deploy_ramdisk=$DEPLOY_INITRD_UUID

ironic node-update $NODE2_UUID add properties/cpus=${VCPUS}  properties/memory_mb=${RAM} \
 properties/local_gb=${DISK} properties/cpu_arch=${HOST_CPU_ARCH}

openstack --os-baremetal-api-version 1.21 baremetal node set $NODE2_UUID \
  --resource-class  CUSTOM_BAREMETAL_NODE2_AI

ironic port-create -n $NODE2_UUID -a $s2_nic_mac_address

ironic --ironic-api-version 1.20 node-set-provision-state $NODE2_UUID manage
ironic --ironic-api-version 1.20 node-set-provision-state $NODE2_UUID provide

openstack server create --image my-image --flavor ai-bm-node2 \
 --key-name mykey --network public1  node2


# node3

nova flavor-create ai-bm-node3 3 ${RAM} ${DISK} ${VCPUS}
nova flavor-key ai-bm-node3 set cpu_arch=x86_64
nova flavor-key ai-bm-node3 set resources:CUSTOM_BAREMETAL_NODE3_AI=1
nova flavor-key ai-bm-node3 set resources:VCPU=0
nova flavor-key ai-bm-node3 set resources:MEMORY_MB=0
nova flavor-key ai-bm-node3 set resources:DISK_GB=0


ironic node-create -d pxe_ipmitool  -n node3
NODE1_UUID=$(ironic node-list|grep node3|awk -F "| " '{print $2}')

ironic node-update $NODE3_UUID add  driver_info/ipmi_username=$s3_ipmi_username   \
driver_info/ipmi_password=$s3_ipmi_password  driver_info/ipmi_address=$s3_ipmi_address \
driver_info/ipmi_terminal_port=623

ironic node-update $NODE3_UUID add driver_info/deploy_kernel=$DEPLOY_VMLINUZ_UUID \
    driver_info/deploy_ramdisk=$DEPLOY_INITRD_UUID

ironic node-update $NODE3_UUID add properties/cpus=${VCPUS}  properties/memory_mb=${RAM} \
 properties/local_gb=${DISK} properties/cpu_arch=${HOST_CPU_ARCH}

openstack --os-baremetal-api-version 1.21 baremetal node set $NODE3_UUID \
  --resource-class  CUSTOM_BAREMETAL_NODE3_AI

ironic port-create -n $NODE3_UUID -a $s3_nic_mac_address

ironic --ironic-api-version 1.20 node-set-provision-state $NODE3_UUID manage
ironic --ironic-api-version 1.20 node-set-provision-state $NODE3_UUID provide

openstack server create --image my-image --flavor ai-bm-node3 \
 --key-name mykey --network public1  node3


 # node4

nova flavor-create ai-bm-node4 4 ${RAM} ${DISK} ${VCPUS}
nova flavor-key ai-bm-node4 set cpu_arch=x86_64
nova flavor-key ai-bm-node4 set resources:CUSTOM_BAREMETAL_NODE4_AI=1
nova flavor-key ai-bm-node4 set resources:VCPU=0
nova flavor-key ai-bm-node4 set resources:MEMORY_MB=0
nova flavor-key ai-bm-node4 set resources:DISK_GB=0


ironic node-create -d pxe_ipmitool  -n node4
NODE4_UUID=$(ironic node-list|grep node4|awk -F "| " '{print $2}')

ironic node-update $NODE4_UUID add  driver_info/ipmi_username=$s4_ipmi_username   \
driver_info/ipmi_password=$s4_ipmi_password  driver_info/ipmi_address=$s4_ipmi_address \
driver_info/ipmi_terminal_port=623

ironic node-update $NODE4_UUID add driver_info/deploy_kernel=$DEPLOY_VMLINUZ_UUID \
    driver_info/deploy_ramdisk=$DEPLOY_INITRD_UUID

ironic node-update $NODE4_UUID add properties/cpus=${VCPUS}  properties/memory_mb=${RAM} \
 properties/local_gb=${DISK} properties/cpu_arch=${HOST_CPU_ARCH}

openstack --os-baremetal-api-version 1.21 baremetal node set $NODE4_UUID \
  --resource-class  CUSTOM_BAREMETAL_NODE4_AI

ironic port-create -n $NODE4_UUID -a $s4_nic_mac_address

ironic --ironic-api-version 1.20 node-set-provision-state $NODE4_UUID manage
ironic --ironic-api-version 1.20 node-set-provision-state $NODE4_UUID provide

openstack server create --image my-image --flavor ai-bm-node4 \
 --key-name mykey --network public1  node4


 # node5

nova flavor-create ai-bm-node5 5 ${RAM} ${DISK} ${VCPUS}
nova flavor-key ai-bm-node5 set cpu_arch=x86_64
nova flavor-key ai-bm-node5 set resources:CUSTOM_BAREMETAL_NODE5_AI=1
nova flavor-key ai-bm-node5 set resources:VCPU=0
nova flavor-key ai-bm-node5 set resources:MEMORY_MB=0
nova flavor-key ai-bm-node5 set resources:DISK_GB=0


ironic node-create -d pxe_ipmitool  -n node5
NODE5_UUID=$(ironic node-list|grep node5|awk -F "| " '{print $2}')

ironic node-update $NODE5_UUID add  driver_info/ipmi_username=$s5_ipmi_username   \
driver_info/ipmi_password=$s5_ipmi_password  driver_info/ipmi_address=$s5_ipmi_address \
driver_info/ipmi_terminal_port=623

ironic node-update $NODE5_UUID add driver_info/deploy_kernel=$DEPLOY_VMLINUZ_UUID \
    driver_info/deploy_ramdisk=$DEPLOY_INITRD_UUID

ironic node-update $NODE5_UUID add properties/cpus=${VCPUS}  properties/memory_mb=${RAM} \
 properties/local_gb=${DISK} properties/cpu_arch=${HOST_CPU_ARCH}

openstack --os-baremetal-api-version 1.21 baremetal node set $NODE5_UUID \
  --resource-class  CUSTOM_BAREMETAL_NODE5_AI

ironic port-create -n $NODE5_UUID -a $s5_nic_mac_address

ironic --ironic-api-version 1.20 node-set-provision-state $NODE5_UUID manage
ironic --ironic-api-version 1.20 node-set-provision-state $NODE5_UUID provide

openstack server create --image my-image --flavor ai-bm-node5 \
 --key-name mykey --network public1  node5

# node6

nova flavor-create ai-bm-node6 6 ${RAM} ${DISK} ${VCPUS}
nova flavor-key ai-bm-node6 set cpu_arch=x86_64
nova flavor-key ai-bm-node6 set resources:CUSTOM_BAREMETAL_NODE6_AI=1
nova flavor-key ai-bm-node6 set resources:VCPU=0
nova flavor-key ai-bm-node6 set resources:MEMORY_MB=0
nova flavor-key ai-bm-node6 set resources:DISK_GB=0


ironic node-create -d pxe_ipmitool  -n node6
NODE6_UUID=$(ironic node-list|grep node6|awk -F "| " '{print $2}')

ironic node-update $NODE6_UUID add driver_info/ipmi_username=$s6_ipmi_username   \
driver_info/ipmi_password=$s6_ipmi_password  driver_info/ipmi_address=$s6_ipmi_address \
driver_info/ipmi_terminal_port=623

ironic node-update $NODE6_UUID add driver_info/deploy_kernel=$DEPLOY_VMLINUZ_UUID \
    driver_info/deploy_ramdisk=$DEPLOY_INITRD_UUID

ironic node-update $NODE6_UUID add properties/cpus=${VCPUS}  properties/memory_mb=${RAM} \
 properties/local_gb=${DISK} properties/cpu_arch=${HOST_CPU_ARCH}

openstack --os-baremetal-api-version 1.21 baremetal node set $NODE6_UUID \
  --resource-class  CUSTOM_BAREMETAL_NODE6_AI

ironic port-create -n $NODE6_UUID -a $s6_nic_mac_address

ironic --ironic-api-version 1.20 node-set-provision-state $NODE6_UUID manage
ironic --ironic-api-version 1.20 node-set-provision-state $NODE6_UUID provide

openstack server create --image my-image --flavor ai-bm-node6 \
 --key-name mykey --network public1  node6
