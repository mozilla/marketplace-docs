Consumer
========

This section is about the consumer Marketplace pages.

Setup
-----

You will need to have Zamboni running and Fireplace installed.

Caching
-------

To prevent Fireplace from trying to access your cache for API calls locally,
add the following to ``hearth/media/js/settings_local.js``::

    api_cdn_whitelist: {}

Android
-------

To develop on Android, you'll need to make sure that the Android device can
access your local development instance.

TOOD: add some docs on this.
