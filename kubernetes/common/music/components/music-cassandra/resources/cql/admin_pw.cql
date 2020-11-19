CREATE ROLE IF NOT EXISTS {{.Values.cql.adminUser.username}}
WITH PASSWORD = '{{.Values.cql.adminUser.password}}'
AND SUPERUSER = true
AND LOGIN = true;

ALTER ROLE cassandra
WITH PASSWORD = '{{.Values.cql.adminUser.passwordReplace}}';

