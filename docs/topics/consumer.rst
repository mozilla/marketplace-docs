Consumer Pages
==============

This section is about the consumer Marketplace pages.

Setup
-----

.. note:: You will need to have Zamboni running and installed correctly.

To add the code from all front-end dependencies, go to your *zamboni instance*
and you can simply run::

    commonplace fiddle

Commonplace is a set of CLI tools that will handle cloning and updating front-
end dependencies. This is done automatically if you use the ``make
update_commonplace`` command. More information on how this command works is
available in the `Commonplace wiki
<https://github.com/mozilla/commonplace/wiki/CLI-Tools#fiddle>`_

Each of our front-end projects live in their own repositories. These are
single-page apps that talk to the APIs in Zamboni. Commonplace serves as the
glue which brings theem together and keeps them running in sync.

Caching
-------

To prevent Fireplace from trying to access your cache for API calls locally,
add the following to ``src/media/js/settings_local.js``::

    api_cdn_whitelist: {}

Android
-------

To develop on Android, you'll need to make sure that the Android device can
access your local development instance.

If you're running your development environment on a vm then being able to
accessing it from an android device can be a challenge. To solve this
problem on android there's a couple of options.

* Use a proxy with DNS spoofing like Charles proxy http://www.charlesproxy.com/.
  Using a recent android phone you can configure a proxy under the advanced
  settings of a wi-fi connection. This doesn't require root.
* Root your phone and push a hosts file to it with adb.

TODO: Expand on these docs.


Firefox OS
----------

To develop on Firefox OS there are a few tools you can use:

* Use ezboot https://github.com/kumar303/ezboot#bind (This provides a nice command line interface
  to push a customized hosts entry to your device)
* B2G Desktop client https://developer.mozilla.org/en-US/Firefox_OS/Using_the_B2G_desktop_client

TODO: add some docs on this.
