FROM debian:bullseye

#-y flag: assume yes -> installing non interactive
RUN apt-get update
RUN apt-get install -y nginx openssl


RUN mkdir /etc/nginx/ssl

#might be unnece. since the files, dirs will have the permissions of the USER executing the docker file
#applies cmds run in here as well

#RUN chmod 700 /etc/nginx/ssl

RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/qtran.crt \
       -keyout /etc/nginx/ssl/qtran.key \
       -subj "/C=AT/ST=Vienna/L=Vienna/O=42 School/OU=qtran/CN=qtran/"


COPY ./config/nginx.conf /etc/nginx/conf.d/

# nginx config
RUN mkdir -p /run/nginx

#the only port allowed
#EXPOSE	443

# Start nginx
CMD ["nginx", "-g", "daemon off;"]