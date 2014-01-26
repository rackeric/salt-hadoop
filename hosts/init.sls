include:
 - utils.set_roles

/etc/hosts:
  file.managed:
    - source: salt://hosts/hosts_file.sls
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - sls: utils.set_roles
