Installing Devstack 101
=======================

##1. apt-get udate & upgrade
```
sudo apt-get update
sudo apt-get upgrade
```

##2. Install git, vim, ethtool
```
sudo apt-get install -y git vim ethtool
```

##3. Edit network Interfaces
```
sudo vi /etc/network/interfaces
```

**IMPORTANT:** This is a template. Please use your own settings.
```
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
address 10.7.21.10
netmask 255.255.0.0
gateway 10.7.1.1
dns-nameservers 8.8.8.8

# External iface for Openstack VM's
auto eth2
iface eth2 inet manual
up ip link set eth2 up
down ip link set eth2 down

# Data network
auto eth1
iface eth1 inet manual
up ip link set eth1 up
up ip link set eth1 promisc on
down ip link set eth1 promisc off
down ip link set eth1 down
```

##4. Disable rx/tx vlan offloading
Check for ```rx-vlan-offload: off``` and ```tx-vlan-offload: off```
If not, use this command to set them to off
```
sudo ethtool -K eth1 txvlan off rxvlan off
```

##5. OVS Bridges (ovs must be installed to run this)
```
sudo ovs-vsctl add-br br-eth1
sudo ovs-vsctl add-br br-ex
sudo ovs-vsctl add-port br-ex eth2
sudo ovs-vsctl add-port br-eth1 eth1
```

##6. Download some cloud images
```
cd
mkdir cloudimg
cd cloudimg
wget https://www.dropbox.com/s/3gzqwelskhqnbe3/centos64-cloudimg-amd64-vss.vhd?dl=0
wget https://www.dropbox.com/s/4uksnn25xbcdqjm/cirros-cloudimg.vhd?dl=0
wget https://www.dropbox.com/s/db3okjoap14d7hu/trusty-server-cloudimg-amd64-vss.vhd?dl=0
```
 
##7. Clone devstack
```
cd
git clone https://github.com/openstack-dev/devstack.git
cd devstack
```

##8. Copy local.conf and local.sh files
```
wget https://raw.githubusercontent.com/thenoizz/config/master/config-scripts/devstack/local.conf
wget https://raw.githubusercontent.com/thenoizz/config/master/config-scripts/devstack/local.sh
```

**IMPORTANT:** The downloaded local.conf is just a template. Please use your own settings.
```
vi local.conf
```

##9. Run stack.sh
```
./stack.sh
```
**IMPORTANT:** If the scripts doesn't finish properly or something else goes wrong, pleas unstack first using ```./unstack.sh``` script.




