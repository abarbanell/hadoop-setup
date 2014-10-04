#!/bin/sh

echo setup a hadoop single node cluster
echo 

HADOOP_MIRROR="http://mirror.switch.ch"
HADOOP_VERSION="2.5.1"
PWD=`pwd`

echo '>>>>' create locale if it does not exist

sudo locale-gen "de_CH:UTF-8"

echo '>>>>' get java 

sudo apt-get install -y openjdk-7-jdk
sudo rm -rf /etc/profile.d/openjdk.sh
sudo sh -c "cat > /etc/profile.d/openjdk.sh <<EOF
# Environment for Java
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

EOF
"

. ~/.bashrc

echo  '>>>>' get ssh and rsync if not already there

sudo apt-get -y install ssh
sudo apt-get -y install rsync

echo  '>>>>' get Hadoop package

HADOOP_DIR=hadoop-${HADOOP_VERSION}
HADOOP_TAR=${HADOOP_DIR}.tar.gz

sudo rm -rf tmp
mkdir -p tmp 
cd tmp
wget ${HADOOP_MIRROR}/mirror/apache/dist/hadoop/common/stable/${HADOOP_TAR}
tar xvozf ${HADOOP_TAR}
sudo rm -rf /opt/${HADOOP_DIR}
sudo chown -R bin.bin ${HADOOP_DIR}
sudo mv ${HADOOP_DIR} /opt
sudo rm -rf /opt/hadoop
sudo ln -s /opt/${HADOOP_DIR} /opt/hadoop

echo TODO: set environment


