#!/usr/bin/env bash

# Scripts we run before start nginx


ASSETS_DIR=/usr/local/bin
echo "copy virtualhosts"
sudo cp ${ASSETS_DIR}/server.conf /etc/nginx/sites-available/
sudo sed -i -e "s/server_name {front_machine_url};/server_name ${FRONT_HOST};/g" /etc/nginx/sites-available/server.conf

sudo sed -i -e "s/{directory_app}/${ROOT_DIR}/g" /etc/nginx/sites-available/server.conf
sudo sed -i -e "s/index {index_app};/index ${START_PAGE};/g" /etc/nginx/sites-available/server.conf
sudo sed -i "s|{index_app}|${START_PAGE}|g" /etc/nginx/sites-available/server.conf
sudo ln -s /etc/nginx/sites-available/server.conf -t /etc/nginx/sites-enabled/

# Enable xdebug
echo "xdebug.remote_enable = 1" >>  /etc/php/7.1/fpm/conf.d/20-xdebug.ini
echo "xdebug.remote_autostart = 1" >>  /etc/php/7.1/fpm/conf.d/20-xdebug.ini
echo "xdebug.remote_host=${XDEBUG_IP}" >> /etc/php/7.1/fpm/conf.d/20-xdebug.ini


echo "Deleting symfony cache"
rm -rf /var/www/current/var/cache/

rm -rf /var/log/symfony/ -R
rm -rf /var/cache/symfony/ -R

mkdir /var/log/symfony/
mkdir /var/cache/symfony/

chown www-data:www-data /var/log/symfony/ -R
chown www-data:www-data /var/cache/symfony/ -R


echo "restarting services"
sudo service php7.1-fpm start
sudo nginx

