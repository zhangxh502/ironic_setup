#!/bin/bash

sudo kolla-ansible destroy --yes-i-really-really-mean-it
sudo kolla-ansible deploy \
-i /usr/local/share/kolla-ansible/ansible/inventory/all-in-one

sudo kolla-ansible post-deploy

