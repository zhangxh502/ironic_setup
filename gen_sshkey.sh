#!/bin/bash

# 生成密钥对
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo Generating ssh key.
    ssh-keygen -t rsa -f ~/.ssh/id_rsa
fi

if [ -r ~/.ssh/id_rsa.pub ]; then
    echo Configuring nova public key and quotas.
    openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey
fi