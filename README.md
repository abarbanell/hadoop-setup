hadoop-setup
============

setup script for a single node hadoop cluster on a Ubuntu server

usage: 

```sh
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get install git-core
$ git clone https://github.com/abarbanell/hadoop-setup.git
$ cd hadoop-setup
$ ./setup.sh
```

Status: (2014-10-05) works on Azure Linux image, installs hadoop software and prerequisiste.

But the configuartion of cluster is not yet done, also the automatic startup of hadoop services is not done yet.


