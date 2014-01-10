#!/bin/bash

# TRIM can be enabled by using the following Terminal commands.
# This patch simply edits a file called IOAHCIBlockStoage, removing a string that makes TRIM work for only Apple SSDs.

# Backup the file that you’re about to patch:
sudo cp /System/Library/Extensions/IOAHCIFamily.kext/Contents/PlugIns/IOAHCIBlockStorage.kext/Contents/MacOS/IOAHCIBlockStorage /IOAHCIBlockStorage.original

# Patch the file to enable TRIM support:
sudo perl -pi -e ‘s|(\x52\x6F\x74\x61\x74\x69\x6F\x6E\x61\x6C\x00).{9}(\x00\x51)|$1\x00\x00\x00\x00\x00\x00\x00\x00\x00$2|sg’ /System/Library/Extensions/IOAHCIFamily.kext/Contents/PlugIns/IOAHCIBlockStorage.kext/Contents/MacOS/IOAHCIBlockStorage
sudo touch /System/Library/Extensions/

# Clear the kext caches:
sudo kextcache -system-prelinked-kernel
sudo kextcache -system-caches

# Reboot the machine
sudo shutdown -r now
