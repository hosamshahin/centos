Setting Up Vagrant Environment For flask app:
======

## Introduction:

Vagrant designed to run through multiple platforms including currently Mac OS X, Microsoft Windows, Debian, Ubuntu, CentOS, RedHat and Fedora, in this document we will handle how to configure and run simple flask application virtual development environment through Vagrant from scratch to up and running.

## Installation Steps:

- Install [Vagrant v1.8.1](https://www.vagrantup.com/downloads)
- Install [VirtualBox v5.0.12](https://www.virtualbox.org/wiki/Downloads)
- `$ vagrant plugin install vagrant-vbguest`
- Clone this repository to your home directory
- `$ cd centos`
- `$ vagrant up`
- `$ vagrant ssh`
- `$ cd /vagrant`vagrant up
- `$ sudo ./vagrant/provision.sh`
- Go to http://192.168.33.10/horizonreg/users/123 for flask application

## Shut Down The Virtual Machine:

After you finish your work, you need to turn the virtual machine off.

- Exit the virtual machine terminal by typing `exit`
- `$ cd centos`
- `$ vagrant halt`

## Virtual Machine sudo password:

sudo password is `vagrant` in case you need to execute any commands the require sudo.
