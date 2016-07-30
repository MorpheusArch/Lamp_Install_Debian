#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.
 
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
 
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 
###############################################################
 
if [ $(id -u) != "0" ]; then
        echo "You must be root to run this script"
        exit 1
fi
 
##############################################################
 
echo "Resolving dependencies for script"
apt-get install sudo
 
##############################################################
 
echo "You need a user account who is in the sudoers list"
echo "Please enter normal user account name"
read username
adduser $username sudo 2>/dev/null
 
###############################################################
 
echo ""
echo "Performing system upgrade"
echo ""
 
apt-get update && apt-get upgrade -y
 
###############################################################
 
echo ""
echo "Installing MySQL"
echo ""
apt-get install mysql-server mysql-client
 
################################################################
 
echo ""
echo "Installing PHP"
apt-get install php5 php5-mysql libapache2-mod-php5
echo ""
 
################################################################
 
echo ""
echo "Installing apache2-doc"
echo ""
apt-get install apache2-doc
 
################################################################
 
echo ""
echo "Restarting apache2"
service apache2 restart
echo ""
################################################################
 
echo ""
echo "Enabling apache userdir module"
a2enmod userdir
echo ""
 
#################################################################
 
echo ""
echo "Downloading apache userdir.conf"
wget https://pastebin.com/raw/74cZYZ6G -O userdir.conf
echo ""
 
#################################################################
 
echo ""
sleep 1
if cmp -s "$userdir.conf" "$/etc/apache2/mods-enabled/userdir.conf"
then
   echo "userdir.conf is configured correctly"
   echo "Deleting downloaded userdir.conf since one installed is correct"
   sleep 2
   rm userdir.conf
else
   echo "userdir.conf is different from Debian wiki"
   echo "Moving userdir.conf to /etc/apache2/mods-enabled/userdir.conf"
   rm /etc/apache2/mods-enabled/userdir.conf
   mv userdir.conf /etc/apache2/mods-enabled/userdir.conf
fi
 
sleep 2
echo ""
 
####################################################################
 
echo ""
echo "The directory 'public_html' must be created with user account NOT as root"
sleep 1
echo "Logging out as root"
logout 2>/dev/null
 
#####################################################################
 
echo "What is your username to create the 'public_html' directory?"
read username
echo "Hello, $username please wait for directory to be created"
mkdir /home/$username/public_html
sleep 2
echo ""
 
 
####################################################################
 
echo "Verifying permissions of public_html"
cd /home/$username
sudo chmod +0750 public_html
echo "Permissions set"
 
#####################################################################
 
echo ""
echo "Changing public_html group as root"
sudo chgrp www-data /home/$username/public_html
echo ""
 
######################################################################
 
echo ""
echo "Restarting apache2"
sudo service apache2 restart
sleep 2
echo ""
 
######################################################################
 
echo ""
echo "Displaying apache2 status"
echo ""
sudo service apache2 status
 
######################################################################
 
echo ""
echo "Downloading php5.conf"
echo ""
 
wget https://pastebin.com/raw/TP7QGKXD -O php.conf
 
if cmp -s "$php.conf" "$/etc/apache2/mods-available/php.conf"
then
   echo "php.conf is configured correctly"
   echo "Deleting downloaded php.conf since one installed is correct"
   sleep 2
   rm php.conf
else
   echo "php.conf is different from Debian wiki"
   echo "Moving php.conf to /etc/apache2/mods-available/php.conf"
fi
 
#######################################################################
 
echo "Creating phpinfo"
echo "<?php phpinfo(); ?>" >> /var/www/html/test.php
echo ""
 
#######################################################################
 
echo "Install complete...Navigate your browser to localhost and locolhost/test.php"
 
#######################################################################
