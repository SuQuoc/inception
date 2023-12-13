# inception
This project is designed to teach you about docker and docker-compose. For some (like me) its also the first time learning about nginx, wordpress and mariadb and using it in a amateur manner. Each service has its own Dockerfile. I recommend doint it in the following order:

__1. Nginx - webserver__
   
   Nginx is like a gateway for websites. It helps direct and manage the flow of visitors coming to a website.
   It ensures that visitors can access the website quickly and efficiently, even when many people are trying to visit at the same time.


__2. WordPress - CMS (Content management system)__

  WordPress is a tool to build websites easily, even if you're not a tech expert. It's like the Microsoft Word for websites.
    You can create and manage a website or blog without knowing how to code. It's great for beginners and used by many websites on the internet.
    __Note:__ needs a database in order to work


__3. MariaDB - database (a fork from mysql)__

  MariaDB is a place to store and organize information for websites. It's like a virtual filing cabinet where websites keep their data. It ensures websites can quickly access and manage information, making them dynamic and interactive.



Together, these three work as a team: Nginx helps people reach the website, WordPress lets you easily create and manage the site's content, and MariaDB stores the information the website needs to work properly.

## Environment variables with .env 
The .env file is an example. Your real credentials should not be pushed to git (incl. 42).


## Locations of files, dirs, etc.
__Nginx__
* nginx.conf:        /etc/nginx/conf.d/

__Mariadb__
* my.cnf:             /etc/mysql
* 50-server.cnf:			/etc/mysql/mariadb.conf.d/50-server.cnf

__Wordpress__
* wp-config.php			/var/www/html/ (in my case append: qtran.42.fr/wordpress)

__Docker__
* volumes /var/lib/docker/volumes  (u dont have access so u have to start a secure shell to get into it: sudo -s)

__Local machine__
* hosts					/etc/


## Problems i faced:
- not seeing a page with login.42.fr
	- add the name of your website to /etc/hosts file
- having 2 instances of mariadb service (in 1 container) running
	- switched from mysqld_safe -datadir=... & to service mariadb start
	- probably used mysqld twice instead of using mysql
- both mariadb instances exiting with 137
	- changed the CMD in Dockerfile from mysqld_safe to "mariadbd -uroot"
	- i guess docker cant terminate mysqld_safe correctly
- mysql_secure_installation not working
	- stil dont know, problematic because of interactive mode

# Whats ...
- port-mapping (=forwarding) in general and in docker
    -  to forward incoming traffic from port to be forwarded to another port of a machine
    -  normally a router blocks incoming traffic which was not requested by you (for exmaple looking up a webpage)
    -  with forwarding the traffic can be forwarded without you requesting it 
- the difference between mysql vs mysqld (mariadb vs mariadbd)
    - mysqld is the server executable (one of them)
    - mysql is the command line client
    - mysqladmin is a maintenance or administrative utility
	- https://dev.mysql.com/doc/refman/8.0/en/mysqld.html
	- https://dev.mysql.com/doc/refman/8.0/en/mysql.html
- the difference between mysql and mariadb (as Command-Line Client)
	- nothing, mariadb is a symlink to mysql (cmdline-cli)
	- so every mariadb-cli can be replaced by mysql (so most or all things STARTING with "mariadb", meaning the cli. For example NOT "service mariadb start")
	- https://mariadb.com/kb/en/mariadb-command-line-client/
- "service mariadb start" ("or service mysql start")
	- uses the init script associated with the MariaDB service to start and manage the mariadbd daemon
- mysqld_safe
	- is a script and not a system service, so you wouldn't use the service command to start it.
	- https://dev.mysql.com/doc/refman/8.0/en/mysqld-safe.html 
- query
	- In relational database management systems, a query is any command used to retrieve data from a table.
- the difference between static and dynamic web-pages
	- static:
		- each page on a static website is a single html file, which is served from the server to the web-page (visitor)	 
		- every visitor will see the same page
		- the content is predefined in the source code and can only change if the original-html code changes
		- practical for resume pages, any website that shouldnt change based on the user (if users are even required)
		- the page can stil be interactive but whats visible is predefined in the code  
		the source code (the code for your page, inlcuding buttons etc., so the page CAN change ) is not build on the server and is already defined in the code and lies ON a server 
	- dynamic:
		- the same website (or page) is different for every user (tiktok, youtube, insta)
		- the data of the user (and behaviour) is stored in a database or backend
		- what is shown is not hardcoded 
		- allows you to modify multiple pages aty the same time
	- https://www.wix.com/blog/static-vs-dynamic-website

## Good to know
- u should NOT RUN docker as root, also not in the container --> create a user and keyword USER 
- create users to run the service, never use the root for actual production etc.
- avoid killall to kill a process, problematic if you are running multiple processes
- when creating the wp-config.php the name of:
	- database
	- user
	- user password
	- hostname
  must match the mariadb database configuration (also the service in.yml must match the hostname)
- wp cli (wordpress command line interface)
	- https://developer.wordpress.org/cli/commands/
- docker cli
	- https://docs.docker.com/engine/reference/commandline/cli/
	- https://docs.docker.com/get-started/docker_cheatsheet.pdf
	- https://devhints.io/docker-compose
- tuning mysql performance (or mariadb) --> my.cnf 
	- https://releem.com/docs/mysql-performance-parameters
- difference between UNIX and IP Sockets
	- A UNIX socket, AKA Unix Domain Socket, is an inter-process communication mechanism that allows bidirectional data exchange between processes running on the same machine.
	- UNIX sockets know that they’re executing on the same system, so they can avoid some checks and operations (like routing); which makes them faster and lighter than IP sockets. So if you plan to communicate with processes on the same host, this is a better option than IP sockets.

	- IP sockets (especially TCP/IP sockets) are a mechanism allowing communication between processes over the network. (in some cases you could use it for processes on the same hostmachine)
	- sockets are used for client-server services
	- they contain the IP-address of the machine appended by a port number
	- all ports up to 1024 are "well kown" meaning, they are used for standard services like email, https, etc.
- difference between http and https
	- http sends information via the internet through plain text
	- meaning everyone who can intercept the messages can see and understand it (messages, passwords, bank information)
	- https uses encryption to make your message undreadable for interceptors 
	- only the server you talk to can decrypt the message using it's private key (they agreed on a session key before using )
- mysql cli basics:
	- use "database"
	- show tables
	- select * from "tablename"

