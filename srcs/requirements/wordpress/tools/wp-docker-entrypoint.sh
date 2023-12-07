#!/bin/sh

if [ -f /var/www/html/qtran.42.fr/wordpress/wp-config.php ]; then
    echo "WordPress already setup"
else
    # Get wp client
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar 
    mv wp-cli.phar /usr/local/bin/wp # adding it to PATH

    # Creating the directory where i want to store my php (html) files for my web-page
    mkdir -p /var/www/html/qtran.42.fr/wordpress
    cd /var/www/html/qtran.42.fr/wordpress
    
    # acknowledge that you are intentionally running WP-CLI as the root user, avoid unless necessary
    wp core download --allow-root

    # Creating the wp-config.php file
    wp config create \
        --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=$MYSQL_HOSTNAME

    wp core install \
        --allow-root \
        --url=https://$DOMAIN_NAME \
        --title=qtranInception \
        --admin_user=$WP_ADMIN \
        --admin_password=$ADMIN_PW \
        --admin_email=$ADMIN_EMAIL \
        --skip-email #Don’t send an email notification to the new admin user (email service not setup).

    wp user create \
        --allow-root \
        $WP_EDITOR \
        $EDITOR_EMAIL \
        --role=editor \
        --user_pass=$EDITOR_PW
fi

# if this is put in the if statement, the 2nd time compose up is called wont work
# cause the volume is not mounting this dir 
mkdir -p /run/php 


# to execute the CMD in Dockerfile
# --> try to use /usr/sbin/php-fpm7.4 in this script and CMD ["-F"] (heard its better but not sure)
exec "$@"



