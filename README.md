Salt-Hadoop
===========

Install of Hortonworks Data Platform v1.3.3, tested with SaltStack v16.04 and v17.04.

TO RUN salt-hadoop
==================

On minions:

	yum install -y salt-minion; sed -i 's/#master: salt/master: salt.yourserver.com/' /etc/salt/minion; service salt-minion restart

On salt master:

	salt '*' mine.send network.interfaces

	salt '*' state.highstate

	salt 'master.yourserver.com' state.sls utils.format_namenode

	salt 'master.yourserver.com' state.sls utils.start_services.namenode

	salt -C 'G@role:datanode' state.sls utils.start_services.datanode

		Test HDFS at port 50070

	salt 'master.yourserver.com' state.sls utils.mkdir_mapred

	salt 'master.yourserver.com' state.sls utils.chown_mapred

	salt '*' state.sls utils.start_services

		Test MapReduce at port 50030

HADOOP!


Starting HIVE
=============

	chmod 777 /hadoop/hdfs/tmp/;
	chmod 777 /tmp/hadoop-\$USER_NAME\$HUE_SUFFIX/;

	nohup hive --service metastore>/var/log/hive/hive.out 2>/var/log/hive/hive.log & 


	source /etc/profile.d/java.sh


	/usr/lib/hive/bin/hiveserver2 
	Starting HiveServer2


 	/usr/lib/hive/bin/hiveserver2 -hiveconf hive.metastore.uris="thrift://master.yourserver.com:9083" >/var/log/hive/hiveserver2.out 2> /var/log/hive/hiveserver2.log & 

	/usr/lib/hive/bin/beeline

	!connect jdbc:hive2://master.yourserver.com:10000 dbuser dbuserpassword org.apache.hive.jdbc.HiveDriver



Starting WebHCat
=================

	/usr/lib/hcatalog/sbin/webhcat_server.sh start


HBase and Zookeeper
====================

	/usr/lib/zookeeper/bin/zkServer.sh start /etc/hadoop/conf/zoo.cfg

	[root@master ~]# su hdfs
	bash-4.1$ /usr/lib/hadoop/bin/hadoop fs -mkdir /apps/hbase
	bash-4.1$ /usr/lib/hadoop/bin/hadoop fs -chown -R hbase /apps/hbase

	chown hbase:hadoop log,var run, etc/conf

	/usr/lib/hbase/bin/hbase-daemon.sh --config /etc/hbase/conf start master

Reference: http://docs.hortonworks.com/HDPDocuments/HDP1/HDP-1.3.3/bk_installing_manually_book/content/rpm-chap9-4.html



Pillar Data
-----------
Pillar data is used to set values for Hadoop configuration files.

Ex:
In our pillar we have a key of namenode_FQDN which sets the fs.default.name falue in the Hadoop core.site.xml file.

```shell
<name>fs.default.name</name>
<value>hdfs://{{ pillar['namenode_FQDN'] }}:8020</value>
```


Hadoop Install Overview
-----------------------
Install Java:
```shell
yum install java-openjdk
```
Hortonworks RHEL 6 repository:
```shell
wget -nv http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/hdp.repo -O /etc/yum.repos.d/hdp.repo
```
Install Core Hadoop:
```shell
yum install hadoop hadoop-libhdfs hadoop-native hadoop-pipes hadoop-sbin openssl
```
Config files in /etc/hadoop/conf:
- core-site.xml
- mapred-site.xml
- masters
- slaves
- hadoop-env.sh

Users:
- hdfs
- mapred
- hbase
- hcat
- hive
- oozie
- pig
- zookeeper

Directories:
- /home for users
- /var/run for system
- /var/log/hadoop for logs
- /etc/hadoop for config file
- /hadoop for HDFS and MapRed data


Hadoop Start Up Process
-----------------------
A. Format and start HDFS

Execute these commands on the NameNode:
```shell
su hdfs;
/usr/lib/hadoop/bin/hadoop namenode -format; (first time only)
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start namenode;
```
Execute these commands on the Secondary NameNode:
```shell
su hdfs;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start secondarynamenode;
```
Execute these commands on all DataNodes:
```shell
su hdfs;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start datanode;
```
Test HDFS:

See if you can reach the NameNode server with your browser:
http://$namenode.full.hostname:50070

Test browsing HDFS:
http://$datanode.full.hostname:50075/browseDirectory.jsp?dir=/

B. Start MapReduce

Execute these commands from the JobTracker server:
```shell
su hdfs;
/usr/lib/hadoop/bin/hadoop fs -mkdir /mapred; (first time only)
/usr/lib/hadoop/bin/hadoop fs -chown -R mapred /mapred; (first time only)
```
```shell
su mapred;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start jobtracker;
```
Execute these commands from the JobHistory server:
```shell
su mapred;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start historyserver;
```
Execute these commands from all TaskTracker nodes:
```shell
su mapred;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start tasktracker;
```
Test MapReduce:

Browse to the JobTracker:
http://$jobtracker.full.hostname:50030/

Smoke test using Teragen (to generate 10GB of data) and then using Terasort to sort the data:
```shell
su hdfs;
/usr/lib/hadoop/bin/hadoop jar /usr/lib/hadoop/hadoop-examples.jar teragen 100000000 /test/10gsort/input;
/usr/lib/hadoop/bin/hadoop jar /usr/lib/hadoop/hadoop-examples.jar terasort /test/10gsort/input /test/10gsort/output;
/usr/lib/hadoop/bin/hadoop jar /usr/lib/hadoop/hadoop-examples.jar teravalidate /test/10gsort/output /test/10gsort/validate;
```

Hadoop Shutdown Process
-----------------------
A. Stop MapReduce

Execute these commands from all TaskTracker nodes:
```shell
su mapred;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop tasktracker;
```
Execute these commands from the JobHistory server:
```shell
su mapred;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop historyserver;
```
Execute these commands from the JobTracker server:
```shell
su mapred;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop jobtracker;
```

B. Stop HDFS

Execute these commands on all DataNodes:
```shell
su hdfs;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop datanode;
```
Execute these commands on the Secondary NameNode:
```shell
su hdfs;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop secondarynamenode;
```
Execute these commands on the NameNode:
```shell
su hdfs;
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop namenode;
```

Services and Ports
------------------
Namenode
- 0.0.0.0:8020
- 0.0.0.0:50070  <-- NameNode web interface

Datanode
- 0.0.0.0:50075  <-- Browser HDFS
- 0.0.0.0:50010
- 0.0.0.0:8010

JobTracker
- 0.0.0.0:50030  <-- JobTracker web UI
- 0.0.0.0:50300

JobHistory
- 0.0.0.0:51111   <-- JobHistory web UI

TaskTracker
- 0.0.0.0:50060
- 0.0.0.0:36892


The Salt Formula Outline
------------------------
I used the Hortonworks manual install guide for Hadoop, found at the following URL.

http://docs.hortonworks.com/HDPDocuments/HDP1/HDP-1.3.2/bk_installing_manually_book/content/index.html


Install JAVA, set JAVA_HOME path in the hadoop-env.sh config file:
```salt
export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/jre;
export PATH=$JAVA_HOME/bin:$PATH;
```
Download companion files for stock config files:
```shell
wget http://public-repo-1.hortonworks.com/HDP/tools/1.3.0.0/hdp_manual_install_rpm_helper_files-1.3.0.1.3.0.0-107.tar.gz;
tar -zxvf hdp_manual_install_rpm_helper_files-1.3.0.1.3.0.0-107.tar.gz;
cd hdp_manual_install_rpm_helper_files-1.3.0.1.3.0.0-107;
```
Get Hadoop users from the companion scripts:
```shell
cd /root/hdp_manual_install_rpm_helper_files-1.3.0.1.3.0.0-107/scripts;
source usersAndGroups.sh;
source directories.sh;
for i in `grep -i user usersAndGroups.sh | grep -v \# | cut -d= -f2`; do adduser $i; done;
groupadd hadoop;
for i in `grep -i user usersAndGroups.sh | grep -v \# | cut -d= -f2`; do usermod -G hadoop $i; done;
```

Section 4 from the install guide is handled by the 'users' and 'directories' salt states.

4.1 Create namenode directories:
```shell
mkdir -p $DFS_NAME_DIR;
chown -R $HDFS_USER:$HADOOP_GROUP $DFS_NAME_DIR;
chmod -R 755 $DFS_NAME_DIR;
```

4.2 Create second namenode directories:
```shell
mkdir -p $FS_CHECKPOINT_DIR;
chown -R $HDFS_USER:$HADOOP_GROUP $FS_CHECKPOINT_DIR;
chmod -R 755 $FS_CHECKPOINT_DIR;
```
4.3 Create datanode and mapreduce directories:

On all datanodes:
```shell
mkdir -p $DFS_DATA_DIR
chown -R $HDFS_USER:$HADOOP_GROUP $DFS_DATA_DIR
chmod -R 750 $DFS_DATA_DIR
```
On the jobtracker and all datanodes:
```shell
mkdir -p $MAPREDUCE_LOCAL_DIR
chown -R $MAPRED_USER:$HADOOP_GROUP $MAPREDUCE_LOCAL_DIR
chmod -R 755 $MAPREDUCE_LOCAL_DIR
```

4.4 Create log and pid directories for all nodes:
```shell
mkdir -p $HDFS_LOG_DIR;
chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_LOG_DIR;
chmod -R 755 $HDFS_LOG_DIR;
```
```shell
mkdir -p $MAPRED_LOG_DIR;
chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_LOG_DIR;
chmod -R 755 $MAPRED_LOG_DIR;
```
```shell
mkdir -p $HDFS_PID_DIR;
chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_PID_DIR;
chmod -R 755 $HDFS_PID_DIR;
```
```shell
mkdir -p $MAPRED_PID_DIR;
chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_PID_DIR;
chmod -R 755 $MAPRED_PID_DIR;
```


5.0 Edit config files from companion file package.

6.0 Copy config files to /etc/hadoop/conf:
```shell
rm -rf $HADOOP_CONF_DIR;
mkdir -p $HADOOP_CONF_DIR;
```
```shell
cd /root/hdp_manual_install_rpm_helper_files-1.3.0.1.3.0.0-107/configuration_files/core_hadoop;
cp -av core-site.xml /etc/hadoop/conf/;
cp -av hdfs-site.xml /etc/hadoop/conf/;
cp -av mapred-site.xml /etc/hadoop/conf/;
cp -av taskcontroller.cfg /etc/hadoop/conf/;
```
```shell
chmod a+x $HADOOP_CONF_DIR/;
chown -R $HDFS_USER:$HADOOP_GROUP $HADOOP_CONF_DIR/../;
chmod -R 755 $HADOOP_CONF_DIR/../;
```
