#!/bin/bash


if [ -f "/home/quocsu/inception/srcs/.env" ]; then
  source /home/quocsu/inception/srcs/.env
  echo "THis is my VAR: $MYSQL_DATABASE"
fi


if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]
then
    echo "Database already exists: /var/lib/mysql/$MYSQL_DATABASE"
    cat /var/lib/mysql/$MYSQL_DATABASE
else


mysql_install_db #seems unecessary if using volumes?

# changed mysql to mariadb
/etc/init.d/mariadb start

CREATE USER 'root'@'%' IDENTIFIED BY $MYSQL_ROOT_PASSWORD; # Creating new user for database
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
#SHOW GRANTS FOR user1@localhost
#DROP USER user1@localhost

CREATE DATABASE $MY_SQL_DATABASE; # creating database for the website qtran.42.fr
GRANT ALL ON $MY_SQL_DATABASE.* TO "$MYSQL_USER"@'%' IDENTIFIED BY $MYSQL_PASSWORD;
FLUSH PRIVILEGES;
mysql -u root #why do we connect

# mysql -u root -p $MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql # whats that shit for 


/etc/init.d/mariadb stop
fi


exec "$@"