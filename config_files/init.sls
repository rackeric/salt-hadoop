include:
  - utils.set_roles

{# push hadoop config files #}
{% set hadoop_files = [
    ( '/etc/hadoop/conf/capacity-scheduler.xml', 'config_files/core_hadoop/capacity-scheduler.xml' ),
    ( '/etc/hadoop/conf/commons-logging.properties', 'config_files/core_hadoop/commons-logging.properties' ),
    ( '/etc/hadoop/conf/core-site.xml', 'config_files/core_hadoop/core-site.xml' ),
    ( '/etc/hadoop/conf/hdfs-site.xml', 'config_files/core_hadoop/hdfs-site.xml' ),
    ( '/etc/hadoop/conf/mapred-site.xml', 'config_files/core_hadoop/mapred-site.xml' ),
    ( '/etc/hadoop/conf/taskcontroller.cfg', 'config_files/core_hadoop/taskcontroller.cfg' ),
    ( '/etc/hadoop/conf/masters', 'config_files/core_hadoop/masters' ),
    ( '/etc/hadoop/conf/slaves' , 'config_files/core_hadoop/slaves' ),
    ( '/etc/hadoop/conf/hadoop-env.sh', 'config_files/core_hadoop/hadoop-env.sh' ),
    ( '/etc/hadoop/conf/hadoop-metrics2.properties', 'config_files/core_hadoop/hadoop-metrics2.properties' ),
    ( '/etc/hadoop/conf/hadoop-metrics2.properties-GANGLIA', 'config_files/core_hadoop/hadoop-metrics2.properties-GANGLIA' ),
    ( '/etc/hadoop/conf/hadoop-policy.xml', 'config_files/core_hadoop/hadoop-policy.xml' ),
    ( '/etc/hadoop/conf/health_check', 'config_files/core_hadoop/health_check' ),
    ( '/etc/hadoop/conf/mapred-queue-acls.xml', 'config_files/core_hadoop/mapred-queue-acls.xml')
] %}

{% for name, source in hadoop_files %}
{{ name }}:
  file.managed:
    - source: salt://{{ source }}
    - template: jinja
    - user: hdfs
    - group: hadoop
    - mode: 755
    - require:
      - sls: utils.set_roles
{% endfor %}


{# push pig config files #}
{% set pig_files = [
    ( '/etc/pig/conf/log4j.properties', 'config_files/pig/log4j.properties' ),
    ( '/etc/pig/conf/pig-env.sh', 'config_files/pig/pig-env.sh' ),
    ( '/etc/pig/conf/pig.properties', 'config_files/pig/pig.properties' )
] %}

{% for name, source in pig_files %}
{{ name }}:
  file.managed:
    - source: salt://{{ source }}
    - user: root
    - group: root
    - mode: 644
{% endfor %}


{# push hive config files #}
{% set hive_files = [
    ( '/etc/hive/conf/hive-site.xml', 'config_files/hive/hive-site.xml' ),
    ( '/etc/hive/conf/hive-env.sh', 'config_files/hive/hive-env.sh' )
] %}

{% for name, source in hive_files %}
{{ name }}:
  file.managed:
    - source: salt://{{ source }}
    - template: jinja
    - user: root
    - group: hadoop
    - mode: 644
{% endfor %}


{# push webhcat config files #}
{% set webhcat_files = [
    ( '/etc/webhcat/conf/webhcat-site.xml', 'config_files/webhcat/webhcat-site.xml' ),
    ( '/etc/webhcat/conf/webhcat-env.sh', 'config_files/webhcat/webhcat-env.sh' )
] %}

{% for name, source in webhcat_files %}
{{ name }}:
  file.managed:
    - source: salt://{{ source }}
    - template: jinja
    - user: root
    - group: hadoop
    - mode: 644
{% endfor %}


{# push hbase config files #}
{% set hbase_files = [
    ( '/etc/hbase/conf/hadoop-metrics.properties', 'config_files/hbase/hadoop-metrics.properties' ),
    ( '/etc/hbase/conf/hadoop-metrics.properties.master-GANGLIA', 'config_files/hbase/hadoop-metrics.properties.master-GANGLIA' ),
    ( '/etc/hbase/conf/hadoop-metrics.properties.regionservers-GANGLIA', 'config_files/hbase/hadoop-metrics.properties.regionservers-GANGLIA' ),
    ( '/etc/hbase/conf/hbase-env.sh', 'config_files/hbase/hbase-env.sh' ),
    ( '/etc/hbase/conf/hbase-policy.xml', 'config_files/hbase/hbase-policy.xml' ),
    ( '/etc/hbase/conf/hbase-site.xml', 'config_files/hbase/hbase-site.xml' ),
    ( '/etc/hbase/conf/log4j.properties', 'config_files/hbase/log4j.properties' ),
    ( '/etc/hbase/conf/regionservers', 'config_files/hbase/regionservers' )
] %}

{% for name, source in hbase_files %}
{{ name }}:
  file.managed:
    - source: salt://{{ source }}
    - template: jinja
    - user: root
    - group: hadoop
    - mode: 644
{% endfor %}


{# push zookeeper config files #}
{% set zookeeper_files = [
    ( '/etc/zookeeper/conf/configuration.xsl', 'config_files/zookeeper/configuration.xsl' ),
    ( '/etc/zookeeper/conf/log4j.properties', 'config_files/zookeeper/log4j.properties' ),
    ( '/etc/zookeeper/conf/zoo.cfg', 'config_files/zookeeper/zoo.cfg' ),
    ( '/etc/zookeeper/conf/zookeeper-env.sh', 'config_files/zookeeper/zookeeper-env.sh' )
] %}

{% for name, source in zookeeper_files %}
{{ name }}:
  file.managed:
    - source: salt://{{ source }}
    - template: jinja
    - user: root
    - group: hadoop
    - mode: 644
{% endfor %}



{# push hue config files #}
{% set hue_files = [
    ( '/etc/hue/conf/hue-site.xml', 'config_files/hue/hue-site.xml' ),
    ( '/etc/hue/conf/log.conf', 'config_files/hue/log.conf' ),
] %}

{% for name, source in hue_files %}
{{ name }}:
  file.managed:
    - source: salt://{{ source }}
    - template: jinja
    - user: root
    - group: hadoop
    - mode: 644
{% endfor %}

