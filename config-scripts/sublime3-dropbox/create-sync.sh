#!/bin/bash
set -x

echo "Create the sync directory in Dropbox"
$ mkdir ~/Dropbox/Apps/sublime-text-3/

echo "Move your ST3 Packages and Installed Packages to Dropbox"
$ cd ~/Library/Application\ Support/Sublime\ Text\ 3
$ mv Packages/ ~/Dropbox/Apps/sublime-text-3/
$ mv Installed\ Packages/ ~/Dropbox/Apps/sublime-text-3/

echo "Then symlink your Dropbox directories back locally"
$ ln -s ~/Dropbox/Apps/sublime-text-3/Packages
$ ln -s ~/Dropbox/Apps/sublime-text-3/Installed\ Packages