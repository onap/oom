--- System Setup
SET application_name="container_setup";

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pgaudit;

--- Log slow statements only. The image hardcodes log_duration = on, which writes a line for
--- every statement (~580 MB a day on a busy database) until the volume is full, and it offers
--- no postgresql.conf hook to override it -- ALTER SYSTEM is the only way in. Slow statements
--- are still logged, with their text, by log_min_duration_statement.
ALTER SYSTEM SET log_duration = off;
ALTER SYSTEM SET log_min_duration_statement = 1000;

ALTER USER postgres PASSWORD '${PG_ROOT_PASSWORD}';

CREATE USER ${PG_PRIMARY_USER} WITH REPLICATION;
ALTER USER ${PG_PRIMARY_USER} PASSWORD '${PG_PRIMARY_PASSWORD}';

CREATE USER "${PG_USER}" LOGIN;
ALTER USER "${PG_USER}" PASSWORD '${PG_PASSWORD}';

CREATE DATABASE ${PG_DATABASE};
GRANT ALL PRIVILEGES ON DATABASE ${PG_DATABASE} TO "${PG_USER}";

CREATE TABLE IF NOT EXISTS primarytable (key varchar(20), value varchar(20));
GRANT ALL ON primarytable TO ${PG_PRIMARY_USER};

--- PG_DATABASE Setup

\c ${PG_DATABASE}

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pgaudit;

--- Verify permissions via PG_USER

\c ${PG_DATABASE} "${PG_USER}";

CREATE SCHEMA IF NOT EXISTS "${PG_USER}";

CREATE TABLE IF NOT EXISTS "${PG_USER}".testtable (
    name varchar(30) PRIMARY KEY,
    value varchar(50) NOT NULL,
    updatedt timestamp NOT NULL
);

INSERT INTO "${PG_USER}".testtable (name, value, updatedt) VALUES ('CPU', '256', now());
