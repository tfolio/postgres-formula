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

{% set pillar_get = salt['pillar.get'] %}
{%- if grains['saltversioninfo'] >= [0, 17, 0] %}
{% set runas_param = 'user' %}
{%- else %}
{% set runas_param = 'runas' %}
{%- endif %}

{% if 'users' in pillar.get('postgres', {}) %}
{% set user_defaults = {
  'createdb': False,
  'password': 'changethis',
  'superuser': False,
} %}
{% for name, user in pillar_get('postgres:users').items() %}
postgres-user-{{ name }}:
  postgres_user.present:
    - name: {{ name }}
{%- for param, default in user_defaults.items() %}
    - {{ param }}: {{ pillar_get('postgres:users:{}:{}'.format(name, param), default) }}
{%- endfor %}
    - {{ runas_param }}: postgres
    - require:
      - service: {{ postgres.service }}
{% endfor %}
{% endif %}

{% if 'databases' in pillar.get('postgres', {}) %}
{% set db_defaults = {
  'encoding': 'UTF8',
  'lc_ctype': 'en_US.UTF8',
  'lc_collate': 'en_US.UTF8',
  'template': 'template0',
} %}
{% for name, db in pillar_get('postgres:databases').items()  %}
postgres-db-{{ name }}:
  postgres_database.present:
    - name: {{ name }}
{%- for param, default in db_defaults.items() %}
    - {{ param }}: {{ pillar_get('postgres:databases:{}:{}'.format(name, param), default) }}
{%- endfor %}
    {% if pillar_get('postgres:databases:'+ name +':owner') %}
    - owner: {{ pillar_get('postgres:databases:'+ name +':owner') }}
    {% endif %}
    - {{ runas_param }}: {{ pillar_get('postgres:databases:{}:runas'.format(name), 'postgres') }}
    {% if pillar_get('postgres:databases:'+ name +':user') %}
    - require:
      - postgres_user: postgres-user-{{ pillar_get('postgres:databases:'+ name +':user') }}
    {% endif %}
{% endfor%}
{% endif %}
