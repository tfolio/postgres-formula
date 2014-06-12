{% if grains['oscodename'] in ['wheezy', 'squeeze', 'precise', 'lucid'] -%}
pg-{{ grains['oscodename'] }}-repo:
  pkgrepo.managed:
    - humanname: PostgreSQL Apt Repository ({{ grains['oscodename'] }})
    - name: deb http://apt.postgresql.org/pub/repos/apt/ {{ grains['oscodename'] }}-pgdg main
    - dist: {{ grains['oscodename'] }}-pgdg
    - file: /etc/apt/sources.list.d/wheezy-postgres.list
    - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
    - require_in:
      - pkg: postgresql
{% endif -%}
