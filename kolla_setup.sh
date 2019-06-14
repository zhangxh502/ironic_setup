#!/bin/bash

APT_NET=10.11.3.96
HOSTNAME=ironic

#sudo apt-get update
#sudo apt-get upgrade

sudo apt-get install python-jinja2 python-pip libssl-dev -fy
mkdir ~/.pip

tee ~/.pip/pip.conf <<-'EOF'
[global]
trusted-host =  mirrors.aliyun.com
index-url = https://mirrors.aliyun.com/pypi/simple
EOF

sudo pip install --upgrade pip
sudo pip install ansible==2.7.6
sudo pip install kolla-ansible==6.0.0
sudo pip install python-openstackclient

cp /usr/local/share/kolla-ansible/etc_examples/kolla/* /etc/kolla

sudo cp globals.yml /etc/kolla/globals.yml

sudo mkdir -p /etc/kolla/config/nova

sudo tee /etc/kolla/config/nova/nova-compute.conf <<-'EOF'
[libvirt]
virt_type = qemu
cpu_mode = none
EOF

sed -i '/${HOSTNAME}/d' /etc/hosts
echo ${APT_NET} ${HOSTNAME} >> /etc/hosts

sudo cp all-in-one /usr/local/share/kolla-ansible/ansible/inventory/all-in-one

kolla-genpwd

sudo kolla-ansible \
-i /usr/local/share/kolla-ansible/ansible/inventory/all-in-one bootstrap-servers
if [[ $? -ne 0 ]]; then
	exit
fi

sudo tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors":  ["https://ao6wb0ej.mirror.aliyuncs.com"]
}
EOF

sudo systemctl daemon-reload
sudo  service docker restart

sudo kolla-ansible pull
if [[ $? -ne 0 ]]; then
	exit
fi

sudo kolla-ansible prechecks \
-i /usr/local/share/kolla-ansible/ansible/inventory/all-in-one
if [[ $? -ne 0 ]]; then
	exit
fi

# ironic bugs fix
sudo modprobe configfs
sudo apt-get remove open-iscsi

sudo mkdir -p /etc/kolla/config/ironic

sudo cp ironic-agent.kernel /etc/kolla/config/ironic
sudo cp ironic-agent.initramfs /etc/kolla/config/ironic

sudo cp ironic.conf /etc/kolla/config/ironic.conf

# delpoy openstack
sudo kolla-ansible deploy \
-i /usr/local/share/kolla-ansible/ansible/inventory/all-in-one
if [[ $? -ne 0 ]]; then
	exit
fi

sudo kolla-ansible post-deploy
