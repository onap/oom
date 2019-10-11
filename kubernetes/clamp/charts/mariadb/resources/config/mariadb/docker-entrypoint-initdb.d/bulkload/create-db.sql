#
# Create CLDS database objects (tables, etc.)
#
#
CREATE DATABASE `cldsdb4`;
USE `cldsdb4`;
DROP USER 'clds';
CREATE USER 'clds';
GRANT ALL on cldsdb4.* to 'clds' identified by 'sidnnd83K' with GRANT OPTION;
FLUSH PRIVILEGES;

