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
    boot2docker ssh 'sudo modprobe vboxsf && sudo mkdir -p "$(pwd)/wharfie/trees/" && sudo mount -t vboxsf trees "$(pwd)/wharfie/trees"'
    sudo sh -c "echo '$(boot2docker ip 2>/dev/null)  mp.dev' >> /etc/hosts"

For linux just add a hosts entry for localhost::

    sudo sh -c "echo 127.0.0.1  mp.dev' >> /etc/hosts"


3. Build and run boxes
----------------------

Run::

    $ fig build

    $ fig run mysql /bin/bash
        # mysqld_safe &
        # mysql -uroot
          create database zamboni;
    $ fig run zamboni python manage.py syncdb
    $ fig up

.. note:: This can take a long time.

When complete open up a browser to http://mp.dev

4. Other Manual Steps
---------------------

* For fireplace you'll need to manually create a fireplace/src/media/js/settings_local.js  
  file, this should look like this: https://gist.github.com/muffinresearch/0555302e210adf6dc760

5. Issues
---------

Come talk to us on irc://irc.mozilla.org/marketplace if you have questions,
issues, or compliments.
