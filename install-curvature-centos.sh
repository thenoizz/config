#!/bin/bash
# work in progress...

cd ~

# install sqlite development packages
yum install sqlite-devel

# install ruby 1.9.3 from
curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3 --gems=rails

# install git
yum install git -y

# git clone curvature
git clone https://github.com/thenoizz/curvature

cd curvature

# add port 3000 to iptables
iptables -I INPUT -p tcp --dport 3000 -j ACCEPT
iptables-save

curl -L https://get.rvm.io | bash -s -- --ignore-dotfiles

. /usr/local/rvm/scripts/rvm
echo  '. /usr/local/rvm/scripts/rvm' >> ~/.bash_profile

bundle install
rake db:create
rake db:migrate


# adduser curvature
# su - curvature
# cp -a curvature /home/curvature/
# chown curvature:curvature -R /home/curvature/

