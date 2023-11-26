

#Set root option so that connexion without root password is not possible
# each y and n was for the following setup-requests from mysql
# 1. change root pw?
# 2. remove anonymous users?
# 3. disallow root login remotely?
# 4. remove test database and access to it?
# 5. relaod privilege tables now?

mysql_secure_installation << EOF

y 
someRootPW2
someRootPW2
y
n
y
y
EOF