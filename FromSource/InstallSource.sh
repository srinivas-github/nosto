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

install_mysql_source()
{
    #get the source
    SrcDir="MySQLSrc"
    [[ -d $SrcDir ]] || mkdir $SrcDir

    cd ./$SrcDir
 
    #Preconfiguration steps
    groupadd mysql
    useradd -r -g mysql -s /bin/false mysql


    apt-get source mysql-5.5
    # Get the source directory
    mysql_src=$(find . -mindepth 1 -maxdepth 1 -type d)
    cd $mysql_src

    if [ $? -eq 0 ]; then
        mkdir bld
	cd bld
	cmake ..
	if [ $? eq 0 ]; then
	    echo -e "\n cmake successful..\n"
	    make
	    if [ $? -eq 0 ]; then
	        echo -e "\n make successful..\n"
		sudo make install 
		if [ $? -eq 0 ]; then
		    echo -e "\n make install successful..\n"
		fi
	    fi
	fi
    fi

    #post installation 
    cd /usr/local/mysql
    chown -R mysql .
    chgrp -R mysql .
    scripts/mysql_install_db --user=mysql
    chown -R root .
    chown -R mysql data

}

install_apache_source()
{
    # get the source package
    SrcDir="Apache2Src"
    
    [[ -d $SrcDir ]] || mkdir $SrcDir

    cd ./$SrcDir 
    apt-get source apache2
    apache2_src=$(find . -mindepth 1 -maxdepth 1 -type d)
    cd $apache2_src
    ./configure
    if [ $? -eq 0 ]; then
        echo -e "\n configure sucess.."
	make
	if [ $? -eq 0 ]; then 
	    echo -e "\n Make success..."
	    sudo make install
	    fi [$? -eq 0 ]; then
	    fi
	fi
    fi
    

}

##Main Starts here

install_base_packages


install_mysql_source
install_apache_source


