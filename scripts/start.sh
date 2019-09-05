#!/usr/bin/env bash
# additional operations


echo "Setting up debuger"
if [ "${SERVER_PROFILE}" == "dev" ]
    then
        echo "xdebug.remote_enable = 1" >>  /etc/php/7.1/fpm/conf.d/20-xdebug.ini
        echo "xdebug.remote_autostart = 1" >>  /etc/php/7.1/fpm/conf.d/20-xdebug.ini
        echo "xdebug.remote_host=${XDEBUG_IP}" >> /etc/php/7.1/fpm/conf.d/20-xdebug.ini

fi
echo "Installing composer"
/var/www/current/composer.phar install



echo "restarting services"
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
