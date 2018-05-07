
    alter table HEAT_TEMPLATE_PARAMS 
        drop 
        foreign key FK_p3ol1xcvp831glqohrlu6o07o;

    alter table MODEL_RECIPE 
        drop 
        foreign key FK_c23r0puyqug6n44jg39dutm1c;

    alter table SERVICE 
        drop 
        foreign key FK_l3qy594u2xr1tfpmma3uigsna;

    alter table SERVICE_RECIPE 
        drop 
        foreign key FK_i3r1b8j6e7dg9hkp49evnnm5y;

    alter table SERVICE_TO_RESOURCE_CUSTOMIZATIONS 
        drop 
        foreign key FK_kiddaay6cfe0aob1f1jaio1bb;

    alter table VF_MODULE 
        drop 
        foreign key FK_12jptc9it7gs3pru08skobxxc;

    alter table VNF_RESOURCE_CUSTOMIZATION 
        drop 
        foreign key FK_iff1ayhb1hrp5jhea3vvikuni;

    drop table if exists ALLOTTED_RESOURCE;

    drop table if exists ALLOTTED_RESOURCE_CUSTOMIZATION;

    drop table if exists HEAT_ENVIRONMENT;

    drop table if exists HEAT_FILES;

    drop table if exists HEAT_NESTED_TEMPLATE;

    drop table if exists HEAT_TEMPLATE;

    drop table if exists HEAT_TEMPLATE_PARAMS;

    drop table if exists MODEL;

    drop table if exists MODEL_RECIPE;

    drop table if exists NETWORK_RECIPE;

    drop table if exists NETWORK_RESOURCE;

    drop table if exists NETWORK_RESOURCE_CUSTOMIZATION;

    drop table if exists SERVICE;

    drop table if exists SERVICE_RECIPE;

    drop table if exists SERVICE_TO_ALLOTTED_RESOURCES;

    drop table if exists SERVICE_TO_NETWORKS;

    drop table if exists SERVICE_TO_RESOURCE_CUSTOMIZATIONS;

    drop table if exists TEMP_NETWORK_HEAT_TEMPLATE_LOOKUP;

    drop table if exists TOSCA_CSAR;

    drop table if exists VF_MODULE;

    drop table if exists VF_MODULE_CUSTOMIZATION;

    drop table if exists VF_MODULE_TO_HEAT_FILES;

    drop table if exists VNF_COMPONENTS;

    drop table if exists VNF_COMPONENTS_RECIPE;

    drop table if exists VNF_RECIPE;

    drop table if exists VNF_RESOURCE;

    drop table if exists VNF_RESOURCE_CUSTOMIZATION;

    drop table if exists VNF_RES_CUSTOM_TO_VF_MODULE_CUSTOM;

    create table ALLOTTED_RESOURCE (
        MODEL_UUID varchar(255) not null,
        MODEL_INVARIANT_UUID varchar(255),
        MODEL_VERSION varchar(255),
        MODEL_NAME varchar(255),
        TOSCA_NODE_TYPE varchar(255),
        SUBCATEGORY varchar(255),
        DESCRIPTION varchar(255),
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (MODEL_UUID)
    );

    create table ALLOTTED_RESOURCE_CUSTOMIZATION (
        MODEL_CUSTOMIZATION_UUID varchar(200) not null,
        MODEL_INSTANCE_NAME varchar(255),
        AR_MODEL_UUID varchar(255),
        PROVIDING_SERVICE_MODEL_INVARIANT_UUID varchar(255),
        TARGET_NETWORK_ROLE varchar(255),
        NF_FUNCTION varchar(255),
        NF_TYPE varchar(255),
        NF_ROLE varchar(255),
        NF_NAMING_CODE varchar(255),
        MIN_INSTANCES integer,
        MAX_INSTANCES integer,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        PROVIDING_SERVICE_MODEL_UUID varchar(255),
        PROVIDING_SERVICE_MODEL_NAME varchar(255),
        primary key (MODEL_CUSTOMIZATION_UUID)
    );

    create table HEAT_ENVIRONMENT (
        ARTIFACT_UUID varchar(200) not null,
        NAME varchar(100) not null,
        VERSION varchar(20) not null,
        DESCRIPTION varchar(1200),
        BODY longtext not null,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        ARTIFACT_CHECKSUM varchar(200) default 'MANUAL RECORD',
        primary key (ARTIFACT_UUID)
    );

    create table HEAT_FILES (
        ARTIFACT_UUID varchar(255) not null,
        DESCRIPTION varchar(255),
        NAME varchar(255),
        VERSION varchar(255),
        BODY longtext,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        ARTIFACT_CHECKSUM varchar(255),
        primary key (ARTIFACT_UUID)
    );

    create table HEAT_NESTED_TEMPLATE (
        PARENT_HEAT_TEMPLATE_UUID varchar(200) not null,
        CHILD_HEAT_TEMPLATE_UUID varchar(200) not null,
        PROVIDER_RESOURCE_FILE varchar(100),
        primary key (PARENT_HEAT_TEMPLATE_UUID, CHILD_HEAT_TEMPLATE_UUID)
    );

    create table HEAT_TEMPLATE (
        ARTIFACT_UUID varchar(200) not null,
        NAME varchar(200) not null,
        VERSION varchar(20) not null,
        BODY longtext not null,
        TIMEOUT_MINUTES integer,
        DESCRIPTION varchar(1200),
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        ARTIFACT_CHECKSUM varchar(200) default 'MANUAL RECORD' not null,
        primary key (ARTIFACT_UUID)
    );

    create table HEAT_TEMPLATE_PARAMS (
        HEAT_TEMPLATE_ARTIFACT_UUID varchar(255) not null,
        PARAM_NAME varchar(255) not null,
        IS_REQUIRED bit not null,
        PARAM_TYPE varchar(20),
        PARAM_ALIAS varchar(45),
        primary key (HEAT_TEMPLATE_ARTIFACT_UUID, PARAM_NAME)
    );

    create table MODEL (
        id integer not null auto_increment,
        MODEL_TYPE varchar(20) not null,
        MODEL_VERSION_ID varchar(40) not null,
        MODEL_INVARIANT_ID varchar(40),
        MODEL_NAME varchar(40) not null,
        MODEL_VERSION varchar(20),
        MODEL_CUSTOMIZATION_ID varchar(40),
        MODEL_CUSTOMIZATION_NAME varchar(40),
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (id)
    );

    create table MODEL_RECIPE (
        id integer not null auto_increment,
        MODEL_ID integer not null,
        ACTION varchar(20) not null,
        SCHEMA_VERSION varchar(20),
        DESCRIPTION varchar(1200),
        ORCHESTRATION_URI varchar(256) not null,
        MODEL_PARAM_XSD varchar(2048),
        RECIPE_TIMEOUT integer,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (id)
    );

    create table NETWORK_RECIPE (
        id integer not null auto_increment,
        MODEL_NAME varchar(20) not null,
        ACTION varchar(20) not null,
        VERSION_STR varchar(20) not null,
        SERVICE_TYPE varchar(45),
        DESCRIPTION varchar(1200),
        ORCHESTRATION_URI varchar(256) not null,
        NETWORK_PARAM_XSD varchar(2048),
        RECIPE_TIMEOUT integer,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (id)
    );

    create table NETWORK_RESOURCE (
        MODEL_UUID varchar(200) not null,
        MODEL_NAME varchar(200) not null,
        MODEL_INVARIANT_UUID varchar(200),
        MODEL_VERSION varchar(20),
        TOSCA_NODE_TYPE varchar(200),
        NEUTRON_NETWORK_TYPE varchar(20),
        DESCRIPTION varchar(1200),
        ORCHESTRATION_MODE varchar(20),
        RESOURCE_CATEGORY varchar(20),
        RESOURCE_SUB_CATEGORY varchar(20),
        HEAT_TEMPLATE_ARTIFACT_UUID varchar(200) not null,
        AIC_VERSION_MIN varchar(20) default 2.5 not null,
        AIC_VERSION_MAX varchar(20) default 2.5,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (MODEL_UUID)
    );

    create table NETWORK_RESOURCE_CUSTOMIZATION (
        MODEL_CUSTOMIZATION_UUID varchar(200) not null,
        NETWORK_RESOURCE_MODEL_UUID varchar(200) not null,
        MODEL_INSTANCE_NAME varchar(255),
        NETWORK_TECHNOLOGY varchar(255),
        NETWORK_TYPE varchar(255),
        NETWORK_SCOPE varchar(255),
        NETWORK_ROLE varchar(255),
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (MODEL_CUSTOMIZATION_UUID)
    );

    create table SERVICE (
        MODEL_UUID varchar(200) not null,
        MODEL_NAME varchar(200) not null,
        MODEL_VERSION varchar(20) not null,
        DESCRIPTION varchar(1200),
        TOSCA_CSAR_ARTIFACT_UUID varchar(200),
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        MODEL_INVARIANT_UUID varchar(200) default 'MANUAL_RECORD' not null,
        SERVICE_CATEGORY varchar(20),
        SERVICE_TYPE varchar(20),
        SERVICE_ROLE varchar(20),
        ENVIRONMENT_CONTEXT varchar(255) default null,
        WORKLOAD_CONTEXT varchar(255) default null,
        primary key (MODEL_UUID)
    );

    create table SERVICE_RECIPE (
        id integer not null auto_increment,
        SERVICE_MODEL_UUID varchar(200) not null,
        ACTION varchar(40) not null,
        ORCHESTRATION_URI varchar(256) not null,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        VERSION_STR varchar(20),
        DESCRIPTION varchar(1200),
        SERVICE_PARAM_XSD varchar(2048),
        RECIPE_TIMEOUT integer,
        SERVICE_TIMEOUT_INTERIM integer,
        primary key (id)
    );

    create table SERVICE_TO_ALLOTTED_RESOURCES (
        SERVICE_MODEL_UUID varchar(200) not null,
        AR_MODEL_CUSTOMIZATION_UUID varchar(200) not null,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (SERVICE_MODEL_UUID, AR_MODEL_CUSTOMIZATION_UUID)
    );

    create table SERVICE_TO_NETWORKS (
        SERVICE_MODEL_UUID varchar(200) not null,
        NETWORK_MODEL_CUSTOMIZATION_UUID varchar(200) not null,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (SERVICE_MODEL_UUID, NETWORK_MODEL_CUSTOMIZATION_UUID)
    );

    create table SERVICE_TO_RESOURCE_CUSTOMIZATIONS (
        MODEL_TYPE varchar(20) not null,
        RESOURCE_MODEL_CUSTOMIZATION_UUID varchar(200) not null,
        SERVICE_MODEL_UUID varchar(200) not null,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (MODEL_TYPE, RESOURCE_MODEL_CUSTOMIZATION_UUID, SERVICE_MODEL_UUID)
    );

    create table TEMP_NETWORK_HEAT_TEMPLATE_LOOKUP (
        NETWORK_RESOURCE_MODEL_NAME varchar(200) not null,
        HEAT_TEMPLATE_ARTIFACT_UUID varchar(200) not null,
        AIC_VERSION_MIN varchar(20) not null,
        AIC_VERSION_MAX varchar(20),
        primary key (NETWORK_RESOURCE_MODEL_NAME)
    );

    create table TOSCA_CSAR (
        ARTIFACT_UUID varchar(200) not null,
        NAME varchar(200) not null,
        VERSION varchar(20) not null,
        ARTIFACT_CHECKSUM varchar(200) not null,
        URL varchar(200) not null,
        DESCRIPTION varchar(1200),
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (ARTIFACT_UUID)
    );

    create table VF_MODULE (
        MODEL_UUID varchar(200) not null,
        VNF_RESOURCE_MODEL_UUID varchar(200),
        MODEL_INVARIANT_UUID varchar(200),
        MODEL_VERSION varchar(20) not null,
        MODEL_NAME varchar(200) not null,
        DESCRIPTION varchar(1200),
        IS_BASE integer not null,
        HEAT_TEMPLATE_ARTIFACT_UUID varchar(200) not null,
        VOL_HEAT_TEMPLATE_ARTIFACT_UUID varchar(200),
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (MODEL_UUID)
    );

    create table VF_MODULE_CUSTOMIZATION (
        MODEL_CUSTOMIZATION_UUID varchar(200) not null,
        VF_MODULE_MODEL_UUID varchar(200) not null,
        VOL_ENVIRONMENT_ARTIFACT_UUID varchar(200),
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        HEAT_ENVIRONMENT_ARTIFACT_UUID varchar(200),
        MIN_INSTANCES integer,
        MAX_INSTANCES integer,
        INITIAL_COUNT integer,
        AVAILABILITY_ZONE_COUNT integer,
        LABEL varchar(200),
        primary key (MODEL_CUSTOMIZATION_UUID)
    );

    create table VF_MODULE_TO_HEAT_FILES (
        VF_MODULE_MODEL_UUID varchar(200) not null,
        HEAT_FILES_ARTIFACT_UUID varchar(200) not null,
        primary key (VF_MODULE_MODEL_UUID, HEAT_FILES_ARTIFACT_UUID)
    );

    create table VNF_COMPONENTS (
        VNF_ID integer not null,
        COMPONENT_TYPE varchar(20) not null,
        HEAT_TEMPLATE_ID integer,
        HEAT_ENVIRONMENT_ID integer,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (VNF_ID, COMPONENT_TYPE)
    );

    create table VNF_COMPONENTS_RECIPE (
        id integer not null auto_increment,
        VNF_TYPE varchar(200),
        VF_MODULE_MODEL_UUID varchar(100),
        VNF_COMPONENT_TYPE varchar(45) not null,
        ACTION varchar(20) not null,
        SERVICE_TYPE varchar(45),
        VERSION varchar(20),
        DESCRIPTION varchar(1200),
        ORCHESTRATION_URI varchar(256) not null,
        VNF_COMPONENT_PARAM_XSD varchar(2048),
        RECIPE_TIMEOUT integer,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (id)
    );

    create table VNF_RECIPE (
        id integer not null auto_increment,
        VF_MODULE_ID varchar(100),
        ACTION varchar(20) not null,
        VERSION_STR varchar(20) not null,
        VNF_TYPE varchar(200),
        SERVICE_TYPE varchar(45) default null,
        DESCRIPTION varchar(1200),
        ORCHESTRATION_URI varchar(256) not null,
        VNF_PARAM_XSD varchar(2048),
        RECIPE_TIMEOUT integer,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (id)
    );

    create table VNF_RESOURCE (
        MODEL_UUID varchar(200) not null,
        MODEL_INVARIANT_UUID varchar(200),
        MODEL_VERSION varchar(20) not null,
        MODEL_NAME varchar(200),
        TOSCA_NODE_TYPE varchar(200),
        DESCRIPTION varchar(1200),
        ORCHESTRATION_MODE varchar(20) not null,
        AIC_VERSION_MIN varchar(20),
        AIC_VERSION_MAX varchar(20),
        RESOURCE_CATEGORY varchar(20),
        RESOURCE_SUB_CATEGORY varchar(20),
        HEAT_TEMPLATE_ARTIFACT_UUID varchar(200),
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (MODEL_UUID)
    );

    create table VNF_RESOURCE_CUSTOMIZATION (
        MODEL_CUSTOMIZATION_UUID varchar(200) not null,
        MODEL_INSTANCE_NAME varchar(200) not null,
        MIN_INSTANCES integer,
        MAX_INSTANCES integer,
        AVAILABILITY_ZONE_MAX_COUNT integer,
        NF_FUNCTION varchar(200),
        NF_TYPE varchar(200),
        NF_ROLE varchar(200),
        NF_NAMING_CODE varchar(200),
        MULTI_STAGE_DESIGN varchar(200),
        VNF_RESOURCE_MODEL_UUID varchar(200) not null,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (MODEL_CUSTOMIZATION_UUID)
    );

    create table VNF_RES_CUSTOM_TO_VF_MODULE_CUSTOM (
        VNF_RESOURCE_CUST_MODEL_CUSTOMIZATION_UUID varchar(200) not null,
        VF_MODULE_CUST_MODEL_CUSTOMIZATION_UUID varchar(200) not null,
        CREATION_TIMESTAMP datetime default CURRENT_TIMESTAMP,
        primary key (VNF_RESOURCE_CUST_MODEL_CUSTOMIZATION_UUID, VF_MODULE_CUST_MODEL_CUSTOMIZATION_UUID)
    );

    alter table MODEL 
        add constraint UK_rra00f1rk6eyy7g00k9raxh2v  unique (MODEL_TYPE, MODEL_VERSION_ID);

    alter table MODEL_RECIPE 
        add constraint UK_b4g8j9wtqrkxfycyi3ursk7gb  unique (MODEL_ID, ACTION);

    alter table NETWORK_RECIPE 
        add constraint UK_pbsa8i44m8p10f9529jdgfuk9  unique (MODEL_NAME, ACTION, VERSION_STR);

    alter table SERVICE_RECIPE 
        add constraint UK_2lr377dpqnvl5aqlp5dtj2fcp  unique (SERVICE_MODEL_UUID, ACTION);

    alter table VNF_COMPONENTS_RECIPE 
        add constraint UK_g3je95aaxxiuest25f0qoy2u8  unique (VNF_TYPE, VF_MODULE_MODEL_UUID, VNF_COMPONENT_TYPE, ACTION, SERVICE_TYPE, VERSION);

    alter table VNF_RECIPE 
        add constraint UK_f3tvqau498vrifq3cr8qnigkr  unique (VF_MODULE_ID, ACTION, VERSION_STR);

    alter table HEAT_TEMPLATE_PARAMS 
        add constraint FK_p3ol1xcvp831glqohrlu6o07o 
        foreign key (HEAT_TEMPLATE_ARTIFACT_UUID) 
        references HEAT_TEMPLATE (ARTIFACT_UUID);

    alter table MODEL_RECIPE 
        add constraint FK_c23r0puyqug6n44jg39dutm1c 
        foreign key (MODEL_ID) 
        references MODEL (id);

    alter table SERVICE 
        add constraint FK_l3qy594u2xr1tfpmma3uigsna 
        foreign key (TOSCA_CSAR_ARTIFACT_UUID) 
        references TOSCA_CSAR (ARTIFACT_UUID);

    alter table SERVICE_RECIPE 
        add constraint FK_i3r1b8j6e7dg9hkp49evnnm5y 
        foreign key (SERVICE_MODEL_UUID) 
        references SERVICE (MODEL_UUID);

    alter table SERVICE_TO_RESOURCE_CUSTOMIZATIONS 
        add constraint FK_kiddaay6cfe0aob1f1jaio1bb 
        foreign key (SERVICE_MODEL_UUID) 
        references SERVICE (MODEL_UUID);

    alter table VF_MODULE 
        add constraint FK_12jptc9it7gs3pru08skobxxc 
        foreign key (VNF_RESOURCE_MODEL_UUID) 
        references VNF_RESOURCE (MODEL_UUID);

    alter table VNF_RESOURCE_CUSTOMIZATION 
        add constraint FK_iff1ayhb1hrp5jhea3vvikuni 
        foreign key (VNF_RESOURCE_MODEL_UUID) 
        references VNF_RESOURCE (MODEL_UUID);
