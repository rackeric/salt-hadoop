base:
  '*':
    - utils.set_roles
    - upgrade
    - ntp
    - users
    - repos
    - services
    - hadoop
    - directories
    - config_files
    - ssh_keys
    - hosts
