FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y \
    mariadb-server \
    mariadb-client


RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld
RUN chmod 777 /var/run/mysqld

# the .sql file:
# typically contains SQL commands that set up the database schema 
# and populate it with initial data.
# COPY ./conf/wordpress.sql /usr/local/bin/
# RUN chmod +x /usr/local/bin/wordpress.sql
# EDIT SCRIPT AS WELL !!!!!!!!

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh 
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld", "--bind-address=0.0.0.0"]