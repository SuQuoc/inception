
NGINX_DIR = srcs/requirements/nginx

all:
	echo "NO all"

nginx:
	docker build -t nginx:incept $(NGINX_DIR)
	docker run -d -p 443:443 --name nginxcontain nginx

nstart:
	docker start nginxcontain

nredocker:
	docker stop nginxcontain
	docker rm -f nginxcontain
	docker rmi nginx

resetV:
	sudo rm -r /var/lib/docker/volumes/srcs_wordpress-data

.PHONY: nginx nstart nredocker
