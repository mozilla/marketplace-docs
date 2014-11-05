Setup
=====

The Firefox Marketplace is a collection of services and repositories that
together form the Marketplace.


Setting up the Marketplace Frontend
-----------------------------------

If you want to work on the consumer-facing Marketplace frontend, visit our
:refs:`frontend` documentation. It only takes three commands to get things
up and running. You don't even need to setup a backend, although in some cases,
you might want to.

.. _backend-setup-label:


Setting up the Marketplace Backend
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To set up more of the backend, API, and payments infrastructure, visit our
:ref:`docker` documentation. Docker will automate the setup of a Marketplace
environment.


List of Services and Repositories
---------------------------------

Backend
~~~~~~~

* **Zamboni**: the main API backend that also serves developer, reviewer, and admin tools.
  Written in Python with Django -
  `source <https://github.com/mozilla/zamboni>`_,
  `docs <https://zamboni.readthedocs.org>`_.

* **Flue**: a fake API backend used for testing.
  Written in Python with Flask -
  `source <https://github.com/mozilla/flue>`_,

* **Monolith**: storage and query server for statistics around the Marketplace.
  Written in Python -
  `source <https://github.com/mozilla/monolith-client>`_,
  `aggregator source <https://github.com/mozilla/monolith-aggregator/>`_

* **Webpay** and **Solitude**: servers for processing payments for the Marketplace.
  Written in Python with Django -
  `webpay source <https://github.com/mozilla/solitude/>`_,
  `webpay docs <https://webpay.readthedocs.org>`_,
  `solitude source <https://github.com/mozilla/webpay/>`_,
  `solitude docs <https://solitude.readthedocs.org>`_

* **Trunion**: a signing service for app receipts and packaged apps.
  Written in Python with Pyramid -
  `source <https://github.com/mozilla/trunion/>`_

* **Zippy**: a fake backend for payments so to fake out carrier billing.
  Written in Node -
  `source <https://github.com/mozilla/zippy>`_

Frontend (Javascript)
~~~~~~~~~~~~~~~~~~~~~

* **Fireplace**: the actual consumer frontend for the Marketplace.
  Written in Javascript with our Commonplace framework -
  `source <https://github.com/mozilla/fireplace>`_

* **Statistics**: dashboard that displays charts and graphs from Monolith.
  Written in Javascript with our Commonplace framework -
  `source <https://github.com/mozilla/marketplace-stats/>`_

* **Transonic**: curation and editorial tools for the Marketplace, notably for the Feed.
  Written in Javascript with our Commonplace framework -
  `source <https://github.com/mozilla/transonic/>`_

* **Operator Dashboard**: dashboard for FirefoxOS operators to manage their app collections.
  Written in Javascript with our Commonplace framework -
  `source <https://github.com/mozilla/commbadge/>`_

* **Commbadge**: dashboard for communications between app reviewers and app developers.
  Written in Javascript with our Commonplace framework -
  `source <https://github.com/mozilla/commbadge/>`_

* **Spartacus**: the frontend for Webpay.
  Written in Javascript -
  `source <https://github.com/mozilla/spartacus>`_

Frontend Components (Javascript)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **marketplace-core-modules**: core JS modules for Marketplace frontend projects
  Written in Javascript -
  `source <https://github.com/mozilla/marketplace-core-modules>`_

* **commonplace**: Node module that includes configuration, template optimization, l10n.
  Written in Node -
  `source <https://github.com/mozilla/commonplace>`_

* **marketplace-gulp**: gulpfiles for Marketplace frontend projects for builds.
  Written in Node -
  `source <https://github.com/mozilla/marketplace-gulp>`_

* **marketplace-constants**: shared constants between the backend and frontend.
  Written in Python -
  `source <https://github.com/mozilla/marketplace-constants>`_

.. _consumer-setup-label:


Environment Variables
~~~~~~~~~~~~~~~~~~~~~

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

Other environment variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please be aware that other parts of the site infrastructure can be affected by
environment variables. Some examples:

* If you want to use custom Django settings, you can set
  `DJANGO_SETTINGS_MODULE <https://docs.djangoproject.com/en/dev/topics/settings/#designating-the-settings>`_

Default ports
~~~~~~~~~~~~~

By default the services listen to the following ports:

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

Serving With Nginx
~~~~~~~~~~~~~~~~~~

Marketplace is designed to be an app accessible at one domain, hitting Nginx.

Behind the scenes Nginx will proxy to the other servers on your behalf.

Most developers are using Nginx to serve out the multiple services. Your
configuration may look something like this:

.. image:: ../img/configuration.png

You can find an example configuration file in
`wharfie <https://github.com/mozilla/wharfie/blob/master/images/nginx/nginx.conf>`_.
