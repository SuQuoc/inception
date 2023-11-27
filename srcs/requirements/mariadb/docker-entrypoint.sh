#!/bin/bash

mysql_install_db #seems unecessary if using volumes?

/etc/init.d/mysql start

if [ -d "var/lib/mysql/$MY_SQL_DATABASE" ]
then
    echo "Database already exists"
else
#Set root option so that connexion without root password is not possible
# each y and n was for the following setup-requests from mysql
# 1. change root pw?
# 2. remove anonymous users?
# 3. disallow root login remotely?
# 4. remove test database and access to it?
# 5. relaod privilege tables now?

mysql_secure_installation << EOF

y 
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
y
n
y
y
EOF

# mysql -u root -p #open the database, and enter the root pw
# CREATE DATABASE MYSQL; - Enter
# USE MYSQL #changing the database to be used
# SHOW DATABASES;
CREATE USER 'root'@'%' IDENTIFIED BY $MYSQL_ROOT_PASSWORD; # Creating new user for database
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
#SHOW GRANTS FOR user1@localhost
#DROP USER user1@localhost


CREATE DATABASE $MY_SQL_DATABASE; # creating database for the website qtran.42.fr
GRANT ALL ON $MY_SQL_DATABASE.* TO "$MYSQL_USER"@'%' IDENTIFIED BY $MYSQL_PASSWORD;
FLUSH PRIVILEGES;
mysql -u root #why do we connect

mysql -u root -p $MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql

fi

/etc/init.d/mysql stop
exec "$@"