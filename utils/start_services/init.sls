{% if grains['role'] == 'namenode' %}
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start namenode:
  cmd.run:
    - user: hdfs
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start jobtracker:
  cmd.run:
    - user: mapred
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start historyserver:
  cmd.run:
    - user: mapred
{% elif grains['role'] == 'datanode' %}
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start datanode:
  cmd.run:
    - user: hdfs
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start tasktracker:
  cmd.run:
    - user: mapred
{% endif %}
