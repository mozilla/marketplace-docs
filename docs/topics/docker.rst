.. _docker:

Docker
======

.. note:: Setting up with Docker is currently in beta. Feedback welcome.

Using Docker is the recommended configuration for developers new to the
Marketplace. You can set up the Marketplace without using Docker, but this will
automate a lot of the steps.

Requirements
------------

* Mac OS X or Linux.

* A github account (set in step 3).

1. Install Docker
-----------------

`Install docker <https://docs.docker.com/installation/>`_. If you're on OSX you'll
need to install Boot2docker which requires
`Virtualbox <https://www.virtualbox.org/wiki/Downloads>`_.

2. Build dependencies
---------------------

Get the code::

    git clone https://github.com/mozilla/wharfie
    cd wharfie

    bin/mkt whoami [your github user name]
    bin/mkt checkout

    pip install virtualenvwrapper
    mkvirtualenv wharfie
    workon wharfie
    pip install --upgrade pip
    pip install -r requirements.txt


For OSX you'll need to configure shared folders support in boot2docker::

    boot2docker stop
    mv ~/.boot2docker/boot2docker.iso{,.bck}
    curl -o ~/.boot2docker/boot2docker.iso https://dl.dropboxusercontent.com/u/8877748/boot2docker.iso
    VBoxManage sharedfolder add boot2docker-vm -name trees -hostpath "$(pwd)/wharfie/trees/"
    boot2docker up
    boot2docker ssh "sudo modprobe vboxsf && sudo mkdir -p $(pwd)/trees/ && sudo mount -t vboxsf trees $(pwd)/trees"
    sudo sh -c "echo $(boot2docker ip 2>/dev/null)  mp.dev >> /etc/hosts"

For linux just add a hosts entry for localhost::

    sudo sh -c "echo 127.0.0.1  mp.dev >> /etc/hosts"


3. Build and run boxes
----------------------

Run::

    fig build
    fig up

.. note:: This can take a long time.

When complete open up a browser to http://mp.dev

4. Other Manual Steps
---------------------

* For fireplace you'll need to manually create a fireplace/src/media/js/settings_local.js
  file, this should look like this: https://gist.github.com/muffinresearch/0555302e210adf6dc760

5. FAQ
------

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

If you see something like the following::

  Cannot start container c44d451fcb58853bd9ef6d13ba4edf100817fce75bbfe7f9c814d68a708d82e3: setup
  mount namespace bind mounts stat /Users/whatevar/git/wharfie/trees/spartacus: no such file or directory

Then it's likely fig can't see the source code. If you're on OSX this probably
means the shared folder setup needs to be setup again. Unfortunately if
boot2docker has been stopped or restarted you will need to run the setup command again.

Run::

    boot2docker ssh "sudo modprobe vboxsf && sudo mkdir -p $(pwd)/trees/ && sudo mount -t vboxsf trees $(pwd)/trees"

To fix it.


`fig build` fails on Linux saying it can't connect to the daemon
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You need to add your user to the `docker` group and probably log out/in again to make sure you
are there (run `groups` and make sure it says docker to verify)

See http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo


How do I run migrations (Python projects)?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here's the command (runs in a new instance)::

  fig run [image] schematic migrations/

E.g (for zamboni)::

  fig run zamboni schematic migrations/


How do I run Python unit tests?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This command will run the unittests in a new instance::

  fig run [image] python ./manage.py test --noinput -s --logging-clear-handlers

E.g. (for zamboni)::

  fig run zamboni python ./manage.py test --noinput -s --logging-clear-handlers

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

6. Issues
---------

Come talk to us on irc://irc.mozilla.org/marketplace if you have questions,
issues, or compliments.
