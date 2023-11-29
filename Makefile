
NGINX_DIR = srcs/requirements/nginx
MARIADB_DIR = srcs/requirements/mariadb


all:
	echo "NO all"

mariadb:
# might have to add this line
# sudo service mysql stop
	docker build -t mariadb:inc $(MARIADB_DIR)
	docker run -p 3306:3306 --name mariadbtainer mariadb:inc

nginx:
	docker build -t nginx:incept $(NGINX_DIR)
	docker run -d -p 443:443 --name nginxcontain nginx

nstart:
	docker start nginxcontain

nredocker:
	docker stop nginxcontain
	docker rm -f nginxcontain
	docker rmi nginx

# deleting wordpress volume
resetV:
	sudo rm -r /var/lib/docker/volumes/srcs_wordpress-data



di:
	docker images


dc:
	docker ps -a 

# removing all docker containers
rmalldc:
	docker rm -f $$(docker ps -aq)

# removing all docker images
rmalldi:
	docker rmi -f $$(docker images -q)


.PHONY: nginx nstart nredocker rmalldc di dc
