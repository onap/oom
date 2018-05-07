
    drop table if exists ACTIVATE_OPERATIONAL_ENV_PER_DISTRIBUTIONID_STATUS;

    drop table if exists ACTIVATE_OPERATIONAL_ENV_SERVICE_MODEL_DISTRIBUTION_STATUS;

    drop table if exists INFRA_ACTIVE_REQUESTS;

    drop table if exists OPERATION_STATUS;

    drop table if exists RESOURCE_OPERATION_STATUS;

    drop table if exists SITE_STATUS;

    drop table if exists WATCHDOG_DISTRIBUTIONID_STATUS;

    drop table if exists WATCHDOG_PER_COMPONENT_DISTRIBUTION_STATUS;

    drop table if exists WATCHDOG_SERVICE_MOD_VER_ID_LOOKUP;

    create table ACTIVATE_OPERATIONAL_ENV_PER_DISTRIBUTIONID_STATUS (
        DISTRIBUTION_ID varchar(45) not null,
        OPERATIONAL_ENV_ID varchar(45),
        SERVICE_MODEL_VERSION_ID varchar(45),
        DISTRIBUTION_ID_STATUS varchar(45),
        DISTRIBUTION_ID_ERROR_REASON varchar(250),
        REQUEST_ID varchar(45),
        CREATE_TIME datetime,
        MODIFY_TIME datetime,
        primary key (DISTRIBUTION_ID)
    );

    create table ACTIVATE_OPERATIONAL_ENV_SERVICE_MODEL_DISTRIBUTION_STATUS (
        OPERATIONAL_ENV_ID varchar(45) not null,
        SERVICE_MODEL_VERSION_ID varchar(45) not null,
        REQUEST_ID varchar(45) not null,
        SERVICE_MOD_VER_FINAL_DISTR_STATUS varchar(45),
        RECOVERY_ACTION varchar(30),
        RETRY_COUNT_LEFT integer,
        WORKLOAD_CONTEXT varchar(80),
        CREATE_TIME datetime,
        MODIFY_TIME datetime,
        primary key (OPERATIONAL_ENV_ID, SERVICE_MODEL_VERSION_ID, REQUEST_ID)
    );

    create table INFRA_ACTIVE_REQUESTS (
        REQUEST_ID varchar(45) not null,
        CLIENT_REQUEST_ID varchar(45),
        ACTION varchar(45) not null,
        REQUEST_STATUS varchar(20),
        STATUS_MESSAGE varchar(2000),
        PROGRESS bigint,
        START_TIME datetime,
        END_TIME datetime,
        SOURCE varchar(45),
        VNF_ID varchar(45),
        VNF_NAME varchar(80),
        VNF_TYPE varchar(200),
        SERVICE_TYPE varchar(45),
        AIC_NODE_CLLI varchar(11),
        TENANT_ID varchar(45),
        PROV_STATUS varchar(20),
        VNF_PARAMS longtext,
        VNF_OUTPUTS longtext,
        REQUEST_BODY longtext,
        RESPONSE_BODY longtext,
        LAST_MODIFIED_BY varchar(50),
        MODIFY_TIME datetime,
        REQUEST_TYPE varchar(20),
        VOLUME_GROUP_ID varchar(45),
        VOLUME_GROUP_NAME varchar(45),
        VF_MODULE_ID varchar(45),
        VF_MODULE_NAME varchar(200),
        VF_MODULE_MODEL_NAME varchar(200),
        AAI_SERVICE_ID varchar(50),
        AIC_CLOUD_REGION varchar(200),
        CALLBACK_URL varchar(200),
        CORRELATOR varchar(80),
        SERVICE_INSTANCE_ID varchar(45),
        SERVICE_INSTANCE_NAME varchar(80),
        REQUEST_SCOPE varchar(45),
        REQUEST_ACTION varchar(45) not null,
        NETWORK_ID varchar(45),
        NETWORK_NAME varchar(80),
        NETWORK_TYPE varchar(80),
        REQUESTOR_ID varchar(80),
        CONFIGURATION_ID varchar(45),
        CONFIGURATION_NAME varchar(200),
        OPERATIONAL_ENV_ID varchar(45),
        OPERATIONAL_ENV_NAME varchar(200),
        primary key (REQUEST_ID)
    );

    create table OPERATION_STATUS (
        SERVICE_ID varchar(255) not null,
        OPERATION_ID varchar(256) not null,
        SERVICE_NAME varchar(256),
        OPERATION_TYPE varchar(256),
        USER_ID varchar(256),
        RESULT varchar(256),
        OPERATION_CONTENT varchar(256),
        PROGRESS varchar(256),
        REASON varchar(256),
        OPERATE_AT datetime default CURRENT_TIMESTAMP,
        FINISHED_AT datetime,
        primary key (SERVICE_ID, OPERATION_ID)
    );

    create table RESOURCE_OPERATION_STATUS (
        SERVICE_ID varchar(255) not null,
        OPERATION_ID varchar(256) not null,
        RESOURCE_TEMPLATE_UUID varchar(255) not null,
        OPER_TYPE varchar(256),
        RESOURCE_INSTANCE_ID varchar(256),
        JOB_ID varchar(256),
        STATUS varchar(256),
        PROGRESS varchar(256),
        ERROR_CODE varchar(256),
        STATUS_DESCRIPOTION varchar(256),
        primary key (SERVICE_ID, OPERATION_ID, RESOURCE_TEMPLATE_UUID)
    );

    create table SITE_STATUS (
        SITE_NAME varchar(255) not null,
        STATUS bit,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (SITE_NAME)
    );

    create table WATCHDOG_DISTRIBUTIONID_STATUS (
        DISTRIBUTION_ID varchar(45) not null,
        DISTRIBUTION_ID_STATUS varchar(45),
        CREATE_TIME datetime,
        MODIFY_TIME datetime,
        primary key (DISTRIBUTION_ID)
    );

    create table WATCHDOG_PER_COMPONENT_DISTRIBUTION_STATUS (
        DISTRIBUTION_ID varchar(45) not null,
        COMPONENT_NAME varchar(45) not null,
        COMPONENT_DISTRIBUTION_STATUS varchar(45),
        CREATE_TIME datetime,
        MODIFY_TIME datetime,
        primary key (DISTRIBUTION_ID, COMPONENT_NAME)
    );

    create table WATCHDOG_SERVICE_MOD_VER_ID_LOOKUP (
        DISTRIBUTION_ID varchar(45) not null,
        SERVICE_MODEL_VERSION_ID varchar(45) not null,
        CREATE_TIME datetime,
        primary key (DISTRIBUTION_ID, SERVICE_MODEL_VERSION_ID)
    );

    alter table INFRA_ACTIVE_REQUESTS 
        add constraint UK_bhu6w8p7wvur4pin0gjw2d5ak  unique (CLIENT_REQUEST_ID);
