CREATE KEYSPACE IF NOT EXISTS admin
    WITH REPLICATION = {
        'class' : '{{.Values.cql.keyspace.replicationClass}}',
        'replication_factor': {{.Values.cql.keyspace.replicationFactor}}
    }
    AND DURABLE_WRITES = true;

CREATE TABLE IF NOT EXISTS admin.keyspace_master (
    uuid uuid,
    keyspace_name text,
    application_name text,
    is_api boolean,
    password text,
    username text,
    is_aaf boolean,
    PRIMARY KEY (uuid)
);

describe keyspaces;
