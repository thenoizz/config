#!/bin/bash
set -e

. ./functions-common

export OS_USERNAME=admin
export OS_PASSWORD=Passw0rd
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://127.0.0.1:5000/v2.0

DEVSTACK_IMAGES_DIR=/home/ubuntu
DEVSTACK_IMAGE_FILE=cirros.vhd
DEVSTACK_LIVE_MIGRATION=False

nova flavor-delete 42
nova flavor-create m1.nano 42 64 1 1
#nova flavor-create m1.nano 42 256 3 1

nova flavor-delete 84
nova flavor-create m1.micro 84 128 2 1
#nova flavor-create m1.micro 84 300 4 1

nova flavor-delete 451
nova flavor-create m1.heat 451 512 5 1

TEMPEST_CONFIG=/opt/stack/tempest/etc/tempest.conf

iniset $TEMPEST_CONFIG compute volume_device_name "sdb"
iniset $TEMPEST_CONFIG compute-feature-enabled rdp_console true
iniset $TEMPEST_CONFIG compute-feature-enabled block_migrate_cinder_iscsi $DEVSTACK_LIVE_MIGRATION

iniset $TEMPEST_CONFIG scenario img_dir $DEVSTACK_IMAGES_DIR
iniset $TEMPEST_CONFIG scenario img_file $DEVSTACK_IMAGE_FILE
iniset $TEMPEST_CONFIG scenario img_disk_format vhd

