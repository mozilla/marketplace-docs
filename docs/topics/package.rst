.. _package:

=========================
Building the Packaged App
=========================

The Marketplace that ships on Firefox OS is a packaged app which needs to
be built from `fireplace <https://github.com/mozilla/fireplace>`_.  (Side note:
There is a lightweight version of the Marketplace called
`yogafire <https://github.com/mozilla.yogafire>`_ which you may also be wanting
to build.  It follows these same steps, except you'll need to swap out the right
manifest URLs when appropriate).

Create a New Package
--------------------

These directions assume you have a copy of `fireplace <https://github.com/mozilla/fireplace>`_
checked out.

Assuming you want to make a production package, simply run from the root of your
fireplace checkout::

    make package

For stage or dev servers you could also run either of these::

    make package_dev
    make package_stage

This will create a package in /package/archives/

Put the New Package on the Marketplace
--------------------------------------

These directions assume you have the site permissions (meaning: you own the app
in the Marketplace) to do this and you want to put it on production.  Adjust the
URL below if you want to put it on dev or stage.

1) `Edit the app on the Marketplace <https://marketplace.firefox.com/developers/app/marketplace-package/status#upload-new-version>`_
2) Upload the newly made package
3) Make sure that *Multiple Network Information* and *Network Information* are
   checked
4) Save your changes.  The file will be in the approval queue.

Approve the New Package on the Marketplace
------------------------------------------

These directions assume you have the reviewer permissions to do this.

1) `Load the app in the Reviewer Tools <https://marketplace.firefox.com/reviewers/apps/review/marketplace-package#review-actions>`_
2) Click *Push to Public*
3) Enter a short message in *comments* and click **OK**

Preload a New Package in Firefox OS
-----------------------------------

These directions assume you have forked `gaia <https://github.com/mozilla-b2g/gaia/>`_.

1) Check out a new branch
2) Navigate to the Marketplace files::

    cd apps/marketplace.firefox.com

3) Run in a separate window and make note of the output of these commands.  Note
   that if you are building yogafire and not fireplace you'll want to use
   *marketplace-package.webapp* from the same URL below. ::

    curl 'https://marketplace.firefox.com/packaged.webapp'

    curl -I 'https://marketplace.firefox.com/packaged.webapp' | grep ETag

4) The first command above will be a blob of JSON including a *package_path*.
   Copy that package path (eg. *https://marketplace.firefox.com/downloads/file/251994/marketplace-20140331214114.zip*).
   The second command will have an ETag header (eg.  *a10ca98addc3785e92ead363281c425bd7114b84a4162f50096593b76a7ac2c3*)
   - copy that for later.

5) Replace the current marketplace with the new package using the *package_path*
   you copied above.  Example::

    curl 'https://marketplace.firefox.com/downloads/file/251994/marketplace-20140331214114.zip' > application.zip

6) Get the package's new ETag::

    curl -I 'https://marketplace.firefox.com/downloads/file/251994/marketplace-20140331214114.zip' | grep ETag

7) Modify **metadata.json** and replace the *etag* and *packageEtag* fields with
   the two ETags from above.  Note that the extra escaped quotes are **not** a
   typo.  Your diff will look something like::

   + "etag": "\"a10ca98addc3785e92ead363281c425bd7114b84a4162f50096593b76a7ac2c3\"",
   + "packageEtag": "\"bf5f4736daffaf7982c872efc4beb38f440d5d84a6fb3f82c5d434cca6abd4d5\"",

8) Commit your changes and make a pull request. `An example <https://github.com/mozilla-b2g/gaia/pull/18845>`_.

9) For now, the best way to get traction on your pull request is to `file a bug <https://bugzilla.mozilla.org/enter_bug.cgi?product=Firefox%20OS&component=Gaia>`_.
   Fill in a summary and description and then click *Add Attachment* -> *Paste
   text as attachment* and paste in your pull request URL (eg.
   *https://github.com/mozilla-b2g/gaia/pull/18845*).  Under flags request
   *review?* from *:julienw* or *:fabrice*

10) Done!
