#!/bin/sh

echo setup a hadoop single node cluster
echo 

HADOOP_MIRROR="http://mirror.switch.ch"
HADOOP_VERSION="2.5.1"
HADOOP_DIR=hadoop-${HADOOP_VERSION}
HADOOP_TAR=${HADOOP_DIR}.tar.gz
HADOOP_PREFIX=/usr/local
HADOOP_PATH=${HADOOP_PREFIX}/${HADOOP_DIR}

SETUPDIR=`pwd`
echo "PWD set to $PWD"

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


sudo rm -rf tmp
mkdir -p tmp 
cd tmp
wget ${HADOOP_MIRROR}/mirror/apache/dist/hadoop/common/stable/${HADOOP_TAR}
tar xozf ${HADOOP_TAR}
sudo rm -rf ${HADOOP_PATH}
sudo chown -R bin.bin ${HADOOP_DIR}
sudo mv ${HADOOP_DIR} ${HADOOP_PATH}
sudo rm -rf ${HADOOP_PREFIX}/hadoop
sudo ln -s ${HADOOP_PATH} ${HADOOP_PREFIX}/hadoop
cd ${SETUPDIR}
echo cd ${SETUPDIR}

echo '>>>>' set up environment for pseudo-distributed

for file in core-site.xml hdfs-site.xml
do
	sudo cp conf/${file} ${HADOOP_PATH}/etc/hadoop
	sudo chown bin.bin ${HADOOP_PATH}/etc/hadoop/${file}
	echo copied ${file} to ${HADOOP_PATH}/etc/hadoop
done
 
sudo cp ${HADOOP_PATH}/etc/hadoop/hadoop-env.sh ${HADOOP_PATH}/etc/hadoop/hadoop-env.sh.orig

sudo sh -c "sed -e 's/^export JAVA_HOME=\${JAVA_HOME}/export JAVA_HOME=\/usr\/lib\/jvm\/java-7-openjdk-amd64/' <${HADOOP_PATH}/etc/hadoop/hadoop-env.sh.orig >${HADOOP_PATH}/etc/hadoop/hadoop-env.sh " 

sudo sh -c "cat >> ${HADOOP_PATH}/etc/hadoop/hadoop-env.sh <<EOF
	# our installation directory is /usr/local/hadoop
	export HADOOP_PREFIX=/usr/local/hadoop

EOF
"
echo TODO: setup ssh for localhost

ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys

echo TODO: format HDFS

${HADOOP_PATH}/bin/hdfs namenode -format

echo TODO: create startup files



