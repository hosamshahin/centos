#!/usr/bin/env bash

# ===================================================================
# bootstrap.sh
# DESCRIPTION =======================================================
# Bootstrap file for Logstash Vagrant host.
# Sets up Apache/PHP environment from scratch
# Safe to re-run provision of vagrant host after initial setup
#
# AUTHOR ============================================================
# gary-rogers@uiowa.edu
#
# NOTES
# ===================================================================

# ===================================================================
# Variables
# ===================================================================
VAGRANT_HOST=web
UPDATE_SYSTEM=0
TIME_ZONE_FILE=/usr/share/zoneinfo/US/Central

# ===================================================================
# Functions
# ===================================================================
start_if_stopped () {
  if [ ! -z "$1" ]
  then
    service=$1
    value=$(service ${service} status | grep -c started)
    if [ $value -eq 0 ]
    then
      service ${service} start
    fi
  else
    printf "[ERROR] no parameter passed to start_if_stopped.\n"
  fi
}

# ===================================================================
# Pretify logging to screen
# ===================================================================
printLog() {
  printf "[${VAGRANT_HOST}-bootstrap] $1\n";
}

installManPages() {
  FILE=/usr/bin/man
  if [ ! -f $FILE ]; then
    printLog "Installing man pages";
    yum --quiet -y install man;
  fi
}

installApache() {
  FILE=/usr/sbin/httpd
  if [ ! -f $FILE ]; then
    printLog "Installing httpd";
    yum --quiet -y install httpd
    chkconfig httpd on

    printLog "Altering httpd config";
    FILE=/etc/httpd/conf/httpd.conf
    perl -pi -e 's/#ServerName www.example.com:80/ServerName localhost.localdomain:80/g' $FILE

    start_if_stopped httpd
  fi
}

installPerl() {
  FILE=/usr/bin/perl
  if [ ! -f $FILE ]; then
    printLog "Installing Perl";
    yum --quiet -y install perl
  fi
}

installGcc() {
  value=$(rpm -qa | grep -c ^gcc)
  if [ $value -eq 0 ]; then
    printLog "Installing gcc";
    yum --quiet -y install gcc
  fi
}

installKernelDevel() {
  value=$(rpm -qa | grep -c ^kernel-devel)
  if [ $value -eq 0 ]; then
    printLog "Adding kernel-devel\n";
    yum --quiet -y install kernel-devel
  fi
}

installRPMKeys() {
  value=$(rpm -qi gpg-pubkey | grep -c 'centos-6-key@centos.org')
  if [ $value -eq 0 ]; then
    printLog "Installing CentOS RPM Signing Key";
    rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6
  fi

  value=$(rpm -qi gpg-pubkey | grep -c 'epel@fedoraproject.org')
  if [ $value -eq 0 ]; then
    printLog "Installing Fedora RPM Signing Key";
    rpm --import https://fedoraproject.org/static/0608B895.txt
  fi
}

installVimEnhanced() {
  value=$(rpm -qa vim-enhanced | wc -l)
  if [ $value -eq 0 ]; then
    printLog "Installing Vim Enhanced";
    yum --quiet -y install vim-enhanced
  fi
}

configureShell() {
  # ===================================================================
  # Set up annoying shell and vim configs for root.
  # ===================================================================
  value=$(grep -c "set -o vi" ~root/.bashrc)
  if [ $value -eq 0 ]; then
    echo 'set -o vi' >> ~root/.bashrc
  fi

  if [ ! -f ~root/.vimrc ]; then
    touch ~root/.vimrc
  fi

  value=$(grep -c "set tabstop=2" ~root/.vimrc)
  if [ $value -eq 0 ]; then
    echo 'set tabstop=2' >> ~root/.vimrc
  fi

  # ===================================================================
  # Setting up annoying shell and vim configs for vagrant.
  # ===================================================================
  value=$(grep -c "set -o vi" ~vagrant/.bashrc)
  if [ $value -eq 0 ]; then
    echo 'set -o vi' >> ~vagrant/.bashrc
  fi

  if [ ! -f ~vagrant/.vimrc ]; then
    touch ~vagrant/.vimrc
    chown vagrant.vagrant ~vagrant/.vimrc
  fi

  value=$(grep -c "set tabstop=2" ~vagrant/.vimrc)
  if [ $value -eq 0 ]; then
    echo 'set tabstop=2' >> ~vagrant/.vimrc
  fi

}

installOracleInstantClient() {
  # ===================================================================
  # Install Oracle Support for PHP
  # (http://www.oracle.com/technetwork/articles/dsl/technote-php-instant-084410.html)
  # ===================================================================
  if [ $(rpm -qa | grep -c 'oracle-instantclient') -eq 0 ]; then
    printLog 'Installing Oracle Client'
    yum --quiet -y install libaio

    yum -y --nogpgcheck --quiet install /opt/packages/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
    yum -y --nogpgcheck --quiet install /opt/packages/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm

    cat > /etc/profile.d/oracle.sh <<EOM
export ORACLE_HOME=/usr/lib/oracle/11.2/client64
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export TNS_ADMIN=$ORACLE_HOME/network/admin
EOM

    export ORACLE_HOME=/usr/lib/oracle/11.2/client64
    export PATH=$PATH:$ORACLE_HOME/bin
    export LD_LIBRARY_PATH=$ORACLE_HOME/lib
    export TNS_ADMIN=$ORACLE_HOME/network/admin

    mkdir -p /usr/lib/oracle/11.2/client64/network/admin -p
  fi
}

installEPEL() {
  if [ ! -f /etc/yum.repos.d/epel.repo ]; then
    printLog "Adding EPEL (Extra Packages for Enterprise Linux) repository to yum";
    yum --quiet -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
  fi
}

installGit() {
  if [ ! -f /usr/bin/git ]; then
    printLog "Adding Git version controll";
    yum --quiet -y install git
  fi
}

installPHP() {
  if [ $(rpm -qa | grep -c 'php') -eq 0 ]; then
    printLog 'Installing PHP'

    installGcc;

    installEPEL;

    installGit;

    yum --quiet -y install php

    yum --quiet -y install php-pear
    yum --quiet -y install php-devel
    yum --quiet -y install php-xml
    yum --quiet -y install php-mcrypt
    yum --quiet -y install php-ldap
    yum --quiet -y install php-soap
    yum --quiet -y install php-mbstring
    yum --quiet -y install php-gd
    yum --quiet -y install php-bcmath

    yum --quiet -y install php-mysql
    yum --quiet -y install php-mssql
    yum --quiet -y install php-oci8

    printLog 'Installing OCI8 extension for PHP'
    printf "instantclient,/usr/lib/oracle/11.2/client64/lib" | pecl install oci8

    # bits to add oci to php.ini
    echo 'extension=oci8.so' >> /etc/php.ini

    perl -pi -e "s/;date.timezone.*/date.timezone = \"America\/Chicago\"/g" /etc/php.ini
  fi
}

# ===================================================================
# Main Section
# ===================================================================

# ===================================================================
# Set Timezone
# ===================================================================
printLog "Setting Timzone for host";
mv /etc/localtime /etc/localtime.orig
ln -s $TIME_ZONE_FILE /etc/localtime

# ===================================================================
# Update environment via yum.
# ===================================================================
if [ $UPDATE_SYSTEM -eq 1 ]; then
  printLog "Updating Environment\n";
  yum --quiet -y update

  # ===================================================================
  # Install kernel bits.
  # We need them to rebuild the VirtualBox Guest Additions
  # ===================================================================
  installKernelDevel;

  # ===================================================================
  # Install GCC.
  # We need it to rebuild the VirtualBox Guest Additions
  # ===================================================================
  installGcc;

  # ===================================================================
  # Update VirtualBox Additions
  # ===================================================================
  /etc/init.d/vboxadd setup
fi

# ===================================================================
# Install software
# ===================================================================

installRPMKeys;
installManPages;
installPerl;
installApache;
installVimEnhanced;
# installOracleInstantClient;
# installPHP;
configureShell;

# ===================================================================
# Configure Environment
# ===================================================================
if [ $(grep -c 'webapp' /etc/httpd/conf/httpd.conf) -eq 0 ]; then
  cat >> /etc/httpd/conf/httpd.conf <<EOM
<IfModule alias_module>
  Alias /webapp /local/www/webapp
</IfModule>

<Directory "/local/www/webapp">
  Options Indexes FollowSymLinks MultiViews
  AllowOverride All
  Order allow,deny
  Allow from all
</Directory>
EOM

service httpd restart
