#!/usr/bin/env bash

#
# Setup script
#


PACKAGE_DIR="FromPackage"
SOURCE_DIR="FromSource"


echo -e "\nAutomation demo that setsup a VM,installs and Configures Mysql and Apache2 service."
echo -e "This Setup Uses Vagrant tool, which will bring up Ubuntu VM."
echo -e "\n Using shell provision method to configure the services on the VM"

echo -e "Select a method to install service:"
echo -e "[1]From apt-get install [2]From Source: [1/2]: "
read input

#echo -e "\n Input: $input\n"

if [ $input -eq 1 ]; then 
    cd $PACKAGE_DIR
    echo -e "\n installing from apt-get.."
elif [ $input -eq 2 ]; then 
    cd $SOURCE_DIR
    echo -e "\n installing from source.."
fi


#echo -e "\n vagrant-vbguest install to avoid Guest additions warnings"
#vagrant plugin install vagrant-vbguest

echo -e "\nvagrant up"
vagrant up

if [ $? -eq 0 ]; then 
    echo -e "\n ---Done---"
fi


