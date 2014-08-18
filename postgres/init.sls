{% from "postgres/map.jinja" import postgres, postgres_version with context %}

postgresql:

  pkg:
    - installed
    - name: {{ postgres.pkg }}

  service:
    - running
    - enable: true
    - name: {{ postgres.service }}
    - require:
      - pkg: {{ postgres.pkg }}

      
postgresql-server-dev-{{ postgres_version }}:
  pkg.installed
  
libpq-dev:
  pkg.installed

python-dev:
  pkg.installed

{% if 'users' in pillar.get('postgres', {}) %}
{% for name, user in salt['pillar.get']('postgres:users').items()  %}
postgres-user-{{ name }}:
  postgres_user.present:
    - name: {{ name }}
    - createdb: {{ salt['pillar.get']('postgres:users:' + name + ':createdb', False) }}
    - password: {{ salt['pillar.get']('postgres:users:' + name + ':password', 'changethis') }}
    - runas: postgres
    - require:
      - service: {{ postgres.service }}
{% endfor%}
{% endif %}

{% if 'databases' in pillar.get('postgres', {}) %}
{% for name, db in salt['pillar.get']('postgres:databases').items()  %}
postgres-db-{{ name }}:
  postgres_database.present:
    - name: {{ name }}
    - encoding: {{ salt['pillar.get']('postgres:databases:'+ name +':encoding', 'UTF8') }}
    - lc_ctype: {{ salt['pillar.get']('postgres:databases:'+ name +':lc_ctype', 'en_US.UTF8') }}
    - lc_collate: {{ salt['pillar.get']('postgres:databases:'+ name +':lc_collate', 'en_US.UTF8') }}
    - template: {{ salt['pillar.get']('postgres:databases:'+ name +':template', 'template0') }}
    {% if salt['pillar.get']('postgres:databases:'+ name +':owner') %}
    - owner: {{ salt['pillar.get']('postgres:databases:'+ name +':owner') }}
    {% endif %}
    - runas: {{ salt['pillar.get']('postgres:databases:'+ name +':runas', 'postgres') }}
    {% if salt['pillar.get']('postgres:databases:'+ name +':user') %}
    - require:
        - postgres_user: postgres-user-{{ salt['pillar.get']('postgres:databases:'+ name +':user') }}
    {% endif %}
{% endfor%}
{% endif %}
