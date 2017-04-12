#!/usr/bin/env bash

#
# Setup script
#


PACKAGE_DIR="FromPackage"
SOURCE_DIR="FromSource"


echo -e "\n Automation tool that setsup a VM,installs and Configures Apache2 service."
echo -e "This Setup Uses Vagrant tool (version 1.9.3), which will bring up Ubuntu VM."
echo -e "Select a method to install service:"
echo -e "[1]From apt-get install [2]From Source: [1/2]: "
read input
echo -e "\n Input: $input\n"

if [ $input -eq 1 ]; then 
    cd $PACKAGE_DIR
    echo -e "\n Vagrant up"
    vagrant up
    if [ $? -eq 0 ]; then 
        echo -e "\n Successfully Configured VM..."
    fi
elif [ $input -eq 2 ]; then 
    cd $SOURCE_DIR
    echo -e "\n Calling Vagrant up (From Source)"
    vagrant up
    if [ $? -eq 0 ]; then
        echo -e "\n Successfully Configured VM..."
    fi
fi


