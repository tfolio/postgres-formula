========
postgres
========

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``postgres``
------------

Installs the postgresql package.

``postgres.config``
-------------------

Installs a ``postgresql.conf`` file with defaults based on the config section
of a tutorial on PostgreSQL (slides_).

.. _slides: http://thebuild.com/presentations/pycon-2014-pppp.pdf

``postgres.python``
-------------------

Installs the postgresql python module
