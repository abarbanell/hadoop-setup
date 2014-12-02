#!/bin/sh

# Setup script for node.js

# set apt sources
curl -sL https://deb.nodesource.com/setup | sudo bash -

# install
sudo apt-get install -y nodejs
