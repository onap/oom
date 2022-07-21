CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create table if not exists intent(
    intent_id varchar(255) primary key,
    intent_name varchar(255)
);

create table if not exists expectation(
    expectation_id varchar(255) primary key,
    expectation_name varchar(255),
    expectation_type varchar(255),
    intent_id varchar(255)
);

create table if not exists expectation_object(
    object_id varchar(255) DEFAULT uuid_generate_v4 (),
    primary key(object_id),
    object_type varchar(255),
    object_instance varchar(255),
    expectation_id varchar(255)
);

create table if not exists expectation_target(
    target_id varchar(255) primary key,
    target_name varchar(255),
    expectation_id varchar(255)
);

create table if not exists context(
    context_id varchar(255) primary key,
    context_name varchar(255),
    parent_id varchar(255)
);

create table if not exists context_mapping(
    context_id varchar(255) primary key,
    parent_type varchar(255),
    parent_id varchar(255)
);

create table if not exists fulfilment_info(
    fulfilment_info_id varchar(255) primary key,
    fulfilment_info_status varchar(255),
    not_fulfilled_state varchar(255),
    not_fulfilled_reason varchar(255)
);

create table if not exists state(
    state_id varchar(255) primary key,
    state_name varchar(255),
    is_satisfied boolean,
    condition varchar(255),
    expectation_id varchar(255)
);

create table if not exists condition(
    condition_id varchar(255) primary key,
    condition_name varchar(255),
    operator_type varchar(255),
    condition_value varchar(255),
    parent_id varchar(255)
    );

create table if not exists intent_management_function_reg_info(
    imfr_info_id varchar(255) primary key,
    imfr_info_description varchar(255),
    support_area varchar(255),
    support_model varchar(255),
    support_interfaces varchar(255),
    handle_name varchar(255),
    intent_function_type varchar(255)
    );