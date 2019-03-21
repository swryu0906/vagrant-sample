#!/bin/bash

# debconf uses the frontend that expects no interactive inputs
export DEBIAN_FRONTEND=noninteractive


########################################
#
########################################
# Refresh repository index
apt-get update
# apt update

# Upgrade all upgradable packages
apt-get upgrade
# apt upgrade

# Install git
apt-get install -y git
# apt install -y git



# Install Apache 2.4 from the Ubuntu repository
apt-get install -y apache2
# apt install -y apache2

# Disable the event module
a2dismod mpm_event

# Enable the prefork module
a2enmod mpm_prefork



# Set MySQL password
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# Install MySQL
apt-get install -y mysql-server
# apt install -y mysql-server



# Install PHP, the PHP extension and application repository, Apache support, and MySQL support
apt-get install -y php7.0 libapache2-mod-php7.0 php7.0-mysql
# apt-get install -y php7.2 libapache2-mod-php7.2 php-mysql
# apt install -y php7.0 libapache2-mod-php7.0 php7.0-mysql
# apt install -y php7.2 libapache2-mod-php7.2 php-mysql

# Optionally, install additional cURL, JSON, and CGI support
apt-get install php7.0-curl php7.0-json php7.0-cgi
# apt-get install php-curl php-json php-cgi
# apt install php7.0-curl php7.0-json php7.0-cgi
# apt install php-curl php-json php-cgi

# Restart Apache
systemctl restart apache2


## Set phpMyAdmin settings
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-user string root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/database-type select mysql'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/setup-password password root'


# Install phpMyAdmin
apt-get -yq install phpmyadmin
# apt install -yq phpmyadmin
apt-get install php-mbstring php-gettext
# apt install php-mbstring php-gettext

# Enable the PHP mcrypt and mbstring
phpenmod mcrypt
phpenmod mbstring

# Restart Apache
systemctl restart apache2
