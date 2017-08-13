# The Sinatra app for REA Group

The following process describes the deployment of the REA Group Sinatra app.
https://github.com/rea-cruitment/simple-sinatra-app

The deployment of the O/S is controlled using Vagrant. The O/S version is Centos 7.2.

**Prerequisites**

* Vagrant (https://www.vagrantup.com)
* VirtualBox (https://www.virtualbox.org)
* A Git client (eg https://git-scm.com)

**Installation**

1) Clone the following repository:
  $ git clone git://github.com/pclonan/sinatra
  Cloning into 'sinatra'...
  remote: Counting objects: 486, done.
  remote: Compressing objects: 100% (255/255), done.
  remote: Total 486 (delta 210), reused 424 (delta 164), pack-reused 0
  Receiving objects: 100% (486/486), 116.52 KiB | 141.00 KiB/s, done.
  Resolving deltas: 100% (210/210), done.
  Checking connectivity... done.

2) Run "vagrant up"
  $ cd sinatra/
  $ vagrant up
