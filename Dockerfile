# Pull from the ubuntu image
FROM ubuntu:16.04

# Set the author
MAINTAINER Dani Jimenez <dani.jimenez@waynabox.com>

# Update cache and install base packages
RUN apt-get update && apt-get -y install \
   sudo \
   software-properties-common \
   python-software-properties \
   debian-archive-keyring \
   wget \
   curl \
   vim \
   aptitude \
   dialog \
   net-tools \
   mcrypt \
   build-essential \
   tcl8.5 \
   git


# setting main user and adding it to sudoers
RUN adduser www-data sudo
RUN echo "www-data ALL=NOPASSWD: ALL" >>  /etc/sudoers

# Download Nginx signing key
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C300EE8C

#########################
# Nginx
#########################
# Add to repository sources list
RUN add-apt-repository ppa:nginx/stable
# Update cache and install Nginx
RUN apt-get update && apt-get install nginx -y && usermod -u 1000 www-data
# remove default server if exists
RUN unlink /etc/nginx/sites-enabled/default
RUN rm -f /etc/nginx/sites-available/default


#########################
# PHP 7.x libs and tools
#########################
# Add to repository sources list
RUN apt-get install software-properties-common
RUN apt-get update && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

# Update cache and install Nginx
RUN apt-get update && apt-get install nginx -y && usermod -u 1000 www-data
RUN apt-get update && apt-get install php7.1-fpm \
                                      php7.1-cli \
                                      php7.1-bcmath \
                                      php7.1-mcrypt \
                                      php7.1-json \
                                      php7.1-opcache \
                                      php7.1-mysql \
                                      php7.1-mbstring \
                                      php7.1-gd \
                                      php7.1-imap  \
                                      php7.1-xdebug \
                                      php7.1-intl \
                                      php7.1-gd \
                                      php7.1-curl \
                                      php7.1-zip \
                                      php7.1-xml \
                                      php7.1-yaml -y

RUN apt-get --purge autoremove -y


RUN mkdir -p /usr/local/bin
COPY scripts/*.* /usr/local/bin/
RUN cp /usr/local/bin/nginx.conf /etc/nginx/
RUN cp /usr/local/bin/php.ini /etc/php/7.1/fpm

RUN sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/7.1/fpm/pool.d/www.conf
RUN find /etc/php/7.1/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;


#########################
# TIME ZONE
#########################
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime


#########################
# CRON
#########################
RUN apt-get update && apt-get -y install cron
# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

USER root

# Expose port 80
EXPOSE 80
EXPOSE 443


# port needed by xdebug
EXPOSE 9000



# Mount volumes
VOLUME /var/log/nginx/
VOLUME /var/www/current
VOLUME /usr/local/config

# Set the current working directory
WORKDIR /var/www/current

# define entrypoint
ENTRYPOINT ["/bin/bash", "/usr/local/bin/start.sh"]





