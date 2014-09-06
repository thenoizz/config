#!/bin/sh
SUBNETID1=`neutron net-show public | awk '{if (NR == 13) {print $4}}'`
neutron router-interface-delete router $SUBNETID1
neutron net-delete public

SUBNETID2=`neutron net-show private | awk '{if (NR == 13) {print $4}}'`
neutron router-interface-delete router $SUBNETID2
neutron net-delete private

neutron router-delete router

neutron net-delete ext_net

