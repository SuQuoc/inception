FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y \
    mariadb-server \
    mariadb-client

# ka warum ich den Block brauche
RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld
RUN chmod 777 /var/run/mysqld

# the .sql file:
# typically contains SQL commands that set up the database schema 
# and populate it with initial data.
# COPY ./conf/wordpress.sql /usr/local/bin/
# RUN chmod +x /usr/local/bin/wordpress.sql
# EDIT SCRIPT AS WELL !!!!!!!!

COPY ./my.cnf /etc/mysql/
COPY ./50-server.cnf /etc/mysql/mariadb.conf.d/
RUN chown -R mysql:mysql /etc/mysql/my.cnf
RUN chown -R mysql:mysql /etc/mysql/mariadb.conf.d/50-server.cnf

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh 
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 3306
CMD ["/usr/bin/mysqld_safe", "--datadir=/var/lib/mysql"]