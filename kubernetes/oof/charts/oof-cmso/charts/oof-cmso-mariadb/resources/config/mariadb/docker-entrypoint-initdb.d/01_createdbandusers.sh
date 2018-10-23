#!/bin/sh

echo "Creating cmso database . . ."
mysql -uroot -p$MYSQL_ROOT_PASSWORD << 'EOF' || exit 1
CREATE DATABASE IF NOT EXISTS `cmso` ;
CREATE USER IF NOT EXISTS 'cmso_admin';
GRANT USAGE ON *.* TO 'cmso_admin'@'%' IDENTIFIED BY 'nimda_osmc';
GRANT ALL PRIVILEGES on *.* to 'root'@'%';
GRANT ALL on cmso.* to 'cmso_admin'@'%' with GRANT OPTION;
FLUSH PRIVILEGES;
EOF
