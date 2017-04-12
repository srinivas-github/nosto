#! /usr/bin/env bash

###
#
# MySQL server/ apache2 service config
# 
###
# Variables
DBHOST=localhost
DBNAME=srinudb
DBUSER=srinu
DBPASSWD=root123


install_base_packages()
{
    echo -e "\nUpdating packages list \n"
    sudo apt-get -qq update

    echo -e "\nInstall base packages \n"
    sudo apt-get -y install vim curl build-essential rpm python-software-properties git >> /vagrant/vm_build.log 2>&1

    echo -e "\nUpdating packages list \n"
    sudo apt-get -qq update

}
install_mysql_package()
{
    # MySQL setup for development purposes ONLY
    echo -e "\n MySQL specific settings \n"
    
    sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $DBPASSWD"
    sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $DBPASSWD"

    sudo apt-get -qq update
    echo -e "\n apt-get install mysql-server"
    sudo apt-get -y install mysql-server-5.5 php5-mysql php5 >> /vagrant/vm_build.log 2>&1

    echo -e "\nSetting up MySQL user and db \n"
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
   echo -e "\napt-get update"
   apt-get -qq update

   echo -e "\nInstall apache2 pacakage \n"
   echo -e "\napt-get -y install apache2"
   apt-get -y install apache2 >> /vagrant/vm_build.log 2>&1
   echo -e "\n Setting up the apache2 service \n"

   if ! [ -L /var/www ]; then 
       echo -e "\n rm -rf /var/www"
       rm -rf /var/www
       echo -e "\n ln -fs /vagrant /var/www"
       ln -fs /vagrant /var/www
       echo -e "\na2enmod rewrite"
       a2enmod rewrite
       if [ $? -eq 0 ]; then
           echo -e "\n a2enmod rewrite done"
       fi
       sudo sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default
       echo -e "\n service apache2 restart"
       service apache2 restart
   fi
}


##Main Starts here
install_base_packages

#Install and Confgiure Mysql Service
install_mysql_package

#Install Apache2 
install_apache2_package


