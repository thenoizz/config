#!/bin/bash

mkdir /mnt/cdrom
mount /dev/cdrom1 /mnt/cdrom
cp /mnt/cdrom/VMwareTools-*.tar.gz /tmp
umount /mnt/cdrom
tar -zxf /tmp/VMwareTools-*.tar.gz -C /tmp
cd /
./tmp/vmware-tools-distrib/vmware-install.pl --default
rm -f /tmp/VMwareTools-*.tar.gz
rm -rf /tmp/vmware-tools-distrib