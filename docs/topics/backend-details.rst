.. _backend-details:

Marketplace Backend Details
===========================

`docker-compose` Commands
~~~~~~~~~~~~~~~~~~~~~~~~~

This is not a full list of commands, for that see the
`docker-compose docs <https://docs.docker.com/compose/>`, just notable ones.

.. function:: docker-compose up [-d]

Use this if you would like all the service logs in the foreground run::

    docker-compose up  # Ctrl-c here will shutdown all services.

.. function:: docker-compose logs

View log output from a project's container.


`docker` Commands
~~~~~~~~~~~~~~~~~

For docs see: https://docs.docker.com/

FAQ
---

How do I run commands?
~~~~~~~~~~~~~~~~~~~~~~

It's easiest to think of the containers as Linux machines you can shell into
to run various commands.

Docker labels each container with a prefix of 'mkt' (as defined by
``COMPOSE_PROJECT_NAME`` environment variable) and a numeric suffix, which will
be 1 unless you are running multiple of the same container.

So you can shell into any container by running (for zamboni, e.g.)::

    docker exec -ti mkt_zamboni_1 /bin/bash

From there you can run migrations::

    schematic migrations/

or the unit tests::

  ./manage.py test --noinput -s --logging-clear-handlers

Another option is to spawn up a new instance of the container temporarily to
run a command, e.g.::

  docker-compose run --rm zamboni schematic migrations/

How do I update python/node package deps (rebuild the container)?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. First `stop the machine <https://marketplace.readthedocs.org/en/latest/topics/backend.html#shutting-down-and-restarting>`_ with your OS-specific instructions.

2. Then pull the newest images from Docker Hub:

  docker-compose pull [project]

3. Then `start the machine <https://marketplace.readthedocs.org/en/latest/topics/backend.html#shutting-down-and-restarting>`_ with your OS-specific instructions.

How do I add an admin in Zamboni with docker?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Simply run this command replacing name@email.com with the email of the user
you've recently logged-in as::

    docker-compose run --rm zamboni python manage.py addusertogroup name@email.com 1

How do I upgrade docker?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Upgrade a machine to the latest version of Docker::

    docker-machine upgrade

Environment
-----------

To configure the services in the Marketplace, you can either override each
project's settings file (see documentation on each project for how that would
look). Or you can alter a few environment variables that all the projects use.
This is the **recommended approach** for setting up the Marketplace until you
feel more comfortable with the settings in the Marketplace.

This documentation assumes that you know how to set environment variables on
your development platform.

+----------------------+--------------------+----------------------------+--------------------------------------+
+ Environment variable | Used by            | Description                | Default                              |
+======================+====================+============================+======================================+
| MARKETPLACE_URL      | Webpay             | URL to nginx               | http://localhost/                    |
+----------------------+--------------------+----------------------------+--------------------------------------+
| MEMCACHE_URL         | Zamboni, Webpay,   | The location of memcache   | localhost:11211                      |
|                      | Solitude           |                            |                                      |
+----------------------+--------------------+----------------------------+--------------------------------------+
| REDIS_URL            | Zamboni            | URL to redis               | redis://localhost:6379               |
+----------------------+--------------------+----------------------------+--------------------------------------+
| SIGNING_SERVER       | Zamboni            | URL to signing server      | (empty string)                       |
+----------------------+--------------------+----------------------------+--------------------------------------+
| SOLITUDE_DATABASE    | Solitude           | dj_database_url compliant  | mysql://root@localhost:3306/solitude |
|                      |                    | URL to solitude Mysql      |                                      |
+----------------------+--------------------+----------------------------+--------------------------------------+
| SOLITUDE_URL         | Zamboni, Webpay    | URL to solitude instance   | http://localhost:2602                |
+----------------------+--------------------+----------------------------+--------------------------------------+
| SPARTACUS_STATIC     | Webpay             | URL to Spartacus static    | http://localhost:2604                |
|                      |                    | files                      |                                      |
+----------------------+--------------------+----------------------------+--------------------------------------+
| ZAMBONI_DATABASE     | Zamboni            | dj_database_url compliant  | mysql://root@localhost:3306/zamboni  |
|                      |                    | URL to zamboni Mysql       |                                      |
+----------------------+--------------------+----------------------------+--------------------------------------+
| RABBIT_HOST          | Rabbit             | Rabbit hostname            | localhost                            |
+----------------------+--------------------+----------------------------+--------------------------------------+

Other Environment Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please be aware that other parts of the site infrastructure can be affected by
environment variables. Some examples:

* If you want to use custom Django settings, you can set
  `DJANGO_SETTINGS_MODULE <https://docs.djangoproject.com/en/dev/topics/settings/#designating-the-settings>`_

Serving With Nginx
~~~~~~~~~~~~~~~~~~

Marketplace is designed to be an app accessible at one domain, hitting Nginx.

Behind the scenes Nginx will proxy to the other servers on your behalf.

Most developers are using Nginx to serve out the multiple services. Your
configuration may look something like this:

.. image:: ../img/configuration.png

You can find an example configuration file in
`our Docker repository <https://github.com/mozilla/marketplace-env/blob/master/images/nginx/nginx.conf>`_.

Default Ports
~~~~~~~~~~~~~

By default, the services listen to the following ports:

+---------------------+--------+
| Project             | Port   |
+=====================+========+
| Zamboni             | 2600   |
+---------------------+--------+
| Webpay              | 2601   |
+---------------------+--------+
| Solitude            | 2602   |
+---------------------+--------+
| Solitude Proxy      | 2603   |
+---------------------+--------+
| Spartacus           | 2604   |
+---------------------+--------+
| Zippy               | 2605   |
+---------------------+--------+
| Signing server      | 2606   |
+---------------------+--------+
| Fireplace           | 8675   |
+---------------------+--------+
| Commbadge           | 8676   |
+---------------------+--------+
| Statistics          | 8677   |
+---------------------+--------+
| Transonic           | 8678   |
+---------------------+--------+
| Operator Dashboard  | 8679   |
+---------------------+--------+
| Receipt verifier    | 9000   |
+---------------------+--------+

External services
~~~~~~~~~~~~~~~~~

The Marketplace interacts with multiple remote services that are not under the
control of the Marketplace team.

+-------------------------------+-----------------+------------------+-------------+
| Marketplace server            | Reason          | External         | Type        |
+===============================+=================+==================+=============+
| marketplace-dev.allizom.org   | Payments        | Zippy            | Test        |
|                               +-----------------+------------------+-------------+
|                               | Content Ratings | IARC             | Test        |
|                               +-----------------+------------------+-------------+
|                               | Authentication  | Firefox Accounts | Latest      |
+-------------------------------+-----------------+------------------+-------------+
| marketplace.allizom.org       | Payments        | Bango            | Prod        |
|                               +-----------------+------------------+-------------+
|                               | Payments        | Boku             | Prod        |
|                               +-----------------+------------------+-------------+
|                               | Content Ratings | IARC             | Test        |
|                               +-----------------+------------------+-------------+
|                               | Authentication  | Firefox Accounts | Prod        |
+-------------------------------+-----------------+------------------+-------------+
| payments-alt.allizom.org      | Payments        | Bango            | Prod        |
|                               +-----------------+------------------+-------------+
|                               | Payments        | Boku             | Prod        |
|                               +-----------------+------------------+-------------+
|                               | Content Ratings | IARC             | Test        |
|                               +-----------------+------------------+-------------+
|                               | Authentication  | Firefox Accounts | Latest      |
+-------------------------------+-----------------+------------------+-------------+
| marketplace.firefox.com       | Payments        | Bango            | Prod        |
|                               +-----------------+------------------+-------------+
|                               | Payments        | Boku             | Prod        |
|                               +-----------------+------------------+-------------+
|                               | Content Ratings | IARC             | Prod        |
|                               +-----------------+------------------+-------------+
|                               | Authentication  | Firefox Accounts | Prod        |
+-------------------------------+-----------------+------------------+-------------+

Notes:

* **Zippy**: is a reference implemention of the `Marketplace Payments Specification <http://marketplace-payments-specification.readthedocs.org/en/latest/>`_ to enable easy testing and development.
* **Bango and Boku**: do not provide test instances.
* **Boku**: uses a different set of integrator keys for different servers, please see the internal docs on mana.
* **Firefox Accounts**: native flow on a device connects to the production Firefox
  Accounts. The web based flow connects to the servers as noted above.
