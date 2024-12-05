#!/bin/bash

#Nothing to see here
if [[ -d /passoire/flags-enc ]]; then
	/passoire/.h/b.sh
	/passoire/flags/init.sh
fi

# Start DB, web server and ssh server
sudo -n service mysql restart
sudo -n service ssh restart
sudo -n service apache2 restart

# Start crypto helper api
sudo -n /passoire/crypto-helper/crypto-helper.sh stop
sudo -n /passoire/crypto-helper/crypto-helper.sh start

DB_NAME="passoire"
DB_USER="passoire"
DB_PASSWORD=$(head -n 1 /passoire/config/db_pw)

# Initialize database
#mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
#mysql -u root -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
#mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
#mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'localhost' WITH GRANT OPTION;"
#mysql -u root -e "FLUSH PRIVILEGES;"

#sudo -n mysql -u root ${DB_NAME} < config/passoire.sql

# Redirect querry from website root to our main page
#rm /var/www/html/index.html
#echo "<?php header(\"Location: passoire/index.php\"); ?>" | sudo -n tee /var/www/html/index.php > /dev/null
echo "<?php header(\"Location: passoire/index.php\"); ?>" > /var/www/html/index.php

# Link apache dir and our web dir
#ln -s /usr/share/phpmyadmin/ /var/www/html/phpmyadmin
#ln -s /passoire/web/ /var/www/html/passoire

# Adapt to our ip
#echo "127.0.0.1 db" | sudo -n tee /etc/hosts > /dev/null
sudo -n chmod 664 /etc/hosts
echo "127.0.0.1 db" >> /etc/hosts

if [ -z "$HOST" ]; then
  HOST=$(hostname -i)
fi

echo "Web server running at http://$HOST"

sed -i "s/CONTAINER_IP/$HOST/g" /passoire/web/crypto.php
sed -i "s/CONTAINER_IP/$HOST/g" /passoire/crypto-helper/server.js

sudo -n touch /passoire/logs/crypto-helper.log

# Monitor logs
tail -f /passoire/logs/crypto-helper.log /var/log/apache2/access.log /var/log/apache2/error.log