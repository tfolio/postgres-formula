{% from "postgres/map.jinja" import postgres with context %}

{{ salt['pillar.get']('postgres:config_dir', postgres.config_dir) }}/postgresql.conf:
  file:
    - managed
    - source: salt://postgres/files/postgresql.conf.jinja
    - user: postgres
    - group: postgres
    - mode: 644
    - template: jinja
    - require:
      - pkg: postgresql
    - watch_in:
      - service: postgresql
