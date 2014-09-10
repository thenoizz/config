#!/bin/bash
set -x

echo "Remove the 'outdated' directories"
$ cd ~/Library/Application\ Support/Sublime\ Text\ 3
$ rm -rf Packages/
$ rm -rf Installed\ Packages/

echo "Then symlink your Dropbox directories back locally"
$ ln -s ~/Dropbox/Apps/sublime-text-3/Packages
$ ln -s ~/Dropbox/Apps/sublime-text-3/Installed\ Packages