.. _package:

=========================
Building the Packaged App
=========================

The Marketplace that ships on Firefox OS is a packaged app which needs to
be built from `fireplace <https://github.com/mozilla/fireplace>`_.  (Side note:
There is a lightweight version of the Marketplace called
`yogafire <https://github.com/mozilla/yogafire>`_ which you may also be wanting
to build.  It follows these same steps, except you'll need to swap out the right
manifest URLs when appropriate).

Create a New Package
--------------------

These directions assume you have a copy of `the Marketplace frontend
<https://github.com/mozilla/fireplace>`_ checked out.

If you want to make a production package (i.e., using the production API),
simply run from the root of your Fireplace checkout::

    make package

Packages will be output to `/package/archives/`. You can also make packages
for other servers. These are pre-configured within `config.js`::

    SERVER=altdev make package
    SERVER=dev make package
    SERVER=paymentsalt make package
    SERVER=stage make package

If you are running a local backend server (e.g., ``http://mp.dev``), you can
configure and build a custom package if you wanted. Open `config.js` and add
an entry to `packageConfig`. It might look like::

    'local': {
        domain: 'http://mp.dev',
        media_url: 'http://mp.dev',
        name: 'Local',
        origin: 'app://packaged.local.firefox.com'
    }

To test your package, use :ref:`Firefox's WebIDE <frontend_firefoxos>`.

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

Testing your package on your Device
-----------------------------------

Do you have that tingle in your gut that says you should test our the package on an actual phone before making a PR?
Or maybe you made some changes to the certs and you want to make sure they work?  Well, you're in luck, because
it's super easy (this will erase everything on your phone):

1) make sure you're in the root of your Gaia repository

2) make sure you can see your Flame device with *adb devices*

3) Run *make reset-gaia* to build your gaia and push to the device
