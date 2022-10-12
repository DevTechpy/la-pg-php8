#!/bin/bash

echo "Starting docker community edition install..."
echo "Removing any old instances of docker and installing dependencies"
apt remove -y docker docker-engine docker.io containerd runc
apt update
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

echo "Dowloading latest docker and adding official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

echo "Pulling the latest repository"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt update

echo "Installing docker community edition"
apt install -y docker-ce docker-ce-cli containerd.io

echo "Docker install completed, installing docker-compose"

echo "Dowloading docker-compose 2.11.2 - be sure to update to the latest stable"
curl -L "https://github.com/docker/compose/releases/download/2.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

echo "Setting binary permissions"
chmod +x /usr/local/bin/docker-compose

echo “Docker and docker-compose install complete”

# Run docker as non-root user on Ubuntu
sudo usermod -aG docker $USER

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
