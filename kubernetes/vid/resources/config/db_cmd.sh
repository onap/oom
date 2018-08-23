#!/bin/sh
#mysql -uroot -p${MYSQL_ROOT_PASSWORD} -h${MYSQL_HOST} -P3306 < /db-config/vid-pre-init.sql
echo "Going to run mysql -uvidadmin -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -P3306 ..."
mysql -uvidadmin -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -P3306 < /db-config/vid-pre-init.sql
if [ $? -ne 0 ];then
        echo "ERROR: Failed to run ${cmd} vid-pre-init.sql"
        exit 1
else
        echo "INFO: Database initialized successfully"
fi
