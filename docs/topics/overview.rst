Overview
========

The Firefox Marketplace is a collection of services and repositories that
together form the Marketplace.

Our recommended setup for the backend is to use :ref:`Docker <backend>`. And our
recommended setup for the frontend is to clone the repository as detailed
in our :ref:`frontend` documentation. By default, the frontend setup will point
to our development server and database. But if you wanted a full environment,
you can set up both the backend and frontend, and point your frontend towards
the backend set up by Docker.


Setting up the Backend
----------------------

If you want to work on the backend, the API, or the payments infrastructure,
visit our :ref:`backend` documentation. It will explain how to
set up Docker as it automates the setup of the Marketplace environment.


Setting up the Frontend
-----------------------

If you want to work on the consumer-facing Marketplace frontend, visit our
:ref:`frontend` documentation. It only takes three commands to get things
up and running. You don't even need to setup a backend, although you could
if you wanted your own personal playground.


List of Services and Repositories
---------------------------------

Backend
~~~~~~~

* **Zamboni**: the main API backend that also serves developer, reviewer, and admin tool pages.
  Written in Python with Django -
  `source <https://github.com/mozilla/zamboni>`_,
  `docs <https://zamboni.readthedocs.org>`_,
  `API docs <https://firefox-marketplace-api.readthedocs.org>`_.

* **Marketplace API Mock**: a fake API backend used for frontend testing.
  Written in Python with Flask -
  `source <https://github.com/mozilla/marketplace-api-mock>`_.

* **Monolith**: storage and query server for statistics around the Marketplace.
  Written in Python -
  `source <https://github.com/mozilla/monolith-client>`_,
  `aggregator source <https://github.com/mozilla/monolith-aggregator/>`_.

* **Webpay** and **Solitude**: servers for processing payments for the Marketplace.
  Written in Python with Django -
  `webpay source <https://github.com/mozilla/webpay/>`_,
  `webpay docs <https://webpay.readthedocs.org>`_,
  `solitude source <https://github.com/mozilla/solitude/>`_,
  `solitude docs <https://solitude.readthedocs.org>`_.

* **Trunion**: a signing service for app receipts and packaged apps.
  Written in Python with Pyramid -
  `source <https://github.com/mozilla/trunion/>`_.

* **Zippy**: a fake backend for payments so to fake out carrier billing.
  Written in Node -
  `source <https://github.com/mozilla/zippy>`_.

* **APK Factory**: generates Android APKs out of web apps.
  Written in Node and Python -
  `factory source <https://github.com/mozilla/apk-factory-service/>`_,
  `signer source <https://github.com/mozilla/apk-signer>`_,
  `signer docs <http://apk-signer.readthedocs.org/>`_.

* **marketplace-env**: automated Marketplace backend setup using Docker.
  Uses Docker and fig -
  `source <https://github.com/mozilla/marketplace-env>`_

* **Signing server**: signs receipts and apps for the Marketplace. Written in
  Python - `signing service <https://github.com/rtilder/signing-service>`_,
  and `signing libraries <https://github.com/rtilder/websigning>`_.

Frontend (Javascript)
~~~~~~~~~~~~~~~~~~~~~

* **Fireplace**: the main frontend for the Firefox Marketplace.
  Written in Javascript with our Commonplace framework -
  `source <https://github.com/mozilla/fireplace>`_.

* **Statistics**: dashboard that displays charts and graphs from Monolith.
  Written in Javascript with our Commonplace framework -
  `source <https://github.com/mozilla/marketplace-stats/>`_.

* **Transonic**: curation and editorial tools for the Marketplace, notably for the Feed.
  Written in Javascript with our Commonplace framework -
  `source <https://github.com/mozilla/transonic/>`_.

* **Operator Dashboard**: dashboard for FirefoxOS operators to manage their app collections.
  Written in Javascript with our Commonplace framework -
  `source <https://github.com/mozilla/commbadge/>`_.

* **Commbadge**: dashboard for communications between app reviewers and app developers.
  Written in Javascript with our Commonplace framework -
  `source <https://github.com/mozilla/commbadge/>`_.

* **Spartacus**: the frontend for Webpay.
  Written in Javascript -
  `source <https://github.com/mozilla/spartacus>`_.

Frontend Components (Javascript)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **marketplace-core-modules**: core JS modules for Marketplace frontend projects
  Written in Javascript -
  `source <https://github.com/mozilla/marketplace-core-modules>`_.

* **commonplace**: Node module that includes configuration, template optimization, l10n.
  Written in Node -
  `source <https://github.com/mozilla/commonplace>`_.

* **marketplace-gulp**: gulpfiles for Marketplace frontend projects for builds.
  Written in Node -
  `source <https://github.com/mozilla/marketplace-gulp>`_.

* **marketplace-constants**: shared constants between the backend and frontend.
  Written in Python -
  `source <https://github.com/mozilla/marketplace-constants>`_.

* **marketplace-elements**: web component UI elements
  Written in Javascript -
  `source <https://github.com/mozilla/marketplace-elements>`_.


Marketplace Servers
-------------------

Marketplace's servers are outlined below For specifics of our production
configuration, please see the `Services documentation
<https://mana.mozilla.org/wiki/display/websites/Services>`_ (only visible to
Mozilla employees).

* `dev <https://marketplace-dev.allizom.org>`_: updated each commit.
* `alt dev <https://marketplace-altdev.allizom.org>`_: updated each commit.
  Used for testing disruptive development features.
* `landfill <https://landfill-mkt.allizom.org/>`_: used to populate a test
  database which can be used with the `install landfill` command in zamboni.
* `stage <https://marketplace.allizom.org>`_: updated when tags are made. This
  is as similar to production as possible. Used for testing features before
  they go to production. Uses real money for payments.
* `payments alt <http://payments-alt.allizom.org/>`_: updated each commit.
  Used for testing dispruptive payments features. Uses real money for payments.
* `production <http://marketplace.firefox.com>`_: updated as per the `push
  schedule <https://wiki.mozilla.org/Marketplace/PushDuty>`_. The production
  servers are the only ones with any uptime expectations.
