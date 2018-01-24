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
# install redis
#==============================================================================
sudo apt-get --yes install redis-server

#==============================================================================
# install chromium and dependency libraries to run puppeteer
#==============================================================================
sudo apt-get --yes install chromium
sudo apt-get --yes install \
  gconf-service \
  libasound2\
  libatk1.0-0\
  libc6\
  libcairo2\
  libcups2\
  libdbus-1-3\
  libexpat1\
  libfontconfig1\
  libgcc1\
  libgconf-2-4\
  libgdk-pixbuf2.0-0\
  libglib2.0-0\
  libgtk-3-0\
  libnspr4\
  libpango-1.0-0\
  libpangocairo-1.0-0\
  libstdc++6\
  libx11-6\
  libx11-xcb1\
  libxcb1\
  libxcomposite1\
  libxcursor1\
  libxdamage1\
  libxext6\
  libxfixes3\
  libxi6\
  libxrandr2\
  libxrender1\
  libxss1\
  libxtst6\
  ca-certificates\
  fonts-liberation\
  libappindicator1\
  libnss3\
  lsb-release\
  xdg-utils\
  wget
