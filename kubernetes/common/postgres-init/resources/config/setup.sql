--- User Setup
\getenv pg_user PG_USER
\getenv pg_password PG_PASSWORD
\getenv pg_database PG_DATABASE
CREATE USER :"pg_user" LOGIN;
ALTER USER :"pg_user" PASSWORD :'pg_password';

CREATE DATABASE :"pg_database";
GRANT ALL PRIVILEGES ON DATABASE :"pg_database" TO :"pg_user";

--- PG_DATABASE Setup

\c :"pg_database"

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

--- Create schema for PG_USER

CREATE SCHEMA IF NOT EXISTS :"pg_user" AUTHORIZATION :"pg_user";
