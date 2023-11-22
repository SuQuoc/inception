#!/bin/sh

mkdir -p /var/www/html
cd /var/www/html

### Get wp client (only seen on github, no other guides)
# rm -rf * #necessary?
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar 
mv wp-cli.phar /usr/local/bin/wp
wp core download --allow-root #necessary?
### 


wget http://wordpress.org/latest.tar.gz
tar xfz latest.tar.gz
mkdir /var/www/html/qtran.42.com #creating dir (unsure if name makes sense here)
cp -R wordpress /var/www/html/qtran.42.com  #copy wp
chown -R www-data:www-data /var/www/html/qtran.42.fr
rm -rf latest.tar.gz
rm -rf wordpress



#Changing the following values in the wordpress(or your web-page name)/wp-config-sample.php
sed -i "s/database_name_here/$MYSQL_DATABASE/1" wp-config-sample.php
sed -i "s/username_here/$MYSQL_USER/1" wp-config-sample.php
sed -i "s/password_here/$MYSQL_PASSWORD/1" wp-config-sample.php
sed -i "s/localhost/$MYSQL_HOSTNAME/1" wp-config-sample.php
cp wp-config-sample.php wp-config.php

#sed (editor) changing strings in a file (in-place)
#sed -i (in-place) "s/pattern/replacement/options" filename
#s: This is the substitute command itself.
#options:
#   - 1, changes 1st occurrence
#   - g, chnages all occurrences


mkdir -p /run/php

# to execute the CMD in Dockerfile
exec "$@"