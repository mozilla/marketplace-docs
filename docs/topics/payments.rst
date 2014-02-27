Payments
========

This section is about processing payments on the Marketplace.

Setup
-----

To develop payments locally we would recommend that you install Webpay,
Solitude and Zippy. This will give you a complete end to end flow of how
payments would work but you will be missing:

* actual carrier or credit card charges

* actual carrier interaction, such as user identification

If you want that then you'll need to set up integration with a real payment
provider, such as Bango. That is discussed in the solitude docs.

The following *assumes* that you have a successfully working Webpay, Solitude,
Zippy and Zamboni installed. This document discusses how you need to configure
them all to interact.

If you are unsure on some of these settings:

* most other developers have these settings done and are happy to help

* there settings files are in GitHub with examples and documentation

Webpay and Zamboni
~~~~~~~~~~~~~~~~~~

Alter Webpay settings::

    MARKETPLACE_URL = 'http://localhost:8000'
    MARKETPLACE_OAUTH = {'key': 'user-a': 'secret': 'bar'}
    DOMAIN = 'localhost'
    KEY = 'localhost'
    SECRET = 'some-secret'

* ``MARKETPLACE_URL``: a full URL with protocol to Zamboni.

* ``MARKETPLACE_OAUTH``: a dictionary with two keys, ``key`` and ``secret``
  which point to an API key on zamboni. The user identified by the key must
  have the following permissions on the Marketplace:
  ``Transaction:NotifyFailure`` and ``ProductIcon:Create``.

Webpay needs to be able to process JWT generate by Zamboni. In Webpay settings
add the following, adjusting Zamboni as necessary.

* ``DOMAIN``: must match ``APP_PURCHASE_AUD`` in Zamboni, example:
  ``localhost``.

* ``KEY``: must match ``APP_PURCHASE_KEY`` in Zamboni, example: ``localhost``.

* ``SECRET``: must match ``APP_PURCHASE_SECRET`` in Zamboni.

Alter Zamboni settings::

    APP_PURCHASE_AUD = 'localhost'
    APP_PURCHASE_KEY = 'localhost'
    APP_PURCHASE_SECRET = 'some-secret'
    APP_PURCHASE_TYPE = 'mozilla-local/payments/pay/v1'

* ``APP_PURCHASE_TYPE``: to ``mozilla-local/payments/pay/v1`` this is to match
  up with the Dev Marketplace addon and should not be altered.

Once you've added these in, you can test this works by hitting the URL
http://your.local.webpay/mozpay/services/monitor. The value for ``marketplace``
should be ``ok``. For example:
https://marketplace.allizom.org/mozpay/services/monitor.


Zamboni and Solitude
~~~~~~~~~~~~~~~~~~~~

In Zamboni settings add the following::

    SOLITUDE_HOSTS = ('http://localhost:8001',)

* ``SOLITUDE_HOSTS``: a tuple of solitude hosts, with full URL protocol to
  Solitude.

Webpay and Solitude
~~~~~~~~~~~~~~~~~~~

In Webpay settings add the following::

    SOLITUDE_URL = 'http://localhost:8001'

* ``SOLITUDE_URL``: a full URL with protocol to Solitude. For example::

Once you've added these in, you can test this works by hitting the URL
http://your.local.webpay/mozpay/services/monitor. The value for ``solitude``
should be ``ok``. For example:
https://marketplace.allizom.org/mozpay/services/monitor.

Solitude and Zippy
~~~~~~~~~~~~~~~~~~

To do.

Zamboni
~~~~~~~

You will neeed to tell Zamboni that it should be using Zippy for payments.

In Zamboni settings add the following::

    PAYMENT_PROVIDERS = ['reference']

* ``PAYMENT_PROVIDERS``: tells Zamboni which payment providers are available.
