create database {{.Values.global.config.mariadb.mysqlDatabase}};

CREATE USER '{{.Values.global.config.mariadb.userName}}'@'%' IDENTIFIED BY '{{.Values.global.config.mariadb.userPassword}}';
GRANT ALL PRIVILEGES ON *.* TO '{{.Values.global.config.mariadb.userName}}'@'%' WITH GRANT OPTION;
