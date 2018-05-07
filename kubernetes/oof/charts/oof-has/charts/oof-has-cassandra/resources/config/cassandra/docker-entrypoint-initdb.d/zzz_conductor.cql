# Copyright © 2017 Amdocs, AT&T, Bell Canada, VMware
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


CREATE KEYSPACE conductor WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}  AND durable_writes = true;

CREATE TABLE conductor.plans (
    id text PRIMARY KEY,
    created bigint,
    message text,
    name text,
    recommend_max int,
    reservation_counter int,
    reservation_owner text,
    solution text,
    solver_counter int,
    solver_owner text,
    status text,
    template text,
    timeout int,
    translation text,
    translation_counter int,
    translation_owner text,
    updated bigint,
    vector_ts text
);

CREATE INDEX conductor_plans_index ON conductor.plans(status);

CREATE KEYSPACE conductor_rpc WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}  AND durable_writes = true;

CREATE TABLE conductor_rpc.controller (
    id text PRIMARY KEY,
    action text,
    args text,
    created bigint,
    ctxt text,
    failure text,
    method text,
    owner text,
    response text,
    status text,
    updated bigint,
    vector_ts text
);

CREATE TABLE conductor_rpc.data (
    id text PRIMARY KEY,
    action text,
    args text,
    created bigint,
    ctxt text,
    failure text,
    method text,
    owner text,
    response text,
    status text,
    updated bigint,
    vector_ts text
);

INSERT INTO admin.keyspace_master (
uuid, application_name, is_aaf, is_api, keyspace_name, password,username)
VALUES ( now(), 'conductor', False, True, 'conductor', 'c0nduct0r', 'conductor');

INSERT INTO admin.keyspace_master (
uuid, application_name, is_aaf, is_api, keyspace_name, password, username)
VALUES( now(), 'conductor', False, True, 'conductor_rpc', 'c0nduct0r', 'conductor');

CREATE ROLE IF NOT EXISTS conductor WITH PASSWORD = 'c0nduct0r' AND LOGIN = true;

GRANT ALL PERMISSIONS on KEYSPACE conductor to 'conductor';

GRANT ALL PERMISSIONS on KEYSPACE conductor_rpc to 'conductor';

INSERT INTO conductor.plans (id, created, message, name, recommend_max, solution, status, template,timeout, translation,updated) VALUES('healthcheck',1479482603641,'','foo',1,'{"healthcheck": " healthcheck"}','solved','{"healthcheck": "healthcheck"}',3600,'{"healthcheck": "healthcheck"}',1484324150629);



