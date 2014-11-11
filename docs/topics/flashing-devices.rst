Flashing Devices
================

I want to flash the latest build on my device
---------------------------------------------

First make sure you have adb installed as this is needed for most of the
following steps. If you need adb here's a guide on `how to install adb (MDN)
<https://developer.mozilla.org/en-US/Firefox_OS/Debugging/Installing_ADB>`_

Plug your phone into your USB cable.  If you run ``adb devices`` you should see a
device ID.

My Tarako isn't recognized
~~~~~~~~~~~~~~~~~~~~~~~~~~

If your Tarako device is not recognized, do the following::

    echo "0x1782" > ~/.android/adb_usb.ini
    adb kill-server
    adb start-server


Run the right base image for the Flame
--------------------------------------

There are base `builds <https://developer.mozilla.org/en-US/Firefox_OS/Platform/Architecture>`_
(this is "gonk"), which is your kernel and such, and there are FirefoxOS builds
which we run on top of that base build.  Flames shipped with a base build on an
old Android kernel (v123) which we don't support anymore.  Let's make sure
we're running the new v188 build.
`Here are easy directions <https://developer.mozilla.org/en-US/Firefox_OS/Developer_phone_guide/Flame#Updating_your_Flame%27s_software>`_.

.. note::

    You will lose everything on the device when you do this.
    Once you are running v188 you don't need to do this step
    again until we update to a new kernel (probably a year or two)

Run the right FirefoxOS build (requires LDAP)
---------------------------------------------

.. sourcecode:: shell

    git clone https://github.com/Mozilla-TWQA/B2G-flash-tool
    cd B2G-flash-tool
    ./flash_pvt.py --help
    # Shallow flash an engineering build off the master branch onto the
    # Flame v188 device.  In theory you won't lose anything...
    ./flash_pvt.py -d flame-kk -v mozilla-central --eng -g -G --keep_profile

Installing older builds if you don't have LDAP access
-----------------------------------------------------

* Find the build you want from http://ftp.mozilla.org/pub/mozilla.org/b2g/nightly/ and install (preferably an eng build)
* unzip the file
* navigate to that folder
* run ``./flash.sh``
* Phone should be installed with the latest gaia build you chose.

Enable dev/stage certificates
-----------------------------

FxOS version: 1.1 - 1.4
~~~~~~~~~~~~~~~~~~~~~~~

Then follow this guide: https://wiki.mozilla.org/Marketplace/Reviewers/Apps/Guide/Setup/Cert_installation

FxOS version: 2.0
~~~~~~~~~~~~~~~~~

You don't need to install certificates; the system ``preference dom.mozApps.use_reviewer_certs`` just needs to be set to true.

* Connect the device with a USB cable and install any drivers needed.
* Open a command/terminal window
* type ``adb shell`` and then the following commands to set the preference::

    stop b2g
    cd /data/b2g/mozilla/\*.default/
    echo 'user_pref("dom.mozApps.use_reviewer_certs", true);' >> prefs.js
    start b2g


FZOS version: 2.1+
~~~~~~~~~~~~~~~~~~

Enable the checkbox: `Settings -> Developer -> Use Marketplace reviewer certs`

Working around not being able to install -dev or stage on eng builds
--------------------------------------------------------------------

.. note::

    Some testers have had trouble with this, and the flashes user gaia+gecko fails to boot. Proceed with caution.

Eng builds (As of 16th Oct 2014) have old -dev and stage marketplace
apps installed and you can't remove them.

To work around this we need the root abilities of the eng image (otherwise
we can't push custom prefs e.g. for payments) + the UI and apps from the user
build.

First flash a full eng image first (Referred to as "images" as opposed to
"gaia+gecko"). Once that's complete, flash a user build of just
"gaia+gecko" of the same build.

As this is the user build the developers menu is not visible by default.
To remedy this (once it boots) go to "Device Information -> More information".
Scroll to bottom and enable developer menu. Then enable USB Debugging in the
dev menu + check console enabled + enable Marketplace reviewer certs. Then reboot.

Prefs file for payments testing
-------------------------------

Here's an example prefs file for payments testing:
https://gist.github.com/muffinresearch/9a7c3d3d632a9a9922f0

Push this to your device with::

    adb push path/to/custom-prefs.js /data/local/user.js

Then reboot for the changes to take effect::

    adb reboot

Installing -dev + stage + payments-alt
--------------------------------------

These apps are on the production marketplace but are hidden.
Metaplace can be installed which should allow you to install the apps from
the "jump" menu. (see https://metaplace.paas.allizom.org).

If you have trouble with this then you can directly go to the
apps in the prod marketplace from the browser on device.

* dev: https://marketplace.firefox.com/app/mkt-dev
* stage: https://marketplace.firefox.com/app/mkt-stage
* payments-alt: https://marketplace.firefox.com/app/marketplace-payments-alt
