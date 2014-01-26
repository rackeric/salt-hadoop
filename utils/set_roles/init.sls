grains:
  {% set master_starts_with = pillar['namenode_starts_with'] %}
  {% set slave_starts_with = pillar['snamenode_starts_with'] %}
  {% set name = grains['id'] %}
  {% if name.startswith(master_starts_with) %}
    grains.present:
      - name: role
      - value: namenode
  {% elif name.startswith('snamenode') %}
    grains.present:
      - name: role
      - value: snamenode
  {% else %}
    grains.present:
      - name: role
      - value: datanode
  {% endif %}
