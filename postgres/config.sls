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
      - pkg: {{ postgres.pkg }}
    - watch_in:
      - service: postgresql

{% if 'pg_hba.conf' in pillar.get('postgres', {}) %}
pg_hba.conf:
  file.managed:
    - name: {{ postgres.config_dir }}/pg_hba.conf
    - source: {{ salt['pillar.get']('postgres:pg_hba.conf', 'salt://postgres/pg_hba.conf') }}
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
      - pkg: {{ postgres.pkg }}
    - watch_in:
      - service: postgresql
{% endif %}
