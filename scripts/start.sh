#!/usr/bin/env bash
# additional operations

ASSETS_DIR=/usr/local/bin

CUSTOM_FILE_DIR=/usr/local/config

rm -f /var/www/current/.dependencies_installed

version_to_deploy=$(date -d "2013-04-06" "+%s%N" | cut -b1-13)
echo "Deploying version: ${version_to_deploy}"


echo "copy virtualhosts"
sudo cp ${ASSETS_DIR}/server.conf /etc/nginx/sites-available/
sudo sed -i -e "s/server_name {front_machine_url};/server_name ${FRONT_HOST};/g" /etc/nginx/sites-available/server.conf
sudo sed -i -e "s/index {index_app};/index ${START_PAGE};/g" /etc/nginx/sites-available/server.conf
sudo sed -i "s|{index_app}|${START_PAGE}|g" /etc/nginx/sites-available/server.conf
sudo ln -s /etc/nginx/sites-available/server.conf -t /etc/nginx/sites-enabled/




if [ "${SERVER_PROFILE}" == "dev" ]
    then
        echo "xdebug.remote_enable = 1" >>  /etc/php/7.1/fpm/conf.d/20-xdebug.ini
        echo "xdebug.remote_autostart = 1" >>  /etc/php/7.1/fpm/conf.d/20-xdebug.ini
        echo "xdebug.remote_host=${XDEBUG_IP}" >> /etc/php/7.1/fpm/conf.d/20-xdebug.ini

fi
echo "Installing composer"
/var/www/current/composer.phar install

echo "Deleting caches"
rm -rf /var/www/current/var/cache/

echo "restarting services"
sudo service php7.1-fpm start

touch /var/www/current/.dependencies_installed
sudo nginx
#tail -F /var/log/nginx/error.log
