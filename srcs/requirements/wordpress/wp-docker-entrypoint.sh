#!/bin/sh

if [ -f /var/www/html/qtran.42.fr/wordpress/wp-config.php ]; then
    echo "WordPress already downloaded"
else
    ### Get wp client (only seen on github, no other guides)
    # rm -rf * #necessary?
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar 
    mv wp-cli.phar /usr/local/bin/wp
    #wp core download --allow-root #necessary?
    ### 


    wget http://wordpress.org/latest.tar.gz # is this prohibited? its not a tag
    tar xfz latest.tar.gz
    mkdir -p /var/www/html/qtran.42.fr #creating dir (unsure if name makes sense here)
    cp -R wordpress /var/www/html/qtran.42.fr  #copy wp
    chown -R www-data:www-data /var/www/html/qtran.42.fr/wordpress
    rm -rf latest.tar.gz
    rm -rf wordpress

    
    #Changing the following values in the wordpress(or your web-page name)/wp-config-sample.php
    cd /var/www/html/qtran.42.fr/wordpress
    sed -i "s/database_name_here/$MYSQL_DATABASE/" wp-config-sample.php
    sed -i "s/username_here/$MYSQL_USER/" wp-config-sample.php
    sed -i "s/password_here/$MYSQL_PASSWORD/" wp-config-sample.php
    sed -i "s/localhost/$MYSQL_HOSTNAME/" wp-config-sample.php
    mv wp-config-sample.php wp-config.php
    #sed (editor) changing strings in a file (in-place)
    #sed -i (in-place) "s/pattern/replacement/options" filename
    #s: This is the substitute command itself.
    #options:
    #   - g, chnages all occurrences
fi

mkdir -p /run/php # if this is put in the if statement, the 2nd time call compose up wont work cause it cant find that folder although i have volumes
# to execute the CMD in Dockerfile
# dont like that way --> try to use /usr/sbin/php-fpm7.4 in this script and CMD ["-F"] or "/usr/sbin/php-fpm7.4 -F" and CMD [""] if this works
exec "$@" 
