# Provisioning Vagrant CentOS Hosts

## How to use:

1. `vagrant plugin install vagrant-vbguest`
1. Install [Vagrant](https://www.vagrantup.com/downloads)
2. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. Clone this repository to your home directory
4. `$ cd centos`
5. `$ vagrant up`
6. `$ vagrant ssh`
9. Go to https://192.168.33.10 for flaskapp

##Suspending and Shutting Down Virtual Machine:

<p>After you finish your working, you need either to suspend and resume your virtual machine or turn it off; you can use one of the following commands upon your choice.</p>

1. `$ vagrant suspend`
2. `$ vagrant resume`
3. `$ vagrant halt`
