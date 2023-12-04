
NGINX_DIR 		= srcs/requirements/nginx
WORDPRESS_DIR 	= srcs/requirements/wordpress
MARIADB_DIR 	= srcs/requirements/mariadb
COMPOSE_DIR 	= srcs

all:
	echo "NO all"


# mariadb____________________________________________________________
mariadb:
# might have to add this line
# sudo service mysql stop
	docker build -t mariadb:inc $(MARIADB_DIR)
	docker run --env-file ./srcs/.env -p 3306:3306 --name mariadbtainer mariadb:inc

mdbClean:
	docker stop mariadbtainer
	docker rm -f mariadbtainer
	docker rmi mariadb:inc

mdbRe: mdbClean
	make mariadb

mdbIn:
	docker exec -it mariadbtainer bash

mdbCompClean:
	docker-compose -f ./$(COMPOSE_DIR)/docker-compose.yml down
	docker rmi mariadb:inc
	docker volume rm srcs_mariadb-data
	docker image prune -f

# nginx______________________________________________________________
nginx:
	docker build -t nginx:inc $(NGINX_DIR)
	docker run -p 443:443 --name nginxtainer nginx:inc

nstart:
	docker start nginxcontain

nredocker:
	docker stop nginxcontain
	docker rm -f nginxcontain
	docker rmi nginx:inc

# Wordpress______________________________________________________________
wp:
	docker build -t wordpress:inc $(WORDPRESS_DIR)
	docker run -p 9000:9000 --name wptainer wordpress:inc

wpstart:
	docker start wptainer

wpClean:
	docker stop wptainer
	docker rm -f wptainer
	docker rmi wordpress:inc

# General docker_____________________________________________________
dimd:
	docker images


dtainer:
	docker ps -a 



# Docker volumes____________________________________________________
# removing all docker containers
rmalldc:
	docker rm -f $$(docker ps -aq)

# removing all docker images
rmalldi:
	docker rmi -f $$(docker images -q)

dVolPrune: rmalldc
	docker volume prune -f
	docker volume rm srcs_mariadb-data
	docker volume rm srcs_wordpress-data


# deleting wordpress volume
resetV:
	sudo rm -r /var/lib/docker/volumes/srcs_wordpress-data

# Docker compose____________________________________________________
dCompUp:
	docker-compose -f ./$(COMPOSE_DIR)/docker-compose.yml up --build

dCompDown:
	docker-compose -f ./$(COMPOSE_DIR)/docker-compose.yml down
	docker volume rm srcs_mariadb-data
	docker volume rm srcs_wordpress-data


PHONY: nginx nstart nredocker rmalldc rmalldi dimg dtainer dVolPrune dCompUp dCompDown resetV dVolPrune
