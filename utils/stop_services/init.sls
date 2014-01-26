{% if grains['role'] == 'namenode' %}
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop namenode:
  cmd.run:
    - user: hdfs
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop jobtracker:
  cmd.run:
    - user: mapred
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop historyserver:
  cmd.run:
    - user: mapred
{% elif grains['role'] == 'datanode' %}
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop datanode:
  cmd.run:
    - user: hdfs
/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf stop tasktracker:
  cmd.run:
    - user: mapred
{% endif %}
