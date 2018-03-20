#!/bin/bash -xv

for db in support onap_sdk log
do
	mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" --execute "CREATE DATABASE IF NOT EXISTS ${db};"
	mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" --execute "GRANT ALL PRIVILEGES ON \`${db}\`.* TO '${MYSQL_USER}'@'%' ;"
done

mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" --execute "FLUSH PRIVILEGES;"
