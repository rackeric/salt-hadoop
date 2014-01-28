{% set packages = [ 
    'java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel', 
    'hadoop-libhdfs', 'hadoop-native', 'hadoop-pipes', 'hadoop-sbin', 
    'openssl', 'hadoop', 'snappy', 'snappy-devel', 'hadoop-lzo', 'lzo', 'lzo-devel', 
    'hadoop-lzo-native'
] %}

hadoop_install_pkgs:
  pkg:
    - installed
    - pkgs: {{ packages }}
    - require:
      - pkgrepo: HDP-1.x
      - pkgrepo: HDP-UTILS-1.1.0.16
      - pkgrepo: Updates-HDP-1.x

/usr/lib/hadoop/lib/native/Linux-amd64-64/libsnappy.so:
  file.symlink:
    - target: /usr/lib64/libsnappy.so
    - order: last

/usr/java/default:
  file.symlink:
    - target: /usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/jre
    - order: last

/etc/profile.d/java.sh:
  file.managed:
    - source: salt://hadoop/java.sh
    - user: root
    - group: root
    - mode: 644

{% if grains['id'] == pillar['namenode_FQDN'] %}
{% set extra_packages = [
    'pig', 'hive', 'hcatalog', 'mysql', 'mysql-server', 'mysql-connector-java', 'hue-plugins', 'hue', 'webhcat-tar-hive', 'webhcat-tar-pig', 'zookeeper', 'hbase'
] %}

hadoop_install_extras_pkgs:
  pkg:
    - installed
    - pkgs: {{ extra_packages }}
    - require:
      - pkgrepo: HDP-1.x
      - pkgrepo: HDP-UTILS-1.1.0.16
      - pkgrepo: Updates-HDP-1.x

mysqld:
  service:
    - running
    - require:
      - pkg: hadoop_install_extras_pkgs

/usr/lib/hive/lib/mysql-connector-java-5.1.17.jar:
  file.symlink:
    - target: /usr/share/java/mysql-connector-java-5.1.17.jar
    - require:
      - pkg: hadoop_install_extras_pkgs

/usr/lib/hive/lib/mysql-connector-java.jar:
  file.symlink:
    - target: /usr/share/java/mysql-connector-java.jar
    - require:
      - pkg: hadoop_install_extras_pkgs

{% endif %}
