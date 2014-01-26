{% set hadoop_users = [
    ( 'pig', 'PIG user', '/bin/bash', '/home/pig' ),
    ( 'webhcat', 'HCAT user', '/bin/bash', '/usr/lib/hcatalog' ),
] %}

{% for user, fullname, shell, home in hadoop_users %}
{{ user }}:
  user.present:
    - fullname: {{ fullname }}
    - shell: {{ shell }}
    - home: {{ home }}
    - groups:
      - hadoop
    - require:
      - group: hadoop_group

{% endfor %}

hadoop_group:
  group.present:
    - name: hadoop
