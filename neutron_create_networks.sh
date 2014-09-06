#!/bin/sh

public_i



NETID1=$(neutron net-create private2 --provider:network_type vlan --provider:segmentation_id 603 --provider:physical_network physnet1 | awk '{if (NR == 6) {print $4}}')
SUBNETID1=$(neutron subnet-create private2 10.0.1.0/24 --dns_nameservers list=true 8.8.8.8 | awk '{if (NR == 11) {print $4}}')

ROUTERID1=`neutron router-create router | awk '{if (NR == 7) {print $4}}'`

neutron router-interface-add $ROUTERID1 $SUBNETID1

EXTNETID1=`neutron net-create public2 --router:external=True | awk '{if (NR == 6) {print $4}}'`
neutron subnet-create public2 --allocation-pool start=157.59.135.102,end=157.59.135.212 --gateway 157.59.132.1 157.59.132.0/22 --enable_dhcp=False

neutron router-gateway-set $ROUTERID1 $EXTNETID1
