Setup
=====

The Firefox Marketplace is a collection of services and repositories that
together form the Marketplace.

Services
--------

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

What should I setup?
--------------------

We recommend using Docker to set up a Marketplace development environment. See
:ref:`docker` for more details. Proceed if you wish to set things up manually.

Most likely you are wanting to work on the consumer, developer or reviewer
pages. In that case, you'll just need Zamboni and Fireplace. After that,
setting up other repositories would only be needed if you wanted to work within
a specific component. For example, setting up monolith and marketplace-stats
would be needed if you wanted to work on statistics.

.. _consumer-setup-label:

Consumer pages only
~~~~~~~~~~~~~~~~~~~

The frontend can set up and be run with just Fireplace installed.

1. Install requirements
+++++++++++++++++++++++

The recommended solution for installing on OS X is `Homebrew
<http://brew.sh/>`_::

  brew install node npm

2. Install Fireplace
++++++++++++++++++++

Fork the repository and then clone the repository from https://github.com/mozilla/fireplace/

Then run::

  cd fireplace
  make init
  cp src/media/js/settings_flue_paas.js.dist src/media/js/settings_local.js
  make serve

Then open your browser to http://localhost:8675/

You should have a working version of Fireplace, connected to Flue, a fake
version of the Marketplace that provides some API responses. Flue doesn't
implement the entire Marketplace API, just a subset.

.. _backend-setup-label:

Backend pages
~~~~~~~~~~~~~

We recommend using Docker to set up the backend, as it is quite complicated.
See :ref:`docker` for more details.

Environment Variables
~~~~~~~~~~~~~~~~~~~~~

To configure the services in the marketplace, you can either override each
project's settings file (see documentation on each project for how that would
look). Or you can alter a few environment variables that all the projects use.
This is the **recommended approach** for setting up the marketplace until you
feel more comfortable with the settings in the marketplace.

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

Serving
~~~~~~~

Marketplace is designed to be an app accessible at one domain, hitting nginx.

Behind the scenes nginx will proxy to the other servers on your behalf.

Most developers are using nginx to serve out the multiple services. Your
configuration may look something like this:

.. image:: ../img/configuration.png

You can find a configuration file in `wharfie <https://github.com/mozilla/wharfie/blob/master/images/nginx/nginx.conf>`_.
