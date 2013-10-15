#!/bin/bash

yum install sqlite-devel
curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3 --gems=rails