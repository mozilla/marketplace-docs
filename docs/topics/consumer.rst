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

TODO: add some docs on this.

Firefox OS
----------

To develop on Firefox OS there are a few tools you can use:

* ezboot https://github.com/kumar303/ezboot#bind
* B2G Desktop client https://developer.mozilla.org/en-US/Firefox_OS/Using_the_B2G_desktop_client

TODO: add some docs on this.
