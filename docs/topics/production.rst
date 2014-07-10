Marketplace servers
===================

This document outlines what services the Marketplace has, since these are
crucial in testing and development. For specifics of our production
configuration, please see documentation
`available only to Mozilla employees <https://mana.mozilla.org/wiki/display/websites/Services>`_.

.. _marketplace-servers-label:

Current servers:

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

