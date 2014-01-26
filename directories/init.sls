{% set hadoop_directories = [
    ( '/hadoop/hdfs/nn', 'hdfs', 'hadoop', '755' ),
    ( '/hadoop/hdfs/dn', 'hdfs', 'hadoop', '750' ),
    ( '/hadoop/hdfs/snn', 'hdfs', 'hadoop', '755' ),
    ( '/hadoop/hdfs/tmp', 'hdfs', 'hadoop', '755' ),
    ( '/etc/hadoop', 'hdfs', 'hadoop', '755' ),
    ( '/etc/hadoop/conf', 'hdfs', 'hadoop', '755' ),
    ( '/var/log/hadoop/hdfs', 'hdfs', 'hadoop', '755' ),
    ( '/var/run/hadoop/hdfs', 'hdfs', 'hadoop', '755' ),
    ( '/hadoop/hdfs/mapred', 'mapred', 'hadoop', '755' ),
    ( '/var/log/hadoop/mapred', 'mapred', 'hadoop', '755' ),
    ( '/var/run/hadoop/mapred', 'mapred', 'hadoop', '755' ),
    ( '/etc/hive/conf', 'root', 'hadoop', '755' ),
    ( '/var/log/hive', 'root', 'hadoop', '755' ),
    ( '/var/run/hive', 'root', 'hadoop', '755' ),
    ( '/usr/lib/hcatalog/conf', 'hdfs', 'hadoop', '755' ),
    ( '/var/log/webhcat', 'hdfs', 'hadoop', '755' ),
    ( '/var/run/webhcat', 'hdfs', 'hadoop', '755' ),
    ( '/etc/webhcat/conf', 'root', 'hadoop', '755' ),
    ( '/etc/hbase/conf', 'hdfs', 'hadoop', '755' ),
    ( '/var/log/hbase', 'hdfs', 'hadoop', '755' ),
    ( '/var/run/hbase', 'hdfs', 'hadoop', '755' ),
    ( '/var/data/zookeeper', 'hdfs', 'hadoop', '755' ),
    ( '/etc/zookeeper/conf', 'hdfs', 'hadoop', '755' ),
    ( '/var/log/zookeeper', 'hdfs', 'hadoop', '755' ),
    ( '/var/run/zookeeper', 'hdfs', 'hadoop', '755' ),
    ( '/etc/pig/conf', 'hdfs', 'hadoop', '755' ),
    ( '/etc/oozie/conf', 'hdfs', 'hadoop', '755' ),
    ( '/var/db/oozie', 'hdfs', 'hadoop', '755' ),
    ( '/var/log/oozie', 'hdfs', 'hadoop', '755' ),
    ( '/var/run/oozie', 'hdfs', 'hadoop', '755' ),
    ( '/var/tmp/oozie', 'hdfs', 'hadoop', '755' ),
    ( '/etc/sqoop/conf', 'hdfs', 'hadoop', '755' ),
    ( '/home/hdfs', 'hdfs', 'hdfs', '700' ),
    ( '/home/hdfs/.ssh', 'hdfs', 'hdfs', '700' ),
    ( '/home/mapred', 'mapred', 'mapred', '700' ),
    ( '/home/mapred/.ssh', 'mapred', 'mapred', '700' ),
    ( '/usr/java', 'root', 'root', '755' )
] %}

{% for dir, user, group, mode in hadoop_directories %}
{{ dir }}:
  file.directory:
    - user: {{ user }}
    - group: {{ group }}
    - mode: {{ mode }}
    - makedirs: True
{% endfor %}
