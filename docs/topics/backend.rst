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

`Install Docker <https://docs.docker.com/installation/>`_.

On OSX
~~~~~~

On Mac the docker libs can be installed using Mac Homebrew::

    brew install caskroom/cask/brew-cask
    brew cask install virtualbox
    brew install docker
    brew install docker-machine
    brew install docker-compose

On Linux
~~~~~~~~

The generic (check docker link above for distribution specific) install script for docker is::

    curl -sSL https://get.docker.com/ | sh
    
Ubuntu users probably want to add ubuntu to the docker group (you need to log in and out again after)::

    sudo usermod -aG docker ubuntu
    
To install docker-compose::
 
    sudo pip install docker-compose

2. Build dependencies
---------------------

OSX
~~~
Let's start by creating the virtual machine that our containers will be created in::

    docker-machine create --driver virtualbox --virtualbox-memory 2048 mkt

This creates a virtual machine using virtualbox with 2GB of RAM available named
'mkt'.

Next, execute the following command to export the environment variables::

    eval "$(docker-machine env mkt)"

OSX and Linux
~~~~~~~~~~~~~

Next we will checkout the code repositories needed for development. Check out
the following repositories somewhere on your machine under the same root
directory (e.g.: ~/sandbox/):

  * `fireplace <https://github.com/mozilla/fireplace/>`_
  * `solitude <https://github.com/mozilla/solitude/>`_
  * `spartacus <https://github.com/mozilla/spartacus/>`_
  * `webpay <https://github.com/mozilla/webpay/>`_
  * `zamboni <https://github.com/mozilla/zamboni/>`_
  * `zippy <https://github.com/mozilla/zippy/>`_

Get the marketplace environment repo and set up the configuration files needed
for docker-compose. Still in the sandbox directory::

    git clone https://github.com/mozilla/marketplace-env.git
    cd marketplace-env
    python link-sources.py --root $(dirname $(pwd))

Set up the environment variable that `docker-compose` looks for::

    export COMPOSE_FILE=`pwd`/docker-compose.yml
    export COMPOSE_PROJECT_NAME=mkt  # String prepended to every container.

It is recommended that you add these environment variables (the ones above, and for Mac OS those provided by ``docker-machine env mkt`` also) in your profile so that
they persist and are consistent.

Next add a hosts entry for mp.dev.

On OSX::

    sudo sh -c "echo $(docker-machine ip mkt 2>/dev/null)  mp.dev >> /etc/hosts"

On Linux::

    sudo sh -c "echo 127.0.0.1  mp.dev >> /etc/hosts"


3. Build and run
----------------

Now that the marketplace github repos are cloned and linked we can start
creating the virtual machine and docker containers.

Let's pull down the docker images and build the containers::

    docker-compose pull

.. note:: This can take a long time the first time.

Next, start the containers::

    docker-compose up -d

.. note:: On first run this may take a few minutes as it sets up the services,
    creates data, and populates the search index.

When everything is running open up a browser to http://mp.dev

4. Shutting down and restarting
-------------------------------

On the Marketplace team we have found it good practice to shut down docker at
the end of each work day.

OSX
~~~

To do so you can run the following commands::

    docker-compose stop
    docker-machine stop mkt

To start up again simply do::

    docker-machine start mkt
    docker-compose up -d

Linux
~~~~~

To do so you can run the following commands::

    docker-compose stop

To start up again simply do::

    docker-compose up -d

Issues
------

Come talk to us on irc://irc.mozilla.org/marketplace if you have questions,
issues, or compliments.
