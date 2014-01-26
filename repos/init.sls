{% set hadoop_repos = [
    ( 'HDP-1.x', 
      'Hortonworks Data Platform Version - HDP-1.x', 
      'http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA',
      'http://public-repo-1.hortonworks.com/HDP/centos6/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins'),
    ( 'HDP-UTILS-1.1.0.16',
      'Hortonworks Data Platform Utils Version - HDP-UTILS-1.1.0.16',
      'http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.16/repos/centos6',
      'http://public-repo-1.hortonworks.com/HDP/centos5/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins'),
    ( 'Updates-HDP-1.x',
      'HDP-1.x - Updates',
      'http://public-repo-1.hortonworks.com/HDP/centos6/1.x/updates',
      'http://public-repo-1.hortonworks.com/HDP/centos6/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins' )
] %}

{% for name, humanname, baseurl, gpgkey in hadoop_repos %}
{{ name }}:
  pkgrepo.managed:
    - humanname: {{ humanname }}
    - baseurl: {{ baseurl }}
    - gpgcheck: 0
    - gpgkey: {{ gpgkey }}
    - enabled: 1
    - priority: 1
{% endfor %}
