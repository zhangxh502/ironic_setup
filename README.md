# ironic_setup
Rapid deployment of HPC bare metal clusters

### Step1 Initialize the network card configuration of the netron network

```

cd ironic_setup
sudo chmod 755 *.sh
sudo ./network-setup.sh
sudo reboot


```


### Step2 Initialize the system locale

```
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
sudo dpkg-reconfigure locales

```

select en_US.UTF-8 encode

### Step3 Initializa kolla config build basic ironic env

```
sudo ./kolla_setup.sh

```

### Step4 ironic env init

```
sudo ./ironic_setup.sh

```

### Step5 create node，boot instance

```
sudo ./build_images.sh
sudo ./gen_sshkey.sh
sudo ./start_node.sh

```

### Tools Reploy kolla node

```
sudo ./re_deploy.sh

```

### Tools clean all deployed node

```
sudo ./clean_all_node.sh

```

### Create ironic-agent image

```
sudo pip install virtualenv
sudo pip install diskimage-builder
sudo disk-image-create ironic-agent fedora -o ironic-agent

```