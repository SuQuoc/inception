#!/bin/sh
    
sed -i "s/database_name_here/$MYSQL_DATABASE/" wp-sample.php
sed -i "s/username_here/$MYSQL_USER/" wp-sample.php
sed -i "s/password_here/$MYSQL_PASSWORD/" wp-sample.php
sed -i "s/localhost/$MYSQL_HOSTNAME/" wp-sample.php
#mv wp-sample.php wp-config.php
