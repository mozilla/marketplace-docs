.. _frontend:

Marketplace Frontend
====================

This section is about setting up the Marketplace frontend (i.e., the
Consumer Pages). The documentation for the Marketplace frontend is a
work-in-progress.

Setup
-----

Setting up an instance of the Marketplace frontend for development is very
simple. Note, you will need Node and NPM set up on your machine::

    git clone git@github.com:mozilla/fireplace
    make init
    make serve

This will clone the project, install dependencies, copy assets from Bower into
the project, create a require.js configuration with paths set up, and start
a local webserver on port 8675 by default.

Firefox OS
----------

To develop on Firefox OS, we recommend using
`Firefox's WebIDE <https://developer.mozilla.org/docs/Tools/WebIDE>`_. Follow
the instructions on connecting a device.

To generate a package (i.e., a Marketplace app to install on the device)::

    make package

Then install the package onto the device using WebIDE.

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
