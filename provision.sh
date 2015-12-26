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
apt-get -y install libpq-dev
apt-get -y install build-essential
apt-get -y update

# Install apache and mode_wsgi
apt-get -y install apache2
apt-get -y install libapache2-mod-wsgi

# install virtualenv
pip install virtualenv
pip install virtualenv --upgrade

# Create Virtualenv
cd /vagrant/reg_service
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt

# Apache Settings
cp /vagrant/reg_service/apache/reg_service.conf /etc/apache2/conf-enabled/reg_service.conf

# for reg_service application
chmod -R 777 /vagrant/reg_service/log/service.log

# install fullstack flask application
pip install cookiecutter
cookiecutter https://github.com/sloria/cookiecutter-flask.git --no-input

# create virtualenv
cd /vagrant/myflaskapp
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt

# add the following to .bashrc file and reopen the shell
# export MYFLASKAPP_ENV='prod' 
# export MYFLASKAPP_SECRET='something-really-secret'
python manage.py db init
python manage.py db migrate
python manage.py db upgrade

# Apache Settings
cp /vagrant/myflaskapp_config/myflaskapp.conf /etc/apache2/conf-enabled/myflaskapp.conf

# for myflask application
chmod -R 777 /vagrant/myflaskapp/myflaskapp/static/.webassets-cache

# Restart apache
service apache2 restart
