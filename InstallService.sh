#! /usr/bin/env bash

###
#
# Simple MySQL server/ apache2 service config
# 
###
# Variables
DBHOST=localhost
DBNAME=srinudb
DBUSER=srinu
DBPASSWD=root123


install_base_packages()
{
    echo -e "\n--- installing now... ---\n"
    echo -e "\n--- Updating packages list ---\n"
    sudo apt-get -qq update

    echo -e "\n--- Install base packages ---\n"
    sudo apt-get -y install vim curl build-essential rpm python-software-properties git >> /vagrant/vm_build.log 2>&1

    echo -e "\n--- Updating packages list ---\n"
    sudo apt-get -qq update

}
install_mysql_package()
{
    # MySQL setup for development purposes ONLY
    echo -e "\n--- Install MySQL specific packages and settings ---\n"
    sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $DBPASSWD"
    sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $DBPASSWD"

    sudo apt-get -qq update
    sudo apt-get -y install mysql-server-5.5 php5-mysql >> /vagrant/vm_build.log 2>&1

    echo -e "\n--- Setting up our MySQL user and db ---\n"
    if [ ! -f /var/log/databasesetup ];
    then
        echo "CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY 'srinupass'" | mysql -uroot -p$DBPASSWD
        echo "CREATE DATABASE $DBNAME" | mysql -uroot -p$DBPASSWD
        echo "GRANT ALL ON $DBNAME.* TO '$DBUSER'@'localhost'" | mysql -uroot -p$DBPASSWD
        echo "flush privileges" | mysql -uroot -p$DBPASSWD
			
        touch /var/log/databasesetup

        if [ -f /vagrant/data/initial.sql ];
        then
            mysql -uroot -p$DBPASSWD $DBNAME < /vagrant/data/initial.sql
        fi
    fi

}
install_apache2_package()
{
   sudo apt-get -qq update
   echo -e "\n Install apache2 pacakages and settings ---\n"
   sudo apt-get -y install apache2 php5 >> /vagrant/vm_build.log 2>&1
   echo -e "\n Setting up the apache2 service...\n"

   if [ ! -h /var/www ];
   then 
       sudo rm -rf /var/www
       sudo ln -s /vagrant/public /var/www
       a2enmod rewrite
       sudo sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default
       service apache2 restart
   fi
}

install_mysql_source()
{
    
}

install_apache_source()
{
}

##Main Starts here
install_base_packages

#Install and Confgiure Mysql Service
echo -e "\n Install Mysql from below options:\n" 
echo -e "[1] Install from Package(deb)"
echo -e "[2] Install from Source"
read installOpt



