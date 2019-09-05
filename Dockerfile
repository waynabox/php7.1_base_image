FROM alpine:3.7
MAINTAINER Daniel Jimenez <dani.jimenez@waynabox.com>

RUN apk --update add tzdata --repository http://dl-4.alpinelinux.org/alpine/edge/testing
RUN cp /usr/share/zoneinfo/Europe/Madrid /etc/localtime
RUN echo "Europe/Madrid" >  /etc/timezone
RUN apk del tzdata
RUN date

# Install packages
RUN apk --update add \
    php7 \
    php7-fpm \
    nginx \
    supervisor \
    git \
    curl \
    unzip \
    nano \
    wget \
    gzip \
    php7-pcntl \
    php7-session \
    php7-gd \
    php7-mcrypt \
    php7-mbstring \
    php7-json \
    php7-xml \
    php7-curl \
    php7-mysqli \
    php7-pdo \
    php7-pdo_mysql \
    php7-iconv \
    php7-dom \
    php7-opcache \
    php7-phar \
    openssl \
    php7-openssl \
    php7-tokenizer \
    php7-xmlwriter \
    php7-simplexml \
    php7-ctype \
    zlib \
    php7-zlib \
    php7-ldap \
    bash


# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf


RUN mkdir -p /usr/local/bin
COPY scripts/*.* /usr/local/bin/

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/docker_custom.conf
COPY config/php.ini /etc/php7/conf.d/docker_custom.ini

# copy default nginx conf
COPY config/default-nginx /etc/nginx/sites-available/default
WORKDIR /etc/nginx/sites-enabled/
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
RUN rm -rf /var/www/current
RUN mkdir -p /var/www/current

VOLUME /var/www/current

WORKDIR /var/www/current

RUN rm -rf /var/cache/apk
RUN rm -rf /root/.composer/cache

EXPOSE 8080
ENTRYPOINT ["/bin/bash", "/usr/local/bin/start.sh"]
