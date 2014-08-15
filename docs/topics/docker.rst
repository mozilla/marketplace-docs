Docker
======

.. note:: Setting up with Docker is currently in beta. Feedback welcome.

Using Docker is the recommended configuration for developers new to the
Marketplace. You can set up the Marketplace without using Docker, but this will
automate a lot of the steps.

Requirements
------------

Mac OS X or Linux.

1. Install docker
-----------------

`Install docker <https://docs.docker.com/installation/>`_. All the following
assumes that you install `boot2docker`.


2. Install Vagrant
------------------

`Install Virtualbox <https://www.virtualbox.org/wiki/Downloads>`_.

3. Build dependencies
---------------------

Run::

    git clone https://github.com/mozilla/wharfie
    cd wharfie

    bin/wharfie whoami mozilla
    bin/wharfie checkout
    sudo sh -c "echo '$(boot2docker ip 2>/dev/null)  mp.dev' >> /etc/hosts"

    pip install virtualenvwrapper
    mkvirtualenv wharfie
    workon wharfie
    pip install --upgrade pip
    pip install -r requirements.txt

    boot2docker stop
    mv ~/.boot2docker/boot2docker.iso{,.bck}
    curl -o ~/.boot2docker/boot2docker.iso https://dl.dropboxusercontent.com/u/8877748/boot2docker.iso
    VBoxManage sharedfolder add boot2docker-vm -name trees -hostpath "$(pwd)/wharfie/trees/"
    boot2docker up
    boot2docker ssh 'sudo modprobe vboxsf && sudo mkdir -p "$(pwd)/wharfie/trees/" && sudo mount -t vboxsf trees "$(pwd)/wharfie/trees"'

.. note:: Please see the discussion on `wharfie whoami`_.

4. Build and run boxes
----------------------

Run::

    fig build
    fig run

.. note:: This can take a long time.

When complete open up a browser to http://mp.dev

5. Issues
---------

Come talk to us on irc://irc.mozilla.org/marketplace if you have questions,
issues, or compliments.

Notes
-----

wharfie whoami
==============

The `wharfie whoami` command checks out repositories from that users account.
The quickest way to check out repositories is from the `mozilla` account. But
if you are making pull requests, you'll want to fork each repository and then
run the `whoami` command as your user account on github.
