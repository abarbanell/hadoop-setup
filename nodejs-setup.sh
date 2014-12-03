#!/bin/sh

# Setup script for node.js

# set apt sources
curl -sL https://deb.nodesource.com/setup | sudo bash -

# install
sudo apt-get install -y nodejs

# nice to have - get express
sudo npm install --global express
sudo apt-get install node-express

