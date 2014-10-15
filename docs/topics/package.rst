.. _package:

=========================
The Packaged App
=========================

There are currently three variations of the packaged app:

* an iframed packaged app, referred to an iframed app
* a packaged app, referred to as a packaged app
* a lightweight packaged build from `yogafire <https://github.com/mozilla.yogafire>`_


Building the iframed app
========================

These directions assume you have a copy of `fireplace <https://github.com/mozilla/fireplace>`_
checked out.

Assuming you want to make a production package, simply run from the root of
your fireplace checkout::

    make log

Other packages exist for other servers.

Building the packaged app
=========================

These directions assume you have a copy of `fireplace <https://github.com/mozilla/fireplace>`_
checked out.

Assuming you want to make a production package, simply run from the root of your
fireplace checkout::

    make package

For stage or dev servers you could also run any of these::

    make package_dev
    make package_altdev
    make package_stage

If you are running a local server at something like
``http://fireplace.loc``, you could build a custom package using
environment variables. The ``SERVER`` variable will be used to load
the right settings file so if you set it to ``local``, first make some
settings::

    cp src/media/js/settings_local.js.dist src/media/js/settings_package_local.js

Edit the settings to make sure the API URL is correct. Now create your package::

    SERVER='local' NAME='MktLocal' DOMAIN='fireplace.loc' make package

The ``NAME`` variable sets the application name and it cannot contain spaces.

All of these commands will create packages in `/package/archives/`. The package names
correspond to the :ref:`Marketplace servers <marketplace-servers-label>`
or the ``SERVER`` variable. You can then test
the package in the Simulator using the `App Manager <https://developer.mozilla.org/en-US/Firefox_OS/Using_the_App_Manager>`_.

Using the packaged or iframed app
=================================

This is actually a rather complicated topic for a few reasons:

* the build of Firefox OS may or may not already have a package installed on
  the device, it might be packaged or iframed
* to install a packaged app on a device, you will need to have the certificates
  that the packaged was signed with on your device

Before you go any further, if you have a version of the app pre-installed
:ref:`it is strongly recommended <packaged-or-iframed-label>` you understand what it
is.

This documentation covers install a packaged or iframed app under the following
scenarios.

Simulator
---------

...

Device
------

...

.. _packaged-or-iframed-label:

Packaged or iframed
-------------------

On the simulator...

On a device...


Pushing packages to the Marketplace
===================================

The following refers to putting an app on to the Marketplace. However these are
instructions most contributors should not need to run.

Put the New Package on the Marketplace
--------------------------------------

These directions assume you have the site permissions (meaning: you own the app
in the Marketplace) to do this and you want to put it on production.  Adjust the
URL below if you want to put it on dev or stage.

1) `Edit the app on the Marketplace <https://marketplace.firefox.com/developers/app/marketplace/status#upload-new-version>`_
2) Upload the newly made package
3) Make sure that *Multiple Network Information* and *Network Information* are
   checked
4) Save your changes.  The file will be in the approval queue.

Approve the New Package on the Marketplace
------------------------------------------

These directions assume you have the reviewer permissions to do this.

1) `Load the app in the Reviewer Tools <https://marketplace.firefox.com/reviewers/apps/review/marketplace#review-actions>`_
2) Click *Push to Public*
3) Enter a short message in *comments* and click **OK**

Preload a New Package in Firefox OS
-----------------------------------

For steps 4 to 8, we have a
`helper script to download the package and generate Etags <https://github.com/mozilla/zamboni/blob/master/scripts/gaia_package.py>`_.

These directions assume you have forked `gaia <https://github.com/mozilla-b2g/gaia/>`_.

1) `File a bug <https://bugzilla.mozilla.org/enter_bug.cgi?product=Firefox%20OS&component=Gaia>`_
   for Gaia saying a new Marketplace is incoming.  They won't land a PR without
   a bug filed.

2) Check out a new branch

3) Navigate to the Marketplace files::

    cd apps/marketplace.firefox.com

4) Run in a separate window and make note of the output of these commands.  Note
   that if you are building yogafire and not fireplace you'll want to use
   *marketplace-package.webapp* from the same URL below. ::

    curl 'https://marketplace.firefox.com/packaged.webapp'

    curl -I 'https://marketplace.firefox.com/packaged.webapp' | grep ETag

5) The first command above will be a blob of JSON including a *package_path*.
   Copy that package path (eg. *https://marketplace.firefox.com/downloads/file/251994/marketplace-20140331214114.zip*).
   The second command will have an ETag header (eg.  *a10ca98addc3785e92ead363281c425bd7114b84a4162f50096593b76a7ac2c3*)
   - copy that for later.

6) Replace the current marketplace with the new package using the *package_path*
   you copied above.  Example::

    curl 'https://marketplace.firefox.com/downloads/file/251994/marketplace-20140331214114.zip' > application.zip

7) Get the package's new ETag::

    curl -I 'https://marketplace.firefox.com/downloads/file/251994/marketplace-20140331214114.zip' | grep ETag

8) Modify **metadata.json** and replace the *etag* and *packageEtag* fields with
   the two ETags from above.  Note that the extra escaped quotes are **not** a
   typo.  Your diff will look something like::

   + "etag": "\"a10ca98addc3785e92ead363281c425bd7114b84a4162f50096593b76a7ac2c3\"",
   + "packageEtag": "\"bf5f4736daffaf7982c872efc4beb38f440d5d84a6fb3f82c5d434cca6abd4d5\"",

9) Commit your changes and make a pull request.  Put the bug number from step 1
   in the title of the bug.  For example: *Bug 100000 - New Marketplace; 20140501*

10) Return to the bug you filed in step 1.  Click *Add Attachment* -> *Paste
    text as attachment* and paste in your pull request URL (eg.
    *https://github.com/mozilla-b2g/gaia/pull/18845*).  Under flags request
    *review?* from *:julienw* or *:fabrice*

11) Done!
