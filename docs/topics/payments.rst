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

There is one setting that is not configured correctly out of the box at this
time. You must get OAuth keys for a user in the Marketplace and then create
a local settings file that overrides the following:

* ``MARKETPLACE_OAUTH``: a dictionary with two keys, ``key`` and ``secret``
  which point to an API key on zamboni. The user identified by the key must
  have the following permissions on the Marketplace:
  ``Transaction:NotifyFailure`` and ``ProductIcon:Create``.

For example::

    from base import *

    MARKETPLACE_OATH = {'key': 'a', 'secret': 'b'}

Once you've added these in, you can test this works by hitting the URL
http://your.local.webpay/mozpay/services/monitor. The value for ``marketplace``
should be ``ok``. For example:
https://marketplace.allizom.org/mozpay/services/monitor.

Configuring devices
-------------------

Out of the box, Firefox OS only ships with settings that let you make payments
against the production server. If you want to pay with a hosted *dev* or *stage*
server then you'll need to put some custom settings on your B2G device.
See the :ref:`developer docs <developers>` if you want to host your own WebPay.

Using the Firefox OS Simulator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is **the recommended approach** for developers.

As of `Firefox OS Simulator`_ 1.3 you can use a cusom Gaia profile
which is necessary to work with a local Webpay server. Skip down to
"Build A Custom B2G Profile".

Set up the `Firefox OS Simulator`_ according to the documentation.
This involves installing a version specific addon, such as a
1.4 Simulator. After installation, open ``about:addons`` in Firefox
and enter the Preferences section for the Simulator add-on.
Click the button to use a custom Gaia profile
and select the directory of the one you just built.

Open the `App Manager`_, connect to your Simulator and you are ready to test
payments against your local Webpay server.

.. _`Firefox OS Simulator`: https://developer.mozilla.org/en-US/docs/Mozilla/Firefox_OS/Using_Firefox_OS_Simulator
.. _`App Manager`: https://developer.mozilla.org/en-US/Firefox_OS/Using_the_App_Manager


Set Up A Device With ezboot
~~~~~~~~~~~~~~~~~~~~~~~~~~~

All you need to do to start testing web payments on a device is flash a recent
build, install certs for permissions, push custom settings, and install the
Marketplace dev/stage apps.

With `ezboot`_ you can do all of this with some commands.
First, install `ezboot`_ so that the command line script is available on your path.

Now, grab the :ref:`webpay <developers>` source to get the settings you need::

    git clone git://github.com/mozilla/webpay.git

Change into the source directory and set up ezboot::

    cd webpay
    cp ezboot.ini-dist ezboot.ini

If you want to make things easier, you can edit
``ezboot.ini`` and uncomment the wifi and flash settings
(i.e. delete the hash prefix). You can add your WiFi details to automatically
connect to your local network and add a flash username/password
(your LDAP credentials) for faster downloads.

Plug in your device. If this is your *first* time flashing
an engineering build (with `Marionette`_), make sure
Remote Debugging is enabled in
Settings > Device Information > More Information > Developer.

Make sure you're still in the webpay directory and
flash the latest build::

    ezboot flash

Set up WiFi::

    ezboot setup

Ask someone for a cert file
(see `this issue <https://github.com/briansmith/marketplace-certs/issues/1>`_),
download the file, and unzip it.
Push the dev certs to your device::

    ezboot mkt_certs --dev --certs_path ~/Downloads/certdb.tmp/

Install the packaged Marketplace app::

    ezboot install_mkt --dev

At this time, you need to use the hosted version of Marketplace Stage (not
packaged). Install it using the manifest, like this::

    ezboot install --manifest https://marketplace.allizom.org/manifest.webapp

Launch either Marketplace Dev or Marketplace Stage, search for a
paid app such as Private Yacht, and click purchase.

That's it! You can stop reading this document because everything
else is intended for using custom builds and/or custom settings.

.. _`ezboot`: https://github.com/kumar303/ezboot
.. _`Marionette`: https://developer.mozilla.org/en-US/docs/Marionette

Build A Custom B2G Profile
~~~~~~~~~~~~~~~~~~~~~~~~~~

You have to build a
custom profile from the Gaia source to allow ``navigator.mozPay()``
to talk to your local WebPay server.
Refer to the `Gaia Hacking`_
page for more details but this page has everything you need to know.

**IMPORTANT**: You have to use a branch of Gaia that matches the
version of B2G you're using. For example, check out ``origin/v1.2``
for 1.2, ``origin/v1.4`` for 1.4, etc.

Here's an example of building a 1.4 profile.
Install `git`_ and type these commands::

    git clone git://github.com/mozilla-b2g/gaia.git
    cd gaia
    git checkout --track -b origin/v1.4 origin/v1.4

Get updates like this::

    git checkout origin/v1.4
    git pull

Create ``build/config/custom-prefs.js`` in that directory.
With a text editor, add **all** of the settings below.

**IMPORTANT**: Before 1.4, you had to put the file in
``build/custom-prefs.js``.

Add some basic debug settings::

    pref("dom.payment.skipHTTPSCheck", true);
    pref("dom.identity.enabled", true);
    pref("toolkit.identity.debug", true);

Add this to activate the hosted dev server::

    pref("dom.payment.provider.1.name", "firefoxmarketdev");
    pref("dom.payment.provider.1.description", "marketplace-dev.allizom.org");
    pref("dom.payment.provider.1.uri", "https://marketplace-dev.allizom.org/mozpay/?req=");
    pref("dom.payment.provider.1.type", "mozilla-dev/payments/pay/v1");
    pref("dom.payment.provider.1.requestMethod", "GET");

Add this to activate the hosted stage server::

    pref("dom.payment.provider.2.name", "firefoxmarketstage");
    pref("dom.payment.provider.2.description", "marketplace.allizom.org");
    pref("dom.payment.provider.2.uri", "https://marketplace.allizom.org/mozpay/?req=");
    pref("dom.payment.provider.2.type", "mozilla-stage/payments/pay/v1");
    pref("dom.payment.provider.2.requestMethod", "GET");

Add this to activate a local server::

    pref("dom.payment.provider.3.name", "firefoxmarketlocal");
    pref("dom.payment.provider.3.description", "localhost");
    pref("dom.payment.provider.3.uri", "http://localhost:8000/mozpay/?req=");
    pref("dom.payment.provider.3.type", "mozilla-local/payments/pay/v1");
    pref("dom.payment.provider.3.requestMethod", "GET");

Add this to activate the payments-alt server::

    pref("dom.payment.provider.4.name", "firefoxmarketalt");
    pref("dom.payment.provider.4.description", "payments-alt.allizom.org");
    pref("dom.payment.provider.4.uri", "https://payments-alt.allizom.org/mozpay/?req=");
    pref("dom.payment.provider.4.type", "mozilla-alt/payments/pay/v1");
    pref("dom.payment.provider.4.requestMethod", "GET");

Save the file.
Now when you make a profile it will create a ``profile/user.js``
file with those extra prefs. Type this in the ``gaia`` directory::

    make clean profile

You now have a custom B2G profile in your ``gaia/profile`` directory.

These settings are available in the webpay repository:
https://github.com/mozilla/webpay/blob/master/ezboot/custom-prefs.js

Setting Up A B2G Device
~~~~~~~~~~~~~~~~~~~~~~~

After you create a custom B2G profile as described above
you'll need to flash B2G on your phone and push some profile settings to it.

First make sure you have the `Android Developer Tools`_ installed.
The ``adb`` executable should be available in your path.

If you have an Unagi device, you can log in
with your Mozilla LDAP credentials and obtain a build from
https://pvtbuilds.mozilla.org/pub/mozilla.org/b2g/nightly/mozilla-b2g18-unagi/latest/
At this time, the builds are not available to the public.
You could always build your own though.

When you unzip the b2g-distro directory plug your phone in via USB and run this::

    ./flash.sh

That installs B2G and Gaia. Before you can add your custom settings you
have to enable remote debugging over USB. Go to Settings > Device Information >
More Information > Developer and turn on Remote debugging.

Now fetch the gaia code just like in the B2G profile instructions above
(make sure you are on the **v1-train** branch),
add the ``custom-prefs.js`` file, and make a custom profile.
Here's how to put the custom payment settings on to your phone.

Type these commands::

    cd gaia
    adb shell "stop b2g"
    adb push profile/user.js /data/local/
    adb reboot

When B2G reboots you should be ready to make payments against
the configured dev servers Read on to install a Marketplace dev app.

Installing Marketplace Dev
~~~~~~~~~~~~~~~~~~~~~~~~~~

Visit http://app-loader.appspot.com/c5ec6 on your B2G browser to install
the Marketplace Dev app.
This installs the manifest at
https://marketplace-dev.allizom.org/manifest.webapp .

Launch the Marketplace Dev app.
If you see pictures of cvan everywhere then you know you've opened the right one.
You can set a search filter to show only paid apps.
As an example, search for Private Yacht which is fully set up for payments
and even checks receipts.

Installing Marketplace Stage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Visit http://app-loader.appspot.com/a2c98 on your B2G browser to install
the Marketplace Dev app.
This installs the manifest at
https://marketplace.allizom.org/manifest.webapp .

Launch the Marketplace Stage app.
Search for a paid app such as Private Yacht and make a purchase.

**WARNING**: the stage app is currently hooked up to the live Bango payment
system.

