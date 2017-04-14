# nosto
Automation script that sets up a virtual machine and installs & configures a service by using vagrant.
In this Demo I am  using Vagrant tool to bring UP a Ubuntu VM (using the hashicorp/precise64) box.

What is Vagrant?

Vagrant is a tool for building and managing virtual machine environments in a single workflow.
With an easy-to-use workflow and focus on automation, Vagrant lowers development environment 
setup time, increases production parity.

Why Vagrant?

Vagrant provides easy to configure, reproducible, and portable work environments built on top 
of industry-standard technology and controlled by a single consistent workflow to help maximize 
the productivity and flexibility.

Reuirements:
1. Vagrant and VirtualBox:
   Install the latest version of Vagrant: https://www.vagrantup.com/docs/installation/
   And we will be using VirtualBox as provider, so install that as well: https://www.virtualbox.org/

In this setup, using "Shell" provision to install and configure the below services: 
1. Mysql 5.5
2. Apache2

Running the setup:

Run the "setup.sh". This scripts asks for user input for choice to install the services.
Enter 1 to install the service from apt-get and Enter 2 to install the service from Source code


Testing:


1. Testing for Service installed from apt-get:

1.1. Login to the VM: 
     run the following command to login to the vm:

     shell>> vagrant ssh


1.2 To Test apache2  service:

    Port forward option in provided Vagrnatfile. Please take a note on Port number while "Vagrant up" 
    "auto-correct: true" is enabled, that means the host port will be changed automatically in case it 
    collides with a port already in use. 
    
    Open a browser from host machine and enter the following IP: http://localhost:<portNo>


1.3. To Test Mysql Service:

     Test the mysql installed version, run the following command:

     shell>>/usr/bin/mysqladmin version -uroot -proot123

     Test enter mysql:
     mysql -u root -proot123

     To See the Databases:
     /usr/bin/mysqlshow -uroot -proot123

        


2. Testing the service installed from Source:

    
   version:
   shell> /usr/local/mysql/bin/mysqladmin version

   
   Use mysqlshow to see what databases exist:
   shell> /usr/local/mysql/bin/mysqlshow


   
   
   

  
