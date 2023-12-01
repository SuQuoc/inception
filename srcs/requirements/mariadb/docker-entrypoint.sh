#!/bin/bash


if [ -f "/home/quocsu/inception/srcs/.env" ]; then
  source /home/quocsu/inception/srcs/.env
fi
#
#
if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]
then
    echo "Database already exists: /var/lib/mysql/$MYSQL_DATABASE"
    cat /var/lib/mysql/$MYSQL_DATABASE
else
  mysql_install_db
  #mysqld
  #service mysql start

  #/etc/init.d/mariadb start
  /usr/bin/mysqld_safe --datadir=/var/lib/mysql &

  until mysqladmin ping 2> /dev/null; do
        sleep 2
    done


  echo "DOES THIS DOLLAR SHIT WORK?: '$MYSQL_ROOT_PASSWORD'"
  
  mysql -u root <<EOF
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    
    DELETE FROM mysql.user WHERE user='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    DELETE FROM mysql.user WHERE user='';
    
    CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    
    FLUSH PRIVILEGES;
EOF
  killall mysqld 2> /dev/null
  #/etc/init.d/mariadb stop
  #service mysql stop
fi


exec "$@"

# mysql_install_db #seems unecessary if using volumes?

# changed mysql to mariadb
#/etc/init.d/mariadb start


#mysql -u root << EOF
#  CREATE USER 'root'@'%' IDENTIFIED BY someshitPW; # Creating new user for database
#  GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
#  FLUSH PRIVILEGES;
#
#  CREATE DATABASE $MYSQL_DATABASE; # creating database for the website qtran.42.fr
#  GRANT ALL ON $MYSQL_DATABASE.* TO "$MYSQL_USER"@'%' IDENTIFIED BY $MYSQL_PASSWORD;
#  FLUSH PRIVILEGES;
#EOF
#
# mysql -u root #why do we connect

# mysql -u root -p $MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql # whats that shit for 


#/etc/init.d/mariadb stop
#fi


