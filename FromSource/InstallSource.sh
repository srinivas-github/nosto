#! /usr/bin/env bash

###
#
# Simple MySQL server/ apache2 service config
# 
###
HOME_DIR="/home/vagrant"
MYSQL_SRC="$HOME_DIR/MysqlSrc"
APACHE2_SRC="$HOME_DIR/Apache2Src"

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
    CMCahceFile="CMakeCache.txt"
    [[ -d $MYSQL_SRC ]] || mkdir -p $MYSQL_SRC

    cd $MYSQL_SRC
 
    #Preconfiguration steps
    echo -e "\n Preconfiguration steps"
    echo -e "\n groupadd mysql"
    groupadd mysql
    echo -e "\n useradd -r -g mysql -s /bin/false mysql"
    useradd -r -g mysql -s /bin/false mysql

    echo -e "\n apt-get source mysql-5.5"
    apt-get source mysql-5.5

    # Get the source directory
    mysql_src_dir=$(find . -mindepth 1 -maxdepth 1 -type d)
    cd $mysql_src_dir

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
    sudo chown -R mysql .
    echo -e "\n chgrp -R mysql ."
    sudo chgrp -R mysql .
    
    echo -e "\nsudo bin/mysqld --initialize --user=mysql"
    sudo bin/mysqld --initialize --user=mysql
   
    echo -e "\nbin/mysql_ssl_rsa_setup"
    sudo bin/mysql_ssl_rsa_setup

    echo -e "\n chown -R root ."
    sudo chown -R root .
    echo -e "\n chown -R mysql data"
    sudo chown -R mysql data

    echo -e "\nRunning mysql service.."
    sudo bin/mysqld_safe --skip-grant-tables &

}

install_apache_source()
{
    
    [[ -d $APACHE2_SRC ]] || mkdir -p $APACHE2_SRC

    cd ./$APACHE2_SRC 
    echo -e "\n apt-get source apache2"
    apt-get source apache2
    apa_src=$(find . -mindepth 1 -maxdepth 1 -type d)
    cd $apa_src
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

install_mysql_source

install_apache_source


