FROM debian:bullseye

# -y flag: assume yes -> installing non interactive
RUN apt-get update
RUN apt-get install -y \
    bash \
    curl \
    wget \
    php-fpm \
    php-mysql \
	php \
	php-cgi \
	php-pdo \
	php-gd php-cli \
	php-mbstring

# copy the php www.config (default) file to correct dir
# dont i already have one with installing php-fpm?
COPY www.conf /etc/php/8.1/fpm/pool.d/ 

COPY ./setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh
ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]

#We go the html directory, necessary? already in the script
#WORKDIR /var/www/html/

# make it available for only inter-container communication
# expose port form one container is only available to other containers from the same hostmachine
# port 9000 = TCP
EXPOSE 9000 

#Launch PHP FPM in foreground and ignore deamonize from conf file (-F)
CMD ["/usr/sbin/php-fpm7.4", "-F"]