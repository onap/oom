CREATE KEYSPACE testks
    WITH REPLICATION = {
        'class' : '{{.Values.cql.keyspace.replicationClass}}',
        'replication_factor': {{.Values.cql.keyspace.replicationFactor}}
    }
    AND DURABLE_WRITES = true;

CREATE TABLE testks.keyspace_master_table (
    uuid uuid,
    keyspace_name text,
    application_name text,
    is_api boolean,
    password text,
    username text,
    is_aaf boolean,
    PRIMARY KEY (uuid)
);

DESCRIBE KEYSPACES;
DESCRIBE keyspace testks;
SELECT * FROM system_auth.roles;
DROP keyspace testks;

