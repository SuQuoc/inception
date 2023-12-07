FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y \
    mariadb-server \
    mariadb-client

# ka warum ich den Block brauche weils die dirs schon so geben sollte 
RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql
RUN chmod 755 /run/mysqld


COPY ./conf/my.cnf /etc/mysql/my.cnf
RUN chmod 644 /etc/mysql/my.cnf
RUN chown -R mysql:mysql /etc/mysql/my.cnf

# COPY ./50-server.cnf /etc/mysql/mariadb.conf.d/
# RUN chown -R mysql:mysql /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh 
EXPOSE 3306
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["mariadbd", "-uroot"]
