#!/bin/bash

NENG_DB_PASS=$(echo $NENG_PASS)
NENG_DB_USER=$(echo $NENG_USER)
ROOT_PWD=$(echo $MYSQL_ROOT_PWD)
MARIADB_GALERA_HOST=$(echo $MARIADB_HOST)
NENG_DB_NAME=$(echo $NENG_DB)
NENG_DB_HOST=$(echo $NENG_HOST)

prepare_password()
{
  echo "$1" | sed -e "s/'/\\\\'/g; s/\"/\\\\\"/g"
}

NENG_DB_PASS='prepare_password ${NENG_DB_PASS}'

mysql -h$MARIADB_GALERA_HOST -uroot -p$ROOT_PWD << EOF || exit 1
DROP USER IF EXISTS '${NENG_DB_USER}'@'%';
CREATE OR REPLACE USER '${NENG_DB_USER}'@'%' IDENTIFIED BY '${NENG_DB_PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${NENG_DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysql -h$MARIADB_GALERA_HOST -uroot -p$ROOT_PW $NENG_DB_NAME < /my-data/nengdb-backup.sql
