
    drop table if exists INFRA_ACTIVE_REQUESTS;

    drop table if exists SITE_STATUS;

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
        AIC_CLOUD_REGION varchar(11),
        CALLBACK_URL varchar(200),
        CORRELATOR varchar(80),
        SERVICE_INSTANCE_ID varchar(45),
        SERVICE_INSTANCE_NAME varchar(80),
        REQUEST_SCOPE varchar(20),
        REQUEST_ACTION varchar(45) not null,
        NETWORK_ID varchar(45),
        NETWORK_NAME varchar(80),
        NETWORK_TYPE varchar(80),
        REQUESTOR_ID varchar(80),
        primary key (REQUEST_ID)
    );

    create table SITE_STATUS (
        SITE_NAME varchar(255) not null,
        STATUS bit,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (SITE_NAME)
    );
	create table OPERATION_STATUS (
        SERVICE_ID varchar(255) not null,
        OPERATION_ID varchar(255) not null,
		SERVICE_NAME varchar(255),
		OPERATION_TYPE varchar(255),
		USER_ID varchar(255),
		RESULT varchar(255),
		OPERATION_CONTENT varchar(255),
		PROGRESS varchar(255),
		REASON varchar(255),
        OPERATE_AT datetime,
		FINISHED_AT datetime,
        primary key (SERVICE_ID,OPERATION_ID)
    );
	create table RESOURCE_OPERATION_STATUS (
        SERVICE_ID varchar(255) not null,
        OPERATION_ID varchar(255) not null,
        RESOURCE_TEMPLATE_UUID varchar(255) not null,
		OPER_TYPE varchar(255),
		RESOURCE_INSTANCE_ID varchar(255),
		JOB_ID varchar(255),
		STATUS varchar(255),
		PROGRESS varchar(255),
		ERROR_CODE varchar(255) ,
		STATUS_DESCRIPOTION varchar(255) ,
        primary key (SERVICE_ID,OPERATION_ID,RESOURCE_TEMPLATE_UUID)
    );
    alter table INFRA_ACTIVE_REQUESTS 
        add constraint UK_bhu6w8p7wvur4pin0gjw2d5ak  unique (CLIENT_REQUEST_ID);
