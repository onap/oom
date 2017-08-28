# MSO updates to the default camunda schema.
USE `camundabpmn`;

ALTER TABLE ACT_RU_METER_LOG
  ADD REPORTER_ varchar(255);
  
-- job prioritization --
  
ALTER TABLE ACT_RU_JOB
  ADD PRIORITY_ bigint NOT NULL
  DEFAULT 0;
  
ALTER TABLE ACT_RU_JOBDEF
  ADD JOB_PRIORITY_ bigint;
  
ALTER TABLE ACT_HI_JOB_LOG
  ADD JOB_PRIORITY_ bigint NOT NULL
  DEFAULT 0;

-- create decision definition table --
create table ACT_RE_DECISION_DEF (
    ID_ varchar(64) not null,
    REV_ integer,
    CATEGORY_ varchar(255),
    NAME_ varchar(255),
    KEY_ varchar(255) not null,
    VERSION_ integer not null,
    DEPLOYMENT_ID_ varchar(64),
    RESOURCE_NAME_ varchar(4000),
    DGRM_RESOURCE_NAME_ varchar(4000),
    primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- create unique constraint on ACT_RE_DECISION_DEF --
alter table ACT_RE_DECISION_DEF
    add constraint ACT_UNIQ_DECISION_DEF
    unique (KEY_,VERSION_);

-- case sentry part source --

ALTER TABLE ACT_RU_CASE_SENTRY_PART
  ADD SOURCE_ varchar(255);
  
-- create history decision instance table --
create table ACT_HI_DECINST (
    ID_ varchar(64) NOT NULL,
    DEC_DEF_ID_ varchar(64) NOT NULL,
    DEC_DEF_KEY_ varchar(255) NOT NULL,
    DEC_DEF_NAME_ varchar(255),
    PROC_DEF_KEY_ varchar(255),
    PROC_DEF_ID_ varchar(64),
    PROC_INST_ID_ varchar(64),
    CASE_DEF_KEY_ varchar(255),
    CASE_DEF_ID_ varchar(64),
    CASE_INST_ID_ varchar(64),
    ACT_INST_ID_ varchar(64),
    ACT_ID_ varchar(255),
    EVAL_TIME_ datetime not null,
    COLLECT_VALUE_ double,
    primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- create history decision input table --
create table ACT_HI_DEC_IN (
    ID_ varchar(64) NOT NULL,
    DEC_INST_ID_ varchar(64) NOT NULL,      
    CLAUSE_ID_ varchar(64) NOT NULL,
    CLAUSE_NAME_ varchar(255),
    VAR_TYPE_ varchar(100),               
    BYTEARRAY_ID_ varchar(64),
    DOUBLE_ double,
    LONG_ bigint,
    TEXT_ LONGBLOB NULL,
    TEXT2_ LONGBLOB NULL,    
    primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- create history decision output table --
create table ACT_HI_DEC_OUT (
    ID_ varchar(64) NOT NULL,
    DEC_INST_ID_ varchar(64) NOT NULL,         
    CLAUSE_ID_ varchar(64) NOT NULL,
    CLAUSE_NAME_ varchar(255),
    RULE_ID_ varchar(64) NOT NULL,
    RULE_ORDER_ integer,
    VAR_NAME_ varchar(255),
    VAR_TYPE_ varchar(100),               
    BYTEARRAY_ID_ varchar(64),
    DOUBLE_ double,
    LONG_ bigint,
    TEXT_ LONGBLOB NULL,
    TEXT2_ LONGBLOB NULL,
    primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- create indexes for historic decision tables
create index ACT_IDX_HI_DEC_INST_ID on ACT_HI_DECINST(DEC_DEF_ID_);
create index ACT_IDX_HI_DEC_INST_KEY on ACT_HI_DECINST(DEC_DEF_KEY_);
create index ACT_IDX_HI_DEC_INST_PI on ACT_HI_DECINST(PROC_INST_ID_);
create index ACT_IDX_HI_DEC_INST_CI on ACT_HI_DECINST(CASE_INST_ID_);
create index ACT_IDX_HI_DEC_INST_ACT on ACT_HI_DECINST(ACT_ID_);
create index ACT_IDX_HI_DEC_INST_ACT_INST on ACT_HI_DECINST(ACT_INST_ID_);
create index ACT_IDX_HI_DEC_INST_TIME on ACT_HI_DECINST(EVAL_TIME_);

create index ACT_IDX_HI_DEC_IN_INST on ACT_HI_DEC_IN(DEC_INST_ID_);
create index ACT_IDX_HI_DEC_IN_CLAUSE on ACT_HI_DEC_IN(DEC_INST_ID_, CLAUSE_ID_);

create index ACT_IDX_HI_DEC_OUT_INST on ACT_HI_DEC_OUT(DEC_INST_ID_);
create index ACT_IDX_HI_DEC_OUT_RULE on ACT_HI_DEC_OUT(RULE_ORDER_, CLAUSE_ID_);

-- add grant authorization for group camunda-admin:
INSERT INTO
  ACT_RU_AUTHORIZATION (ID_, TYPE_, GROUP_ID_, RESOURCE_TYPE_, RESOURCE_ID_, PERMS_, REV_)
VALUES
  ('camunda-admin-grant-decision-definition', 1, 'camunda-admin', 10, '*', 2147483647, 1);
  
-- external tasks --

create table ACT_RU_EXT_TASK (
  ID_ varchar(64) not null,
  REV_ integer not null,
  WORKER_ID_ varchar(255),
  TOPIC_NAME_ varchar(255),
  RETRIES_ integer,
  ERROR_MSG_ varchar(4000),
  LOCK_EXP_TIME_ timestamp NULL,
  SUSPENSION_STATE_ integer,
  EXECUTION_ID_ varchar(64),
  PROC_INST_ID_ varchar(64),
  PROC_DEF_ID_ varchar(64),
  PROC_DEF_KEY_ varchar(255),
  ACT_ID_ varchar(255),
  ACT_INST_ID_ varchar(64),
  primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

alter table ACT_RU_EXT_TASK
    add constraint ACT_FK_EXT_TASK_EXE 
    foreign key (EXECUTION_ID_) 
    references ACT_RU_EXECUTION (ID_);

create index ACT_IDX_EXT_TASK_TOPIC on ACT_RU_EXT_TASK(TOPIC_NAME_);

-- deployment --

ALTER TABLE ACT_RE_DEPLOYMENT 
  ADD SOURCE_ varchar(255);

ALTER TABLE ACT_HI_OP_LOG
  ADD DEPLOYMENT_ID_ varchar(64);
  
-- job suspension state

ALTER TABLE ACT_RU_JOB
  MODIFY COLUMN SUSPENSION_STATE_ integer
  DEFAULT 1;

  -- relevant for jobs created in Camunda 7.0
UPDATE ACT_RU_JOB
  SET SUSPENSION_STATE_ = 1
  WHERE SUSPENSION_STATE_ IS NULL;
  
ALTER TABLE ACT_RU_JOB
  MODIFY COLUMN SUSPENSION_STATE_ integer
  NOT NULL DEFAULT 1;

  
-- mariadb_engine_7.4_patch_7.4.5_to_7.4.6
-- INCREASE process def key column size https://app.camunda.com/jira/browse/CAM-4328 --
alter table ACT_RU_JOB
  MODIFY COLUMN PROCESS_DEF_KEY_ varchar(255);
  
-- mariadb_engine_7.4_to_7.5
-- set datetime precision --

ALTER TABLE ACT_HI_CASEINST
  MODIFY COLUMN CREATE_TIME_ datetime(3) not null;

ALTER TABLE ACT_HI_CASEINST
  MODIFY COLUMN CLOSE_TIME_ datetime(3);

ALTER TABLE ACT_HI_CASEACTINST
  MODIFY COLUMN CREATE_TIME_ datetime(3) not null;

ALTER TABLE ACT_HI_CASEACTINST
  MODIFY COLUMN END_TIME_ datetime(3);

ALTER TABLE ACT_HI_DECINST
  MODIFY COLUMN EVAL_TIME_ datetime(3) not null;

ALTER TABLE ACT_RU_TASK
  MODIFY COLUMN DUE_DATE_ datetime(3);

ALTER TABLE ACT_RU_TASK
  MODIFY COLUMN FOLLOW_UP_DATE_ datetime(3);

ALTER TABLE ACT_HI_PROCINST
  MODIFY COLUMN START_TIME_ datetime(3) not null;

ALTER TABLE ACT_HI_PROCINST
  MODIFY COLUMN END_TIME_ datetime(3);

ALTER TABLE ACT_HI_ACTINST
  MODIFY COLUMN START_TIME_ datetime(3) not null;

ALTER TABLE ACT_HI_ACTINST
  MODIFY COLUMN END_TIME_ datetime(3);

ALTER TABLE ACT_HI_TASKINST
  MODIFY COLUMN START_TIME_ datetime(3) not null;

ALTER TABLE ACT_HI_TASKINST
  MODIFY COLUMN END_TIME_ datetime(3);

ALTER TABLE ACT_HI_TASKINST
  MODIFY COLUMN DUE_DATE_ datetime(3);

ALTER TABLE ACT_HI_TASKINST
  MODIFY COLUMN FOLLOW_UP_DATE_ datetime(3);

ALTER TABLE ACT_HI_DETAIL
  MODIFY COLUMN TIME_ datetime(3) not null;

ALTER TABLE ACT_HI_COMMENT
  MODIFY COLUMN TIME_ datetime(3) not null;

-- set timestamp precision --

ALTER TABLE ACT_RE_DEPLOYMENT
  MODIFY COLUMN DEPLOY_TIME_ timestamp(3);

ALTER TABLE ACT_RU_JOB
  MODIFY COLUMN LOCK_EXP_TIME_ timestamp(3) NULL;

ALTER TABLE ACT_RU_JOB
  MODIFY COLUMN DUEDATE_ timestamp(3) NULL;

ALTER TABLE ACT_RU_TASK
  MODIFY COLUMN CREATE_TIME_ timestamp(3);

ALTER TABLE ACT_RU_EVENT_SUBSCR
  MODIFY COLUMN CREATED_ timestamp(3) NOT NULL;

ALTER TABLE ACT_RU_INCIDENT
  MODIFY COLUMN INCIDENT_TIMESTAMP_ timestamp(3) NOT NULL;

ALTER TABLE ACT_RU_METER_LOG
  MODIFY COLUMN TIMESTAMP_ timestamp(3) NOT NULL;

ALTER TABLE ACT_RU_EXT_TASK
  MODIFY COLUMN LOCK_EXP_TIME_ timestamp(3) NULL;

ALTER TABLE ACT_HI_OP_LOG
  MODIFY COLUMN TIMESTAMP_ timestamp(3) NOT NULL;

ALTER TABLE ACT_HI_INCIDENT
  MODIFY COLUMN CREATE_TIME_ timestamp(3) NOT NULL;

ALTER TABLE ACT_HI_INCIDENT
  MODIFY COLUMN END_TIME_ timestamp(3) NULL;

ALTER TABLE ACT_HI_JOB_LOG
  MODIFY COLUMN TIMESTAMP_ timestamp(3) NOT NULL;

ALTER TABLE ACT_HI_JOB_LOG
  MODIFY COLUMN JOB_DUEDATE_ timestamp(3) NULL;

-- semantic version --

ALTER TABLE ACT_RE_PROCDEF
  ADD VERSION_TAG_ varchar(64);

create index ACT_IDX_PROCDEF_VER_TAG on ACT_RE_PROCDEF(VERSION_TAG_);

-- tenant id --

ALTER TABLE ACT_RE_DEPLOYMENT
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_DEPLOYMENT_TENANT_ID on ACT_RE_DEPLOYMENT(TENANT_ID_);

ALTER TABLE ACT_RE_PROCDEF
  ADD TENANT_ID_ varchar(64);

ALTER TABLE ACT_RE_PROCDEF
   DROP INDEX ACT_UNIQ_PROCDEF;

create index ACT_IDX_PROCDEF_TENANT_ID ON ACT_RE_PROCDEF(TENANT_ID_);

ALTER TABLE ACT_RU_EXECUTION
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_EXEC_TENANT_ID on ACT_RU_EXECUTION(TENANT_ID_);

ALTER TABLE ACT_RU_TASK
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_TASK_TENANT_ID on ACT_RU_TASK(TENANT_ID_);

ALTER TABLE ACT_RU_VARIABLE
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_VARIABLE_TENANT_ID on ACT_RU_VARIABLE(TENANT_ID_);

ALTER TABLE ACT_RU_EVENT_SUBSCR
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_EVENT_SUBSCR_TENANT_ID on ACT_RU_EVENT_SUBSCR(TENANT_ID_);

ALTER TABLE ACT_RU_JOB
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_JOB_TENANT_ID on ACT_RU_JOB(TENANT_ID_);

ALTER TABLE ACT_RU_JOBDEF
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_JOBDEF_TENANT_ID on ACT_RU_JOBDEF(TENANT_ID_);

ALTER TABLE ACT_RU_INCIDENT
  ADD TENANT_ID_ varchar(64);
  
ALTER TABLE ACT_RU_IDENTITYLINK
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_INC_TENANT_ID on ACT_RU_INCIDENT(TENANT_ID_);

ALTER TABLE ACT_RU_EXT_TASK
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_EXT_TASK_TENANT_ID on ACT_RU_EXT_TASK(TENANT_ID_);

ALTER TABLE ACT_RE_DECISION_DEF
       DROP INDEX ACT_UNIQ_DECISION_DEF;

ALTER TABLE ACT_RE_DECISION_DEF
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_DEC_DEF_TENANT_ID on ACT_RE_DECISION_DEF(TENANT_ID_);

ALTER TABLE ACT_RE_CASE_DEF
       DROP INDEX ACT_UNIQ_CASE_DEF;

ALTER TABLE ACT_RE_CASE_DEF
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_CASE_DEF_TENANT_ID on ACT_RE_CASE_DEF(TENANT_ID_);

ALTER TABLE ACT_GE_BYTEARRAY
  ADD TENANT_ID_ varchar(64);

ALTER TABLE ACT_RU_CASE_EXECUTION
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_CASE_EXEC_TENANT_ID on ACT_RU_CASE_EXECUTION(TENANT_ID_);

ALTER TABLE ACT_RU_CASE_SENTRY_PART
  ADD TENANT_ID_ varchar(64);

-- user on historic decision instance --

ALTER TABLE ACT_HI_DECINST
  ADD USER_ID_ varchar(255);

-- tenant id on history --

ALTER TABLE ACT_HI_PROCINST
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_HI_PRO_INST_TENANT_ID on ACT_HI_PROCINST(TENANT_ID_);

ALTER TABLE ACT_HI_ACTINST
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_HI_ACT_INST_TENANT_ID on ACT_HI_ACTINST(TENANT_ID_);

ALTER TABLE ACT_HI_TASKINST
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_HI_TASK_INST_TENANT_ID on ACT_HI_TASKINST(TENANT_ID_);

ALTER TABLE ACT_HI_VARINST
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_HI_VAR_INST_TENANT_ID on ACT_HI_VARINST(TENANT_ID_);

ALTER TABLE ACT_HI_DETAIL
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_HI_DETAIL_TENANT_ID on ACT_HI_DETAIL(TENANT_ID_);

ALTER TABLE ACT_HI_INCIDENT
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_HI_INCIDENT_TENANT_ID on ACT_HI_INCIDENT(TENANT_ID_);

ALTER TABLE ACT_HI_JOB_LOG
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_HI_JOB_LOG_TENANT_ID on ACT_HI_JOB_LOG(TENANT_ID_);

ALTER TABLE ACT_HI_COMMENT
  ADD TENANT_ID_ varchar(64);

ALTER TABLE ACT_HI_ATTACHMENT
  ADD TENANT_ID_ varchar(64);

ALTER TABLE ACT_HI_OP_LOG
  ADD TENANT_ID_ varchar(64);

ALTER TABLE ACT_HI_DEC_IN
  ADD TENANT_ID_ varchar(64);

ALTER TABLE ACT_HI_DEC_OUT
  ADD TENANT_ID_ varchar(64);

ALTER TABLE ACT_HI_DECINST
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_HI_DEC_INST_TENANT_ID on ACT_HI_DECINST(TENANT_ID_);

ALTER TABLE ACT_HI_CASEINST
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_HI_CAS_I_TENANT_ID on ACT_HI_CASEINST(TENANT_ID_);

ALTER TABLE ACT_HI_CASEACTINST
  ADD TENANT_ID_ varchar(64);

create index ACT_IDX_HI_CAS_A_I_TENANT_ID on ACT_HI_CASEACTINST(TENANT_ID_);

-- AUTHORIZATION --

-- add grant authorizations for group camunda-admin:
INSERT INTO
  ACT_RU_AUTHORIZATION (ID_, TYPE_, GROUP_ID_, RESOURCE_TYPE_, RESOURCE_ID_, PERMS_, REV_)
VALUES
  ('camunda-admin-grant-tenant', 1, 'camunda-admin', 11, '*', 2147483647, 1),
  ('camunda-admin-grant-tenant-membership', 1, 'camunda-admin', 12, '*', 2147483647, 1),
  ('camunda-admin-grant-batch', 1, 'camunda-admin', 13, '*', 2147483647, 1);

-- tenant table

create table ACT_ID_TENANT (
    ID_ varchar(64),
    REV_ integer,
    NAME_ varchar(255),
    primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_ID_TENANT_MEMBER (
    ID_ varchar(64) not null,
    TENANT_ID_ varchar(64) not null,
    USER_ID_ varchar(64),
    GROUP_ID_ varchar(64),
    primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

alter table ACT_ID_TENANT_MEMBER
    add constraint ACT_UNIQ_TENANT_MEMB_USER
    unique (TENANT_ID_, USER_ID_);

alter table ACT_ID_TENANT_MEMBER
    add constraint ACT_UNIQ_TENANT_MEMB_GROUP
    unique (TENANT_ID_, GROUP_ID_);    
    
alter table ACT_ID_TENANT_MEMBER
    add constraint ACT_FK_TENANT_MEMB
    foreign key (TENANT_ID_)
    references ACT_ID_TENANT (ID_);  
    
alter table ACT_ID_TENANT_MEMBER
    add constraint ACT_FK_TENANT_MEMB_USER
    foreign key (USER_ID_)
    references ACT_ID_USER (ID_);    
    
alter table ACT_ID_TENANT_MEMBER
    add constraint ACT_FK_TENANT_MEMB_GROUP
    foreign key (GROUP_ID_)
    references ACT_ID_GROUP (ID_);

-- BATCH --

-- remove not null from job definition table --
alter table ACT_RU_JOBDEF
	modify PROC_DEF_ID_ varchar(64),
	modify PROC_DEF_KEY_ varchar(255),
	modify ACT_ID_ varchar(255);

create table ACT_RU_BATCH (
  ID_ varchar(64) not null,
  REV_ integer not null,
  TYPE_ varchar(255),
  TOTAL_JOBS_ integer,
  JOBS_CREATED_ integer,
  JOBS_PER_SEED_ integer,
  INVOCATIONS_PER_JOB_ integer,
  SEED_JOB_DEF_ID_ varchar(64),
  BATCH_JOB_DEF_ID_ varchar(64),
  MONITOR_JOB_DEF_ID_ varchar(64),
  SUSPENSION_STATE_ integer,
  CONFIGURATION_ varchar(255),
  TENANT_ID_ varchar(64),
  primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_BATCH (
    ID_ varchar(64) not null,
    TYPE_ varchar(255),
    TOTAL_JOBS_ integer,
    JOBS_PER_SEED_ integer,
    INVOCATIONS_PER_JOB_ integer,
    SEED_JOB_DEF_ID_ varchar(64),
    MONITOR_JOB_DEF_ID_ varchar(64),
    BATCH_JOB_DEF_ID_ varchar(64),
    TENANT_ID_  varchar(64),
    START_TIME_ datetime(3) not null,
    END_TIME_ datetime(3),
    primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create table ACT_HI_IDENTITYLINK (
    ID_ varchar(64) not null,
    TIMESTAMP_ timestamp(3) not null,
    TYPE_ varchar(255),
    USER_ID_ varchar(255),
    GROUP_ID_ varchar(255),
    TASK_ID_ varchar(64),
    PROC_DEF_ID_ varchar(64),
    OPERATION_TYPE_ varchar(64),
    ASSIGNER_ID_ varchar(64),
    PROC_DEF_KEY_ varchar(255),
    TENANT_ID_ varchar(64),
    primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

create index ACT_IDX_HI_IDENT_LNK_USER on ACT_HI_IDENTITYLINK(USER_ID_);
create index ACT_IDX_HI_IDENT_LNK_GROUP on ACT_HI_IDENTITYLINK(GROUP_ID_);
create index ACT_IDX_HI_IDENT_LNK_TENANT_ID on ACT_HI_IDENTITYLINK(TENANT_ID_);

create index ACT_IDX_JOB_JOB_DEF_ID on ACT_RU_JOB(JOB_DEF_ID_);
create index ACT_IDX_HI_JOB_LOG_JOB_DEF_ID on ACT_HI_JOB_LOG(JOB_DEF_ID_);

create index ACT_IDX_BATCH_SEED_JOB_DEF ON ACT_RU_BATCH(SEED_JOB_DEF_ID_);
alter table ACT_RU_BATCH
    add constraint ACT_FK_BATCH_SEED_JOB_DEF
    foreign key (SEED_JOB_DEF_ID_)
    references ACT_RU_JOBDEF (ID_);

create index ACT_IDX_BATCH_MONITOR_JOB_DEF ON ACT_RU_BATCH(MONITOR_JOB_DEF_ID_);
alter table ACT_RU_BATCH
    add constraint ACT_FK_BATCH_MONITOR_JOB_DEF
    foreign key (MONITOR_JOB_DEF_ID_)
    references ACT_RU_JOBDEF (ID_);

create index ACT_IDX_BATCH_JOB_DEF ON ACT_RU_BATCH(BATCH_JOB_DEF_ID_);
alter table ACT_RU_BATCH
    add constraint ACT_FK_BATCH_JOB_DEF
    foreign key (BATCH_JOB_DEF_ID_)
    references ACT_RU_JOBDEF (ID_);

-- TASK PRIORITY --

ALTER TABLE ACT_RU_EXT_TASK
  ADD PRIORITY_ bigint NOT NULL DEFAULT 0;

create index ACT_IDX_EXT_TASK_PRIORITY ON ACT_RU_EXT_TASK(PRIORITY_);

-- HI OP PROC INDECIES --

create index ACT_IDX_HI_OP_LOG_PROCINST on ACT_HI_OP_LOG(PROC_INST_ID_);
create index ACT_IDX_HI_OP_LOG_PROCDEF on ACT_HI_OP_LOG(PROC_DEF_ID_);

-- JOB_DEF_ID_ on INCIDENTS --
ALTER TABLE ACT_RU_INCIDENT
  ADD JOB_DEF_ID_ varchar(64);

create index ACT_IDX_INC_JOB_DEF on ACT_RU_INCIDENT(JOB_DEF_ID_);
alter table ACT_RU_INCIDENT
    add constraint ACT_FK_INC_JOB_DEF
    foreign key (JOB_DEF_ID_)
    references ACT_RU_JOBDEF (ID_);

ALTER TABLE ACT_HI_INCIDENT
  ADD JOB_DEF_ID_ varchar(64);

-- BATCH_ID_ on ACT_HI_OP_LOG --
ALTER TABLE ACT_HI_OP_LOG
  ADD BATCH_ID_ varchar(64);
  
 -- add indexes on PROC_DEF_KEY_ columns in history tables CAM-6679
create index ACT_IDX_HI_ACT_INST_PROC_DEF_KEY on ACT_HI_ACTINST(PROC_DEF_KEY_);
create index ACT_IDX_HI_DETAIL_PROC_DEF_KEY on ACT_HI_DETAIL(PROC_DEF_KEY_);
create index ACT_IDX_HI_IDENT_LNK_PROC_DEF_KEY on ACT_HI_IDENTITYLINK(PROC_DEF_KEY_);
create index ACT_IDX_HI_INCIDENT_PROC_DEF_KEY on ACT_HI_INCIDENT(PROC_DEF_KEY_);
create index ACT_IDX_HI_JOB_LOG_PROC_DEF_KEY on ACT_HI_JOB_LOG(PROCESS_DEF_KEY_);
create index ACT_IDX_HI_PRO_INST_PROC_DEF_KEY on ACT_HI_PROCINST(PROC_DEF_KEY_);
create index ACT_IDX_HI_TASK_INST_PROC_DEF_KEY on ACT_HI_TASKINST(PROC_DEF_KEY_);
create index ACT_IDX_HI_VAR_INST_PROC_DEF_KEY on ACT_HI_VARINST(PROC_DEF_KEY_);

-- 7.5.8 to 7.6.2 upgrade
-- AUTHORIZATION --

-- add grant authorizations for group camunda-admin:
INSERT INTO
  ACT_RU_AUTHORIZATION (ID_, TYPE_, GROUP_ID_, RESOURCE_TYPE_, RESOURCE_ID_, PERMS_, REV_)
VALUES
  ('camunda-admin-grant-drd', 1, 'camunda-admin', 14, '*', 2147483647, 1);

-- decision requirements definition --

ALTER TABLE ACT_RE_DECISION_DEF
  ADD DEC_REQ_ID_ varchar(64);

ALTER TABLE ACT_RE_DECISION_DEF
  ADD DEC_REQ_KEY_ varchar(255);

ALTER TABLE ACT_RU_CASE_SENTRY_PART
  ADD VARIABLE_EVENT_ varchar(255);

ALTER TABLE ACT_RU_CASE_SENTRY_PART
  ADD VARIABLE_NAME_ varchar(255);

create table ACT_RE_DECISION_REQ_DEF (
    ID_ varchar(64) NOT NULL,
    REV_ integer,
    CATEGORY_ varchar(255),
    NAME_ varchar(255),
    KEY_ varchar(255) NOT NULL,
    VERSION_ integer NOT NULL,
    DEPLOYMENT_ID_ varchar(64),
    RESOURCE_NAME_ varchar(4000),
    DGRM_RESOURCE_NAME_ varchar(4000),
    TENANT_ID_ varchar(64),
    primary key (ID_)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;;

alter table ACT_RE_DECISION_DEF
    add constraint ACT_FK_DEC_REQ
    foreign key (DEC_REQ_ID_)
    references ACT_RE_DECISION_REQ_DEF(ID_);

create index ACT_IDX_DEC_DEF_REQ_ID on ACT_RE_DECISION_DEF(DEC_REQ_ID_);
create index ACT_IDX_DEC_REQ_DEF_TENANT_ID on ACT_RE_DECISION_REQ_DEF(TENANT_ID_);

ALTER TABLE ACT_HI_DECINST
  ADD ROOT_DEC_INST_ID_ varchar(64);

ALTER TABLE ACT_HI_DECINST
  ADD DEC_REQ_ID_ varchar(64);

ALTER TABLE ACT_HI_DECINST
  ADD DEC_REQ_KEY_ varchar(255);

create index ACT_IDX_HI_DEC_INST_ROOT_ID on ACT_HI_DECINST(ROOT_DEC_INST_ID_);
create index ACT_IDX_HI_DEC_INST_REQ_ID on ACT_HI_DECINST(DEC_REQ_ID_);
create index ACT_IDX_HI_DEC_INST_REQ_KEY on ACT_HI_DECINST(DEC_REQ_KEY_);

-- remove not null from ACT_HI_DEC tables --
alter table ACT_HI_DEC_OUT
  modify CLAUSE_ID_ varchar(64),
  modify RULE_ID_ varchar(64);

alter table ACT_HI_DEC_IN
  modify CLAUSE_ID_ varchar(64);

-- CAM-5914
create index ACT_IDX_JOB_EXECUTION_ID on ACT_RU_JOB(EXECUTION_ID_);

ALTER TABLE ACT_RU_EXT_TASK
  ADD ERROR_DETAILS_ID_ varchar(64);

alter table ACT_RU_EXT_TASK
  add constraint ACT_FK_EXT_TASK_ERROR_DETAILS
  foreign key (ERROR_DETAILS_ID_)
  references ACT_GE_BYTEARRAY (ID_);

ALTER TABLE ACT_HI_PROCINST
  ADD STATE_ varchar(255);

update ACT_HI_PROCINST set STATE_ = 'ACTIVE' where END_TIME_ is null;
update ACT_HI_PROCINST set STATE_ = 'COMPLETED' where END_TIME_ is not null;

-- CAM-6725
ALTER TABLE ACT_RU_METER_LOG
 ADD MILLISECONDS_ bigint DEFAULT 0;

alter table ACT_RU_METER_LOG
  modify TIMESTAMP_ TIMESTAMP(3);

CREATE INDEX ACT_IDX_METER_LOG_MS ON ACT_RU_METER_LOG(MILLISECONDS_);
CREATE INDEX ACT_IDX_METER_LOG_REPORT ON ACT_RU_METER_LOG(NAME_, REPORTER_, MILLISECONDS_);
CREATE INDEX ACT_IDX_METER_LOG_NAME_MS ON ACT_RU_METER_LOG(NAME_, MILLISECONDS_);

-- old metric timestamp column
CREATE INDEX ACT_IDX_METER_LOG_TIME ON ACT_RU_METER_LOG(TIMESTAMP_);

-- CAM-6938
create index ACT_IDX_JOB_HANDLER on ACT_RU_JOB(HANDLER_TYPE_(100),HANDLER_CFG_(155));