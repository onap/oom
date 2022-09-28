--
-- Copyright (C) 2022 CMCC, Inc. and others. All rights reserved.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

-- ----------------------------
-- Table structure for "alarms_additionalinformation"
-- ----------------------------
DROP TABLE IF EXISTS alarms_additionalinformation;
CREATE TABLE alarms_additionalinformation(
  id serial,
  "header_id" varchar(50) NOT NULL,
  "name" varchar(100) DEFAULT NULL,
  "value" varchar(100) DEFAULT NULL,
  "source_id" varchar(100) DEFAULT NULL,
  "start_epoch_microsec" varchar(100) DEFAULT NULL,
  "last_epoch_microsec" varchar(100) DEFAULT NULL,
  CONSTRAINT alarms_additionalinformation_pk PRIMARY KEY (id)
) WITH ( OIDS = FALSE);

-- ----------------------------
-- Table structure for "alarms_commoneventheader"
-- ----------------------------
DROP TABLE IF EXISTS alarms_commoneventheader;
CREATE TABLE alarms_commoneventheader (
  "id" varchar(50) NOT NULL,
  "version" varchar(100) DEFAULT NULL,
  "event_name" varchar(100) DEFAULT NULL,
  "domain" varchar(100) DEFAULT NULL,
  "event_id" varchar(100) DEFAULT NULL,
  "event_type" varchar(100) DEFAULT NULL,
  "nfc_naming_code" varchar(100) DEFAULT NULL,
  "nf_naming_code" varchar(100) DEFAULT NULL,
  "source_id" varchar(100) DEFAULT NULL,
  "source_name" varchar(100) DEFAULT NULL,
  "reporting_entity_id" varchar(100) DEFAULT NULL,
  "reporting_entity_name" varchar(100) DEFAULT NULL,
  "priority" varchar(50) DEFAULT NULL,
  "start_epoch_microsec" varchar(100) DEFAULT NULL,
  "last_epoch_microsec" varchar(100) DEFAULT NULL,
  "start_epoch_microsec_cleared" varchar(100) DEFAULT NULL,
  "last_epoch_microsec_cleared" varchar(100) DEFAULT NULL,
  "sequence" varchar(100) DEFAULT NULL,
  "fault_fields_version" varchar(100) DEFAULT NULL,
  "event_servrity" varchar(100) DEFAULT NULL,
  "event_source_type" varchar(100) DEFAULT NULL,
  "event_category" varchar(100) DEFAULT NULL,
  "alarm_condition" varchar(100) DEFAULT NULL,
  "specific_problem" varchar(100) DEFAULT NULL,
  "vf_status" varchar(100) DEFAULT NULL,
  "alarm_interfacea" varchar(100) DEFAULT NULL,
  "status" varchar(50) DEFAULT NULL,
  CONSTRAINT alarms_commoneventheader_pk PRIMARY KEY (id)
) WITH ( OIDS = FALSE );

-- ----------------------------
-- Table structure for "performance_additionalinformation"
-- ----------------------------
DROP TABLE IF EXISTS performance_additionalinformation;
CREATE TABLE performance_additionalinformation (
  id serial,
  "header_id" varchar(50) NOT NULL,
  "name" varchar(100) DEFAULT NULL,
  "value" varchar(100) DEFAULT NULL,
  "source_id" varchar(100) DEFAULT NULL,
  "start_epoch_microsec" varchar(100) DEFAULT NULL,
  "last_epoch_microsec" varchar(100) DEFAULT NULL,
  CONSTRAINT performance_additionalinformation_pk PRIMARY KEY (id)
) WITH ( OIDS = FALSE );

-- ----------------------------
-- Table structure for "performance_commoneventheader"
-- ----------------------------
DROP TABLE IF EXISTS performance_commoneventheader;
CREATE TABLE performance_commoneventheader (
  "id" varchar(50) NOT NULL,
  "version" varchar(100) DEFAULT NULL,
  "event_name" varchar(100) DEFAULT NULL,
  "domain" varchar(100) DEFAULT NULL,
  "event_id" varchar(100) DEFAULT NULL,
  "event_type" varchar(100) DEFAULT NULL,
  "nfc_naming_code" varchar(100) DEFAULT NULL,
  "nf_namingcode" varchar(100) DEFAULT NULL,
  "source_id" varchar(100) DEFAULT NULL,
  "source_name" varchar(100) DEFAULT NULL,
  "reporting_entity_id" varchar(100) DEFAULT NULL,
  "reporting_entity_name" varchar(100) DEFAULT NULL,
  "priority" varchar(50) DEFAULT NULL,
  "start_epoch_microsec" varchar(100) DEFAULT NULL,
  "last_epoch_microsec" varchar(100) DEFAULT NULL,
  "sequence" varchar(100) DEFAULT NULL,
  "measurements_for_vf_scaling_version" varchar(100) DEFAULT NULL,
  "measurement_interval" varchar(100) DEFAULT NULL,
  CONSTRAINT performance_commoneventheader_pk PRIMARY KEY (id)
) WITH (OIDS = FALSE);

-- ----------------------------
-- Table structure for service_instances
-- ----------------------------
DROP TABLE IF EXISTS service_instances;
CREATE TABLE service_instances  (
  "id" varchar(50) NOT NULL,
  "service_instance_id" varchar(100) NOT NULL,
  "customer_id" varchar(50) NOT NULL,
  "service_type" varchar(50) NOT NULL,
  "usecase_type" varchar(50) NOT NULL,
  "uuid" varchar(100),
  "invariant_uuid" varchar(100),
  CONSTRAINT service_instances_pk PRIMARY KEY (service_instance_id)
);

-- ----------------------------
-- Table structure for service_instance_operations
-- ----------------------------
DROP TABLE IF EXISTS service_instance_operations;
CREATE TABLE service_instance_operations  (
  "service_instance_id" varchar(100) NOT NULL,
  "operation_id" varchar(100) NOT NULL,
  "operation_type" varchar(50) NOT NULL,
  "operation_progress" varchar(50) NOT NULL,
  "operation_result" varchar(100) DEFAULT NULL,
  "start_time" varchar(100) NOT NULL,
  "end_time" varchar(100),
  CONSTRAINT service_instance_operations_pk PRIMARY KEY (service_instance_id, operation_id)
);

-- ----------------------------
-- Table structure for sort_master
-- ----------------------------
DROP TABLE IF EXISTS sort_master;
CREATE TABLE sort_master  (
  "sort_type" varchar(50) NOT NULL,
  "sort_code" varchar(10) NOT NULL,
  "sort_value" varchar(100) NOT NULL,
  "language" varchar(50) NOT NULL,
  CONSTRAINT sort_master_pk PRIMARY KEY (sort_type, sort_code, language)
);

-- ----------------------------
-- Table structure for sort_master
-- ----------------------------
DROP TABLE IF EXISTS instance_performance;
CREATE TABLE instance_performance
(
    id                   serial not null
        constraint instance_performance_pk
            primary key,
    job_id               varchar(36),
    resource_instance_id varchar(36),
    bandwidth            numeric,
    date                 timestamp,
    max_bandwidth        numeric
);

-- ----------------------------
-- Table structure for ccvpn_instance
-- ----------------------------
DROP TABLE IF EXISTS ccvpn_instance;
CREATE TABLE ccvpn_instance
(
    id                          serial not null
        constraint ccvpn_instance_pk
            primary key,
    instance_id                 varchar(16),
    job_id                      varchar(36),
    progress                    integer,
    status                      char default 0,
    resource_instance_id        varchar(36),
    name                        varchar(255),
    cloud_point_name            varchar(255),
    access_point_one_name       varchar(255),
    access_point_one_band_width integer,
    line_num                    varchar(64),
    delete_state                integer default 0,
    protect_status              integer default 0,
    protection_cloud_point_name       varchar(255),
    protection_type       varchar(255)
);

-- ----------------------------
-- Table structure for intent_model
-- ----------------------------
DROP TABLE IF EXISTS intent_model;
create table intent_model
(
    id          serial not null
        constraint intent_model_pk
            primary key,
    model_name  varchar(100) default NULL::character varying,
    file_path   varchar(500) default NULL::character varying,
    create_time varchar(100) default NULL::character varying,
    size        numeric(10, 3),
    active      integer,
    model_type integer      default 0
);

-- ----------------------------
-- Table structure for intent_instance
-- ----------------------------
DROP TABLE IF EXISTS intent_instance;
create table intent_instance
(
    id                   serial not null
        constraint intent_instance_pk
            primary key,
    intent_name          varchar(50),
    intent_source        integer,
    customer             varchar(50),
    intent_content       text,
    intent_config        text,
    business_instance_id varchar(50),
    business_instance    varchar(255)
);

-- ----------------------------
-- import initial data for sort_master
-- ----------------------------
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationType', '1001', 'Creating', 'en');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationType', '1002', 'Deleting', 'en');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationType', '1003', 'Scaling', 'en');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationType', '1004', 'Healing', 'en');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationType', '1005', 'Updating', 'en');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationType', '1001', '创建', 'cn');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationType', '1002', '删除', 'cn');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationType', '1003', '缩扩容', 'cn');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationType', '1004', '自愈', 'cn');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationType', '1005', '更新', 'cn');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationResult', '2001', 'Successful', 'en');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationResult', '2002', 'Failed', 'en');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationResult', '2003', 'In Progress', 'en');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationResult', '2001', '成功', 'cn');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationResult', '2002', '失败', 'cn');
INSERT INTO sort_master (sort_type, sort_code, sort_value, language) VALUES ('operationResult', '2003', '执行中', 'cn');

