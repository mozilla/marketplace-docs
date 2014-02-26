Setup
=====

The Firefox Marketplace is a collection of services and repositories that can
be assembled together to form the Marketplace.

Services
--------

* Zamboni: the main backend for the Marketplace, written in Python using
  Django. Available at: https://github.com/mozilla/zamboni

* Fireplace: the consumer front end for the Marketplace, written as a browser
  app in Javascript using Commonplace and Nunjucks. Available at:
  https://github.com/mozilla/fireplace

* Monolith: storage and query server for statistics around the Marketplace.
  Has a client: https://github.com/mozilla/monolith-client and an aggregator:
  https://github.com/mozilla/monolith-aggregator/, both written in Python.

* Marketplace stats: is the front end for monolith to display the stats on to
  the end users. Written as a browser app in Javascript using Commonplace.
  Available at: https://github.com/mozilla/marketplace-stats/

* Webpay and Solitude: servers for processing payments for the Marketplace.
  Written in Python and Django: https://github.com/mozilla/solitude/ and
  https://github.com/mozilla/webpay/

* Zippy: a fake backend for payments so to fake out carrier billing. Written
  in Javascript and Node JS: https://github.com/mozilla/zippy

* Rocketfuel: curation tools for the Marketplace. Written in Javascript and
  Commonplace: https://github.com/mozilla/rocketfuel/

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

Serving
-------

Most developers are using nginx to serve out the multiple services. Your
configuration will look something like this:

.. image:: ../img/configuration.png

NGINX
+++++

Installation (on OS X)::

  brew install nginx

Configuration

*TODO*
