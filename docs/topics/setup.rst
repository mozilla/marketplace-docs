Setup
=====

The Firefox Marketplace is a collection of services and repositories that can
be assembled together to form the Marketplace.

Services
--------

* **Zamboni**: the main backend for the Marketplace, also serves developer
  reviewer and admin tools. Written in Python using
  Django - `source <https://github.com/mozilla/zamboni>`_, `documentation
  <https://zamboni.readthedocs.org>`_.

* **Fireplace**: the consumer front end for the Marketplace, written as a browser
  app in JavaScript using Commonplace and Nunjucks - `source <https://github.com/mozilla/fireplace>`_

* **Monolith**: storage and query server for statistics around the Marketplace,
  written in Python - `source <https://github.com/mozilla/monolith-client>`_,
  aggregator `source <https://github.com/mozilla/monolith-aggregator/>`_

* **Marketplace stats**: is the front end for monolith to display the stats on to
  the end users. Written as a browser app in JavaScript using Commonplace
  - `source <https://github.com/mozilla/marketplace-stats/>`_

* **Webpay** and **Solitude**: servers for processing payments for the Marketplace.
  Written in Python and Django - `webpay source <https://github.com/mozilla/solitude/>`_,
  `webpay docs <https://webpay.readthedocs.org>`_, `solitude source
  <https://github.com/mozilla/webpay/>`_, `solitude docs
  <https://solitdue.readthedocs.org>`_

* **Spartacus**: the front end for webpay. Written in Javascript - `source <https://github.com/mozilla/spartacus>`_

* **Zippy**: a fake backend for payments so to fake out carrier billing. Written
  in JavaScript and Node JS - `source <https://github.com/mozilla/zippy>`_

* **Rocketfuel**: curation tools for the Marketplace. Written in JavaScript and
  Commonplace - `source <https://github.com/mozilla/rocketfuel/>`_

* **Trunion**: a signing service for app receipts and packaged apps. Written in
  Python and Pyramid - `source <https://github.com/mozilla/trunion/>`_

There are other repositories and libraries that are these are dependent upon,
but these are the high level areas.

What should I setup?
--------------------

Most likely you are wanting to work on the consumer, developer or
reveiwer pages. In that case you'll just need zamboni and fireplace.

After that setting up each collection of repositories should only be needed if
you want to work on that area. For example: setting up monolith and marketplace
stats would be needed if you wanted to work on stats. But many developers will
likely not bother.

How to setup
------------

It's in beta and a work in progress, but we strongly recommend you use Docker
since this will do most of these steps for you. See `Docker`_ for more details.

Setup details
-------------

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
~~~~~~~~~~~~~~~~~~~~~~~~~~

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
| Solitude Proxy [1]_ | 2603   |
+---------------------+--------+
| Spartacus           | 2604   |
+---------------------+--------+
| Fireplace           | 8675   |
+---------------------+--------+

.. [1] Solitude Proxy is not normally run by developers, but is given a port
  for completeness

Serving
~~~~~~~

Marketplace is designed to be an app accessible at one domain, hitting nginx.

Behind the scenes nginx will proxy to the other servers on your behalf.

Most developers are using nginx to serve out the multiple services. Your
configuration will look something like this:

.. image:: ../img/configuration.png

You can find a configuration file in `wharfie <https://github.com/mozilla/wharfie/blob/master/images/nginx/nginx.conf>`_.
