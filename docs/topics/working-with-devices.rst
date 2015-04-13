Working With Devices
====================

Flashing the Latest Build
-------------------------

Have ADB installed. You can learn
`how to install adb <https://developer.mozilla.org/Firefox_OS/Debugging/Installing_ADB>`_
on MDN.

Connect your phone to your machine with a USB cable. If you run ``adb devices``
you should see a device ID.

Flashing the Flame
~~~~~~~~~~~~~~~~~~

There are `base builds <https://developer.mozilla.org/Firefox_OS/Platform/Architecture>`_
(codename gonk), which contains the kernel, and there are FirefoxOS builds which are run on
top of the base build.

Flames with a base build on an old Android kernel (v123) are no longer
supported by us. Make sure to `run with the newest build <https://developer.mozilla.org/en-US/Firefox_OS/Phone_guide/Flame/Updating_your_Flame>`_.

.. note::

    You will lose everything on the device when you do this.
    Once you are running v188, you don't need to do this step
    again until we update to a new kernel (probably a year or two)

Then to run with the correct FirefoxOS build for the flame (requires LDAP):

.. sourcecode:: shell

    git clone https://github.com/Mozilla-TWQA/B2G-flash-tool
    cd B2G-flash-tool
    ./flash_pvt.py --help
    # Shallow flash an engineering build off the master branch onto the
    # Flame v188 device.  In theory you won't lose anything...
    ./flash_pvt.py -d flame-kk -v mozilla-central --eng -g -G --keep_profile

Flashing without LDAP Access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Find the build you want from http://ftp.mozilla.org/pub/mozilla.org/b2g/nightly/ and install (preferably an eng build)
* unzip the file
* navigate to that folder
* run ``./flash.sh``
* Phone should be installed with the latest gaia build you chose.


Enabling Dev and Stage Certificates
-----------------------------------

FxOS version: 1.1 - 1.4
~~~~~~~~~~~~~~~~~~~~~~~

Follow: https://wiki.mozilla.org/Marketplace/Reviewers/Apps/Guide/Setup/Cert_installation

FxOS version: 2.0
~~~~~~~~~~~~~~~~~

You don't need to install certificates; the system preference
``dom.mozApps.use_reviewer_certs`` just needs to be set to true.

* Connect the device with a USB cable and install any drivers
* Open a shell
* Run ``adb shell`` and then the following to set the preference::

    stop b2g
    cd /data/b2g/mozilla/\*.default/
    echo 'user_pref("dom.mozApps.use_reviewer_certs", true);' >> prefs.js
    start b2g

FZOS version: 2.1+
~~~~~~~~~~~~~~~~~~

Enable the checkbox: `Settings -> Developer -> Use Marketplace reviewer certs`


Installing Dev and Stage on Engineering Builds
----------------------------------------------

.. note::

    Some testers have had trouble with this, and flashing user gaia+gecko
    fails to boot. Proceed with caution.

Engineering builds (as of 16 Oct 2014) have old Dev and Stage Marketplace apps
installed, and they cannot be removed.

To work around this, we need root access on the engineering image in order to
push custom prefs (e.g., for payments), and the UI and apps from the user
build.

To do so, flash a full engineering image (referred to as "images" as opposed to
"gaia+gecko"). Then flash a user build of just "gaia+gecko" of the same build.
Since this the user build, the developer menu is hidden by default. To remedy
this:

- Go to "Device Information -> More information"
- Scroll to bottom and enable developer menu
- Enable USB Debugging in the dev menu
- Check console enabled
- Enable Marketplace reviewer certs
- Reboot


.. _marketplace-backend-on-device:

Accessing Your Local Marketplace From Device
--------------------------------------------

If you want to access your local :ref:`Marketplace Backend <backend>` on a
device, you'll need to proxy the internal virtual server through a public IP
and bind that IP to a host on device.

If you run Apache on port 80 which is the default on many systems, you can add
this to your config to proxy. Adjust the internal IP address of the virtual
server as necessary.::

    Listen 80

    <VirtualHost *:80>
        ServerName mp.dev
        ProxyPreserveHost On
        ProxyRequests off
        ProxyPass / http://192.168.59.103/
        ProxyPassReverse / http://192.168.59.103/
    </VirtualHost>

If you run `nginx <http://nginx.org/>`_ on port 80 then you can use
a config like this. Again, you may need to adjust the proxied IP::

    http {
        server {
            listen       80 default;
            server_name  mp.dev;

            location / {
                # Pass public connections to the internal
                # Docker / VirtualBox server.
                proxy_pass http://192.168.59.103/;
                proxy_set_header Host $host;
            }
        }
    }

When running Docker and serving on your public / network IP (sucha s
10.0.0.1), ensure USB debugging is enabled on your device, plug it in, and
use the bind command::

    bin/mkt bind

This will edit the ``/system/etc/hosts`` file on the device so that you can
access http://mp.dev.

If you have multiple network devices, the command will prompt you for
the one to bind to. Run ``bin/mkt bind --help`` for details.


Prefs File for Payments Testing
-------------------------------

Here's an example prefs file for payments testing:
https://gist.github.com/muffinresearch/9a7c3d3d632a9a9922f0

Push this to your device with::

    adb push path/to/custom-prefs.js /data/local/user.js

Then reboot for the changes to take effect::

    adb reboot


Installing Packaged Marketplaces
--------------------------------

Apps such as Dev or Stage or PaymentsAlt, are unlisted on the production
Marketplace. Though, `Metaplace <https://metaplace.paas.allizom.org>`_ can be
installed which allows you to install the apps from the "jump" menu.

Or you can go directly to the app page from the browser on the device:

* Dev: https://marketplace.firefox.com/app/mkt-dev
* Stage: https://marketplace.firefox.com/app/mkt-stage
* PaymentsAlt: https://marketplace.firefox.com/app/marketplace-payments-alt


Device Not Being Recognized
---------------------------

If your Tarako device is not recognized, add the vendor ID to the ADB USB
configuration::

    echo "0x1782" > ~/.android/adb_usb.ini
    adb kill-server
    adb start-server
