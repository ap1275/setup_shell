#!/bin/bash
# *** *** *** *** *** *** *** *** 
# this script tested only debian9
# *** *** *** *** *** *** *** *** 

#==============================================================================
# check environment settings
#==============================================================================
if [ -z $ND_DB_USER ] && [ -z $ND_DB_PASS ] && [ -z $ND_DB_NAME ] ; then
  echo "set mariaDB user name and password via environment variables"
  exit 1
fi

if [ -z $GIT_USER ] && [ -z $GIT_MAIL ] ; then
  echo "set git user and mail via environment variables"
  exit 1
fi

if [ -z $NODE_INST_DIR ] ; then
  echo "set node install directory via environment variables"
  exit 1
fi

#==============================================================================
# setup nodejs8.9.4
#==============================================================================
mkdir -p $NODE_INST_DIR
cd $NODE_INST_DIR
wget https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz
tar Jxf node-v8.9.4-linux-x64.tar.xz
rm node-v8.9.4-linux-x64.tar.xz
ln -s node-v8.9.4-linux-x64 node
echo "export PATH=$NODE_INST_DIR/node/bin:$PATH" >> ~/.profile
source ~/.profile

#==============================================================================
# setup c++ compiler and libraries for building native library of ruby gems
#==============================================================================
sudo apt-get --yes install g++
sudo apt-get --yes install build-essential
sudo apt-get --yes install zlib1g-dev
sudo apt-get --yes install ruby2.3-dev
sudo apt-get --yes install libmariadbclient-dev

#==============================================================================
# setup ruby2.3
#==============================================================================
sudo apt-get --yes install ruby
sudo gem install bundler

#==============================================================================
# setup git for source control
#==============================================================================
sudo apt-get --yes install git
sudo apt-get --yes install vim
git config --global core.editor vim
git config --global user.name $GIT_USER
git config --global user.email $GIT_MAIL

#==============================================================================
# setup mysql and create database user account then grant
#==============================================================================
sudo apt-get --yes install mysql-server
echo "create user '$ND_DB_USER'@'localhost' identified by '$ND_DB_PASS';" | sudo mysql
echo "create database $ND_DB_NAME;" | sudo mysql
echo "grant all privileges on $ND_DB_NAME.* to '$ND_DB_USER'@'localhost'; flush privileges;" | sudo mysql

#==============================================================================
# install yarn command
#==============================================================================
sudo apt-get --yes install apt-transport-https
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get --yes install yarn

#==============================================================================
# add redis
#==============================================================================
sudo apt-get --yes install redis-server

#==============================================================================
# add chromium
#==============================================================================
sudo apt-get install chromium
