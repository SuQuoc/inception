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
  
  service mariadb start
  
  until mysqladmin ping 2> /dev/null; do
    sleep 2
  done
  echo "BREAKPOINT !!!!!!!!!"
  echo "BREAKPOINT !!!!!!!!!"
  echo "BREAKPOINT !!!!!!!!!"
  echo "BREAKPOINT !!!!!!!!!"
  echo "BREAKPOINT !!!!!!!!!"
  
  #echo "DOES THIS DOLLAR SHIT WORK?: '$MYSQL_ROOT_PASSWORD'"
  
  mysql -u root << EOF
    
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    
    # Setup root PW since its without one right now
    FLUSH PRIVILEGES;
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    
    # Removes root user entries that are configured to connect from hosts other than the local machine.
    #DELETE FROM mysql.user WHERE user='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    
    # deletes user accounts from the mysql.user table where the username is an empty string ('').
    DELETE FROM mysql.user WHERE user='';
    
    # Creating a user with PW with all privileges on DATABASE able to login from ANY IP-addr
    CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
    SHOW DATABASES;
EOF

  # necessary to prevent exit code 1 but doint know why
  mysqladmin -uroot -p$MYSQL_ROOT_PASSWORD shutdown 
  
fi

exec "$@"
