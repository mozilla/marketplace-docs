.. _backend:

Marketplace Backend
===================

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

* packages: python2.7, python-pip, curl, python-dev


1. Install Docker
-----------------

`Install docker <https://docs.docker.com/installation/>`_. 

On OSX
~~~~~~

You'll need to install Boot2docker which requires
`Virtualbox <https://www.virtualbox.org/wiki/Downloads>`_. You can install this
easily using `homebrew <http://brew.sh/>`_ with the following::

    brew install caskroom/cask/brew-cask
    brew cask install virtualbox
    brew install docker boot2docker

If you're using Boot2docker once you've created the vm it will tell you how to export
variables in your shell in order to be able to communicate with the boot2docker vm.

On Linux
~~~~~~~~

See the `different instructions <https://docs.docker.com/installation/>`_ for your distribution.

The generic install curl-able script is::

    curl -sSL https://get.docker.com/ | sh

Ubuntu specific is::

    curl -sSL https://get.docker.com/ubuntu/ | sudo sh

2. Build dependencies
---------------------

Get the code::

    pip install marketplace-env

Do you already have all the repositories checked out?

*Yes*::

    mkt root [path to the directory containing your repositories]

*No*::

    mkdir [path to a directory to create the repositories in]
    mkt root [path entered in the previous command]
    mkt whoami [your github user name]
    mkt checkout

Set two environment variables::

    export FIG_FILE=~/.mkt.fig.yml
    export FIG_PROJECT_NAME=mkt

It is recommended that you change your environment variables in your profile so
that they persist and are consistent.

On OSX
~~~~~~

You'll need to share the project path setup in step 2 with docker. Substitute
[path] in the following commands with the [path] in step 2.

For the code shares to work on OSX you'll need to run boot2docker with the following command::

    boot2docker up --vbox-share="[path]=trees"

To enable this share on the vm run::

    boot2docker ssh "sudo mkdir -p [path]/trees && sudo mount -t vboxsf -o uid=1000,gid=50 trees [path]/trees"

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

3. Build and run boxes
----------------------

Run::

    fig build

.. note:: This can take a long time the first time.

Next, to run all the services run::

    mkt up

To quit following the logs press `Ctrl-C`.


When everything is running open up a browser to http://mp.dev

Issues
------

Come talk to us on irc://irc.mozilla.org/marketplace if you have questions,
issues, or compliments.
