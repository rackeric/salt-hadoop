{% set hosts=salt['mine.get']('*','network.interfaces') %}
{% for n in hosts -%}
{{ hosts[n][pillar['hadoop_eth']]['inet'][0]['address'] }} {{ n }}
{% endfor -%}
