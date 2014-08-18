{% from "postgres/map.jinja" import postgres with context %}

pgadmin3:
  pkg:
    - installed
    - name: {{ postgres.pgadmin3 }}
{#- TODO: RHEL/CentOS need to install this from EPEL #}
