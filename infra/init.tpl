#! /bin/bash

sudo -i 

apt-get update

apt-get install apache2 -y

service apache2 restart



echo "Hello World" > /var/www/html/index.html