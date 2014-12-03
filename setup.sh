#!/bin/sh

echo setup a hadoop single node cluster
echo 

HADOOP_MIRROR="http://mirror.switch.ch/mirror/apache/dist/hadoop/common"
HADOOP_VERSION="2.6.0"
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

echo  '>>>>' get ssh, rsync, 7z if not already there

sudo apt-get -y install ssh
sudo apt-get -y install rsync
sudo apt-get -y install p7zip

echo  '>>>>' get Hadoop package


sudo rm -rf tmp
mkdir -p tmp 
cd tmp
wget ${HADOOP_MIRROR}/${HADOOP_DIR}/${HADOOP_TAR}
tar xozf ${HADOOP_TAR}
sudo rm -rf ${HADOOP_PATH}
sudo chown -R bin.bin ${HADOOP_DIR}
sudo mv ${HADOOP_DIR} ${HADOOP_PATH}
sudo rm -rf ${HADOOP_PREFIX}/hadoop
sudo ln -s ${HADOOP_PATH} ${HADOOP_PREFIX}/hadoop
cd ${SETUPDIR}
echo cd ${SETUPDIR}

echo '>>>>' setup user and group

sudo adduser --system --group --no-create-home hadoop

ME=`id -n -u`
sudo adduser $ME hadoop


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
echo '>>>>' setup LOGFILE

sudo mkdir ${HADOOP_PATH}/logs
sudo chown hadoop.hadoop ${HADOOP_PATH}/logs
sudo chmod 775 ${HADOOP_PATH}/logs


echo '>>>>' setup ssh for localhost

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

echo '>>>>' format HDFS

${HADOOP_PATH}/bin/hdfs namenode -format

echo TODO: create startup files


echo TODO: start instance

