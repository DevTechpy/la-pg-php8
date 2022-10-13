#!/bin/bash
apt install docker 
apt install docker-compose

cp la-pg-php8/.env /var/www/html/
mv * /var/www/html/

chmod 777 -R /var/www/html/

cd /var/www/html/

docker run --rm -v  $(pwd):/app composer install


cd /var/www/html/la-pg-php8/

ls -la

docker-compose up --build -d

docker exec -ti php php artisan migrate
docker exec -ti php php artisan db:seed
docker exec -ti php php artisan serve
docker exec -ti php php artisan key:generate
