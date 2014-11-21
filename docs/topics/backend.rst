.. _backend:

Marketplace Backend
===================

.. note:: Setting up with Docker is currently in beta. Feedback welcome.

.. note:: Upgrading to boot2docker/docker 1.3+ is required for built-in
          shared folder support on OSX.

Using Docker is the recommended configuration for developers to set up the
Marketplace backend and payments. Docker automates a lot of the steps on
setting up the backend.

It will also set up the Marketplace frontend for you to poke around, but Docker
is currently not recommended to use (besides as a backend) for frontend
development. If you are more interested in developing the frontend, visit our
:ref:`frontend` docs.

For further information about the Marketplace backend, check out our
`API documentation <https://firefox-marketplace-api.readthedocs.org/>`_ and
`Zamboni documenation <https://zamboni.readthedocs.org/>`_.

Requirements
------------

* Mac OS X or Linux.

* A github account (set in step 3).


1. Install Docker
-----------------

`Install docker <https://docs.docker.com/installation/>`_. If you're on OSX you'll
need to install Boot2docker which requires
`Virtualbox <https://www.virtualbox.org/wiki/Downloads>`_. You can install this
easily using `homebrew <http://brew.sh/>`_ with the following::

    brew install caskroom/cask/brew-cask
    brew cask install virtualbox
    brew install docker boot2docker

If you're using Boot2docker once you've created the vm it will tell you how to export
variables in your shell in order to be able to communicate with the boot2docker vm.


2. Build dependencies
---------------------

Get the code::

    pip install marketplace-env

Do you already have all the repositories checked out?

*Yes*::

    mkt root [path to the directory containing your repositories]
    export FIG_FILE=~/.fig.mkt.yml

*No*::

    mkdir [path to a directory to create the repositories in]
    mkt root [path to a directory to create the repositories in]
    mkt whoami [your github user name]
    mkt checkout
    bin/mkt whoami [your github user name]
    bin/mkt checkout

On OSX
~~~~~~

For the code shares to work on OSX you'll need to run boot2docker with the following command::

    boot2docker up --vbox-share="$(pwd)/trees=trees"

To enable this share on the vm run::

    boot2docker ssh "sudo mkdir -p $(pwd)/trees && sudo mount -t vboxsf -o uid=1000,gid=50 trees $(pwd)/trees"

You can verify this by running::

    boot2docker ssh
    # Next navigate to /User/[username]/path/to/wharfie/trees/ and check the dirs for shared sourcecode.
    # Then quit this ssh shell with `ctrl+c`

Alternatively you can run `boot2docker up` without any args and it will share `/Users` in it's entirety.

Next add a hosts entry for mp.dev (the default host).

::

    sudo sh -c "echo $(boot2docker ip 2>/dev/null)  mp.dev >> /etc/hosts"

On Linux
~~~~~~~~

Add a hosts entry for localhost::

    sudo sh -c "echo 127.0.0.1  mp.dev >> /etc/hosts"

On A Firefox OS Device
~~~~~~~~~~~~~~~~~~~~~~

See the :ref:`device binding <marketplace-backend-on-device>` section
for details on how to edit the device hosts file.


3. Build and run boxes
----------------------

Run::

    fig build

.. note:: This can take a long time the first time.

Next, to run all the services run::

    fig up -d

Alternatively if you would like all the service logs in the foreground run::

    fig up # Ctrl-c here will shutdown all services.

Generally running things in the background is preferred. When running services
in the background if you want to see the logs for a given service run::

    fig logs [service name]

To quit following the logs press `Ctrl-C`.


When everything is running open up a browser to http://mp.dev


Upgrading Docker
----------------

For OSX see http://docs.docker.com/installation/mac/#upgrading
For Windows see: http://docs.docker.com/installation/windows#upgrading


FAQ
---

Seeing a "Couldn't connect to Docker daemon..." error
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you see something like::

  $ fig run zamboni ./manage.py dbshell
  Couldn't connect to Docker daemon at http+unix://var/run/docker.sock - is
  it running?

  If it's at a non-standard location, specify the URL with the DOCKER_HOST
  environment variable.

It's likely you've not set the DOCKER_HOST env variable on OSX. If you run
`boot2docker up` it will tell you what value it should be set to. Add this
to your `.bashrc` or equivalent so it's set for all shells.

Getting a "Couldn't start container" error
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you see something like the following on boot2docker/docker::

  Cannot start container c44d451fcb58853bd9ef6d13ba4edf100817fce75bbfe7f9c814d68a708d82e3: setup
  mount namespace bind mounts stat /Users/whatevar/git/marketplace-env/trees/spartacus: no such file or directory

or something like this::

  nginx_1 | nginx: [emerg] host not found in upstream "webpay_1:2601" in /etc/nginx/conf.d/marketplace.conf:2

Then it's likely fig can't see the source code. Check you have sourcecode under the `trees` directory

If you're on OSX this probably means the shared folders are not working for some reason.

For previous installs prior to boot2docker 1.3 if boot2docker was stopped or restarted you
will need to run the setup command again::

    boot2docker ssh "sudo modprobe vboxsf && sudo mkdir -p $(pwd)/trees/ && sudo mount -t vboxsf trees $(pwd)/trees"

For a longer term fix - upgrade to boot2docker/docker 1.3+


`fig build` fails on Linux saying it can't connect to the daemon
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You need to add your user to the `docker` group and probably log out/in again to make sure you
are there (run `groups` and make sure it says docker to verify)

See http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo


How do I run migrations (Python projects)?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here's the command (runs in a new instance)::

  fig run --rm [image] schematic migrations/

E.g (for zamboni)::

  fig run --rm zamboni schematic migrations/


How do I run Python unit tests?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This command will run the unittests in a new instance::

  fig run --rm [image] python ./manage.py test --noinput -s --logging-clear-handlers

E.g. (for zamboni)::

  fig run --rm zamboni python ./manage.py test --noinput -s --logging-clear-handlers

How do I update python/node package deps (rebuild the container)?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This command is an example for zamboni. If deps have changed they will be installed::

  fig build [project]

E.g (for zippy)::

  fig build zippy

For all projects::

  fig build

Time is drifting in the boot2docker vm.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If this should happen you can fix it with::

  boot2docker ssh sudo ntpclient -s -h pool.ntp.org

How do I add an admin in Zamboni with docker?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Simply run this command replacing name@email.com with the email of the user
you've recently logged-in as::

    fig run --rm zamboni python manage.py addusertogroup name@email.com 1

How do I upgrade boot2docker?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If boot2docker is running, stop it first with::

  boot2docker stop

To update the docker client install the latest package from
`here for OSX <https://github.com/boot2docker/osx-installer/releases/latest>`_ or `here for
windows <https://github.com/boot2docker/windows-installer/releases/latest>`_

You can then upgrade the vm with::

  boot2docker download
  boot2docker start

Optional Configuration
----------------------

Environment Variables
~~~~~~~~~~~~~~~~~~~~~

To configure the services in the Marketplace, you can either override each
project's settings file (see documentation on each project for how that would
look). Or you can alter a few environment variables that all the projects use.
This is the **recommended approach** for setting up the Marketplace until you
feel more comfortable with the settings in the Marketplace.

This documentation assumes that you know how to set environment variables on
your development platform.

+----------------------+--------------------+----------------------------+--------------------------------------+
+ Environment variable | Used by            | Description                | Default                              |
+======================+====================+============================+======================================+
| MARKETPLACE_URL      | Webpay             | URL to nginx               | http://localhost/                    |
+----------------------+--------------------+----------------------------+--------------------------------------+
| MEMCACHE_URL         | Zamboni, Webpay,   | The location of memcache   | localhost:11211                      |
|                      | Solitude           |                            |                                      |
+----------------------+--------------------+----------------------------+--------------------------------------+
| SOLITUDE_DATABASE    | Solitude           | dj_database_url compliant  | mysql://root@localhost:3306/solitude |
|                      |                    | URL to solitude Mysql      |                                      |
+----------------------+--------------------+----------------------------+--------------------------------------+
| SOLITUDE_URL         | Zamboni, Webpay    | URL to solitude instance   | http://localhost:2602                |
+----------------------+--------------------+----------------------------+--------------------------------------+
| SPARTACUS_STATIC     | Webpay             | URL to Spartacus static    | http://localhost:2604                |
|                      |                    | files                      |                                      |
+----------------------+--------------------+----------------------------+--------------------------------------+
| ZAMBONI_DATABASE     | Zamboni            | dj_database_url compliant  | mysql://root@localhost:3306/zamboni  |
|                      |                    | URL to zamboni Mysql       |                                      |
+----------------------+--------------------+----------------------------+--------------------------------------+
| RABBIT_HOST          | Rabbit             | Rabbit hostname            | localhost                            |
+----------------------+--------------------+----------------------------+--------------------------------------+

Other Environment Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please be aware that other parts of the site infrastructure can be affected by
environment variables. Some examples:

* If you want to use custom Django settings, you can set
  `DJANGO_SETTINGS_MODULE <https://docs.djangoproject.com/en/dev/topics/settings/#designating-the-settings>`_


Issues
------

Come talk to us on irc://irc.mozilla.org/marketplace if you have questions,
issues, or compliments.
