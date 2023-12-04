#!/bin/sh

if [ -f /var/www/html/qtran.42.fr/wordpress/wp-config.php ]; then
    echo "WordPress already setup"
else
    ### Get wp client (only seen on github, no other guides)
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar 
    mv wp-cli.phar /usr/local/bin/wp
    ### 

    mkdir -p /var/www/html/qtran.42.fr/wordpress
    cd /var/www/html/qtran.42.fr/wordpress
    
    wp core download --allow-root

    until mysqladmin --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} --host=mariadb ping; do
		sleep 2
	done

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
        --admin_email=$ADMIN_EMAIL

    wp user create \
        --allow-root \
        $WP_EDITOR \
        $EDITOR_EMAIL \
        --role=editor \
        --user_pass=$EDITOR_PW
fi

mkdir -p /run/php # if this is put in the if statement, the 2nd time call compose up wont work cause it cant find that folder although i have volumes

# to execute the CMD in Dockerfile
# dont like that way --> try to use /usr/sbin/php-fpm7.4 in this script and CMD ["-F"] or "/usr/sbin/php-fpm7.4 -F" and CMD [""] if this works
exec "$@" 



