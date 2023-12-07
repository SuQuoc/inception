
NGINX_DIR 		= srcs/requirements/nginx
WORDPRESS_DIR 	= srcs/requirements/wordpress
MARIADB_DIR 	= srcs/requirements/mariadb
COMPOSE_DIR 	= srcs

# Docker compose____________________________________________________
all:
	docker-compose -f ./$(COMPOSE_DIR)/docker-compose.yml build

start:
	docker-compose -f ./$(COMPOSE_DIR)/docker-compose.yml start

stop:
	docker-compose -f ./$(COMPOSE_DIR)/docker-compose.yml stop

up:
	docker-compose -f ./$(COMPOSE_DIR)/docker-compose.yml up

down:
	docker-compose -f ./$(COMPOSE_DIR)/docker-compose.yml down

dCompReset:
	docker-compose -f ./$(COMPOSE_DIR)/docker-compose.yml down
	docker rmi wordpress:inc
	docker rmi mariadb:inc
	docker rmi nginx:inc
	docker volume rm srcs_mariadb-data
	docker volume rm srcs_wordpress-data

# Docker volumes____________________________________________________

# removing all docker containers
rmalldc:
	docker rm -f $$(docker ps -aq)

# removing all docker images
rmalldi:
	docker rmi -f $$(docker images -q)

# removing all docker volumes
dVolPrune: rmalldc
	docker volume prune -f
	docker volume rm srcs_mariadb-data
	docker volume rm srcs_wordpress-data


# mariadb____________________________________________________________
mariadb:
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


PHONY:	all forceBuild stop down dCompReset \
		mariadb mdbClean mdbRe mdbIn mdbCompClean \
		nginx nstart nredocker \
		wp wpstart wpClean \
		rmalldc rmalldi dVolPrune \
