#!/bin/bash

NODE1_UUID=$(ironic node-list|grep node1|awk -F "| " '{print $2}')
NODE2_UUID=$(ironic node-list|grep node2|awk -F "| " '{print $2}')
NODE3_UUID=$(ironic node-list|grep node3|awk -F "| " '{print $2}')
NODE4_UUID=$(ironic node-list|grep node4|awk -F "| " '{print $2}')
NODE5_UUID=$(ironic node-list|grep node5|awk -F "| " '{print $2}')
NODE6_UUID=$(ironic node-list|grep node6|awk -F "| " '{print $2}')

ironic node-delete ${NODE1_UUID} ${NODE2_UUID} ${NODE3_UUID} ${NODE4_UUID} ${NODE5_UUID} ${NODE6_UUID}
openstack flavor delete 1 2 3 4 5 6

