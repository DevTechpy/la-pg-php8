#!/bin/bash
cp /home/docker/la-pg-php8/.env /var/www/html/gestapp/
cd /var/www/html/
git clone https://edmenn@bitbucket.org/edmenn/gestapp.git

chmod 777 -R /var/www/html/gestapp
chown docker:docker -R /var/www/html/gestapp/*
cd /var/www/html/gestapp/

docker run --rm -v $(pwd):/app composer install
chmod 777 -R /var/www/html/gestapp

cd /home/docker/la-pg-php8/
docker-compose up --build -d

docker exec -ti php php artisan migrate
docker exec -ti php php artisan db:seed
docker exec -ti php php artisan serve
docker exec -ti php php artisan key:generate
