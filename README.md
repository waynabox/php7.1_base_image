# Base Docker image with php7.1 and Nginx for Symfony

This repo contains a base Docker image ready to work with Symfony projects.


## Installation

Just clone the repo, build the docker image:

```sh
git clone git@github.com:jagerchief/php7.1-nginx-dockerImage.git
cd php7.1-nginx-dockerImage
docker build -t universal_php_nginx:latest .
```


## Usage
Use the image in your docker-compose file:
```yml
version: '3'
services:
  myservice:
    image: universal_php_nginx:latest
    ports:
      - 8083:80
    volumes:
      - "../source:/var/www/current"
    environment:
      - FRONT_HOST=myproject.local
      - XDEBUG_IP=192.168.1.134
      - START_PAGE=app_dev.php
    network_mode: "bridge"
```

Ensure you complete these items in order to work:
 - Map the volumes correctly. In my case my Symfony code is inside /source folder and docker-compose.yml is inside /build folder. Map your own.
 - This image assumes your Symfony entrypoint is inside /web folder. If not the case, you can change it by modifying /scripts/server.conf file (root parameter) of this repo and build the image again.
 - The START_PAGE parameter represents the entrypoint file in previous specified folder
 - Replace XDEBUG_IP with your local IP if you want to debug your application




License
----

MIT
**Free Software, Hell Yeah!**
