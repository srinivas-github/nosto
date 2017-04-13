# nosto
Automation that sets up a virtual machine and installs & configures a service by using vagrant.
In this Demo we are using Vagrant tool bring UP a Ubuntu VM (using the hashicorp/precise64) box.

What is Vagrant?

Vagrant is a tool for building and managing virtual machine environments in a single workflow.
With an easy-to-use workflow and focus on automation, Vagrant lowers development environment 
setup time, increases production parity.

Why Vagrant?

Vagrant provides easy to configure, reproducible, and portable work environments built on top 
of industry-standard technology and controlled by a single consistent workflow to help maximize 
the productivity and flexibility.

Reuirements:
1. Vagrant and VirtualBox
   Please install the latest version of Vagrant: https://www.vagrantup.com/docs/installation/
   And because we will be using VirtualBox as provider, so please install that as well: https://www.virtualbox.org/

In this setup, provisioning the two services: 
1. Mysql 5.5
2. Apache2

Running the setup:
Run the "setup.sh". This scripts asks for user input (installation method of the services).
Enter 1 to install the service from apt-get 
Enter 2 to install the service from Source code

Testing:
1. Login to the VM: 
   run the following command to login to the vm:
    shell>> vagrant ssh
2. To Test apache2  service:
    Port forward option in provided for apache2 service. 
	Open a browser from host machine and enter the following IP: http://localhost:4568
3. To Test Mysql Service:
   cd /usr/local/mysql	on VM and run the following commands:
   version:
   shell> bin/mysqladmin version
   
   Use mysqlshow to see what databases exist:
   shell> bin/mysqlshow
   
   
   

  
