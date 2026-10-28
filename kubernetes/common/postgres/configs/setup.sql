--- System Setup
\getenv pg_primary_user PG_PRIMARY_USER
\getenv pg_primary_password PG_PRIMARY_PASSWORD
\getenv pg_user PG_USER
\getenv pg_password PG_PASSWORD
\getenv pg_database PG_DATABASE

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

CREATE USER :"pg_primary_user" WITH REPLICATION;
ALTER USER :"pg_primary_user" PASSWORD :'pg_primary_password';

CREATE USER :"pg_user" LOGIN;
ALTER USER :"pg_user" PASSWORD :'pg_password';

CREATE DATABASE :"pg_database";
GRANT ALL PRIVILEGES ON DATABASE :"pg_database" TO :"pg_user";

--- PG_DATABASE Setup

\c :"pg_database"

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

GRANT ALL ON SCHEMA public TO :"pg_user";
CREATE SCHEMA IF NOT EXISTS :"pg_user" AUTHORIZATION :"pg_user";
