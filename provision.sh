# pre-installation
apt-get -y update
apt-get -y install dkms
apt-get -y install curl
apt-get -y install libxml2-dev libxslt-dev
apt-get -y install git
apt-get -y install vim
apt-get -y install emacs
apt-get -y install python-dev
apt-get -y install python-feedvalidator
apt-get -y install python-software-properties
apt-get -y install python-pip
apt-get -y install libevent-dev
apt-get -y install libffi-dev
apt-get -y install libssl-dev
apt-get -y install build-essential
apt-get -y update

# Install apache and mode_wsgi
apt-get -y install apache2
apt-get -y install libapache2-mod-wsgi

# install virtualenv
pip install virtualenv

# Create Virtualenv
cd /vagrant/reg_service
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt

# Apache Settings
cp /vagrant/reg_service/apache/reg_service.conf /etc/apache2/conf-enabled/reg_service.conf

chmod -R 777 /vagrant/reg_service/log/service.log

# Restart apache
service apache2 restart
