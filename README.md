# Provisioning Vagrant CentOS Hosts

## How to use:

1. Install [Vagrant](https://www.vagrantup.com/downloads)
2. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. `$ vagrant plugin install vagrant-vbguest`
4. Clone this repository to your home directory
5. `$ cd centos`
6. `$ vagrant up`
7. `$ vagrant ssh`
8. `$ sudo yum groupinstall "Development Tools"`
9. `$ sudo yum -y install kernel kernel-devel`
10. `$ exit`
11. `$ vagrant reload`
12. Go to https://192.168.33.10 for webapp

##Suspending and Shutting Down Virtual Machine:

<p>After you finish your working, you need either to suspend and resume your virtual machine or turn it off; you can use one of the following commands upon your choice.</p>

1. `$ vagrant suspend`
2. `$ vagrant resume`
3. `$ vagrant halt`
