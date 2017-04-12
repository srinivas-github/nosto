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
    echo -e "\nUpdating packages list \n"
    sudo apt-get -qq update

    echo -e "\nInstall base packages \n"
    sudo apt-get -y install vim curl build-essential rpm python-software-properties git cmake >> /vagrant/vm_build.log 2>&1

    echo -e "\nUpdating packages list \n"
    sudo apt-get -qq update

    echo -e "\nInstall curses library \n"
    sudo apt-get -y install libncurses5-dev libncursesw5-dev

}

install_mysql_source()
{
    #get the source
    SrcDir="MySQLSrc"
    CMCahceFile="CMakeCache.txt"
    [[ -d $SrcDir ]] || mkdir $SrcDir

    cd ./$SrcDir
 
    #Preconfiguration steps
    echo -e "\n Preconfiguration steps"
    echo -e "\n groupadd mysql"
    groupadd mysql
    echo -e "\n useradd -r -g mysql -s /bin/false mysql"
    useradd -r -g mysql -s /bin/false mysql

    echo -e "\n apt-get source mysql-5.5"
    apt-get source mysql-5.5

    # Get the source directory
    mysql_src=$(find . -mindepth 1 -maxdepth 1 -type d)
    cd $mysql_src

    echo -e "\n Finding the file CMakeCache.txt"
    if [ -f "$CMCahceFile" ]; then 
        rm -rf $CMCahceFile
    fi


    if [ $? -eq 0 ]; then
        mkdir bld
	cd bld
        if [ -f "$CMCahceFile" ]; then
	   rm -rf $CMCahceFile
        fi


	echo -e "\n cmake .."
	cmake ..
	if [ $? -eq 0 ]; then
	    echo -e "\n make"
	    make
	    if [ $? -eq 0 ]; then
	        echo -e "\n sudo make install"
		sudo make install 
		if [ $? -eq 0 ]; then
		    echo -e "\n make install successful..\n"
		fi
	    fi
	fi
    fi

    #post installation 
    echo -e "\n Post Installation steps"
    echo -e "\n cd /usr/local/mysql"
    cd /usr/local/mysql
    echo -e "\n chown -R mysql ."
    chown -R mysql .
    echo -e "\n chgrp -R mysql ."
    chgrp -R mysql .
    echo -e "\n scripts/mysql_install_db --user=mysql"
    scripts/mysql_install_db --user=mysql
    echo -e "\n chown -R root ."
    chown -R root .
    echo -e "\n chown -R mysql data"
    chown -R mysql data

}

install_apache_source()
{
    # get the source package
    #cd ../../

    ApaSrc="Apache2Src"
    
    [[ -d $ApaSrc ]] || mkdir $ApaSrc

    cd ./$ApaSrc 
    echo -e "\n apt-get source apache2"
    apt-get source apache2
    apache2_src=$(find . -mindepth 1 -maxdepth 1 -type d)
    cd $apache2_src
    echo -e "\n ./configure"
    ./configure
    if [ $? -eq 0 ]; then
        echo -e "\n configure sucess..calling make"
	make
	if [ $? -eq 0 ]; then 
	    echo -e "\n Make success...calling make install"
	    sudo make install
	fi
    fi
}

##Main Starts here

install_base_packages

#install_mysql_source

install_apache_source


