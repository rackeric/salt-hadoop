/home/hdfs/.ssh/id_rsa:
  file.managed:
    - source: salt://ssh_keys/id_rsa
    - template: jinja
    - user: hdfs
    - group: hadoop
    - mode: 600

/home/mapred/.ssh/id_rsa:
  file.managed:
    - source: salt://ssh_keys/id_rsa
    - template: jinja
    - user: mapred
    - group: hadoop
    - mode: 600

/home/hdfs/.ssh/authorized_keys:
  file.managed:
    - source: salt://ssh_keys/authorized_keys
    - template: jinja
    - user: hdfs
    - group: hadoop
    - mode: 600

/home/mapred/.ssh/authorized_keys:
  file.managed:
    - source: salt://ssh_keys/authorized_keys
    - template: jinja
    - user: mapred
    - group: hadoop
    - mode: 600
