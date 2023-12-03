#!/bin/bash


# if [ -f "/home/quocsu/inception/srcs/.env" ]; then
#   source /home/quocsu/inception/srcs/.env
# fi

if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]
then
  # if the database already exist i dont have to setup mysql again
  echo "Database already exists: /var/lib/mysql/$MYSQL_DATABASE"
else
  #mysql_install_db #might not be necessary since mariadb 10.2
  
  # starting it with safe will lead double login try, not rly a problem but stil dont like it 
  /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
  until mysqladmin ping 2> /dev/null; do
    sleep 2
  done
  
  echo "DOES THIS DOLLAR SHIT WORK?: '$MYSQL_ROOT_PASSWORD'"
  
  mysql -u root <<EOF
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    # Setup root PW since its without one right now
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    
    # Removes root user entries that are configured to connect from hosts other than the local machine.
    DELETE FROM mysql.user WHERE user='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    
    # deletes user accounts from the mysql.user table where the username is an empty string ('').
    DELETE FROM mysql.user WHERE user='';
    
    # Creating a user with PW with all privileges on DATABASE able to login from ANY IP-addr
    CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOF
  # dont know why this doesnt work:
  #mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
  #until ! mysqladmin ping 2> /dev/null; do
  #  sleep 1
  #done

  #killall mysqld_safe 2> /dev/null #doesnt kill the process maybe because the script is a wrapper and only stops if mariadb stops
  # only the following cmd workd inside the container but didnt stop double login try
  killall mariadbd 2> /dev/null
fi

exec "$@"



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


