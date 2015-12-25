#!/usr/bin/env bash

# clean-up yum:
sudo yum clean all
sudo yum -y update
sudo yum -y upgrade

# Installing Apache:
sudo yum -y install httpd

# Configure Apache to Start on Boot
sudo systemctl start httpd
sudo systemctl enable httpd

# To check the status of Apache:
sudo systemctl status httpd

# To restart Apache:
sudo systemctl restart httpd

# Enable Firewalld
sudo systemctl enable firewalld

# Start Firewalld
sudo systemctl start firewalld

# Check the Status of Firewalld
systemctl status firewalld

# Allow the default HTTP and HTTPS port, ports 80 and 443, through firewalld:
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp

vagrant plugin install vagrant-vbguest

# guest addition
sudo yum groupinstall "Development Tools"
sudo yum install kernel-devel

vagrant up
vagrant ssh
sudo yum -y install kernel kernel-devel
exit
vagrant reload



