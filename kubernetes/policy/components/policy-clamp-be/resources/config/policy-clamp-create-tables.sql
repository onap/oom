/*
 * ============LICENSE_START=======================================================
 *  Copyright (C) 2021 Nordix Foundation
 *  ================================================================================
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  SPDX-License-Identifier: Apache-2.0
 *  ============LICENSE_END=========================================================
 */

create table if not exists dictionary (
    name varchar(255) not null,
    created_by varchar(255),
    created_timestamp datetime(6) not null,
    updated_by varchar(255),
    updated_timestamp datetime(6) not null,
    dictionary_second_level integer,
    dictionary_type varchar(255),
    primary key (name)
    ) engine=InnoDB;

create table if not exists dictionary_elements (
    short_name varchar(255) not null,
    created_by varchar(255),
    created_timestamp datetime(6) not null,
    updated_by varchar(255),
    updated_timestamp datetime(6) not null,
    description varchar(255) not null,
    name varchar(255) not null,
    subdictionary_name varchar(255),
    type varchar(255) not null,
    primary key (short_name)
    ) engine=InnoDB;

create table if not exists dictionary_to_dictionaryelements (
    dictionary_name varchar(255) not null,
    dictionary_element_short_name varchar(255) not null,
    primary key (dictionary_name, dictionary_element_short_name)
    ) engine=InnoDB;

create table if not exists hibernate_sequence (
    next_val bigint
) engine=InnoDB;

insert into hibernate_sequence values ( 1 );

create table if not exists loop_element_models (
    name varchar(255) not null,
    created_by varchar(255),
    created_timestamp datetime(6) not null,
    updated_by varchar(255),
    updated_timestamp datetime(6) not null,
    blueprint_yaml MEDIUMTEXT,
    dcae_blueprint_id varchar(255),
    loop_element_type varchar(255) not null,
    short_name varchar(255),
    primary key (name)
    ) engine=InnoDB;

create table if not exists loop_logs (
                                         id bigint not null,
                                         log_component varchar(255) not null,
    log_instant datetime(6) not null,
    log_type varchar(255) not null,
    message MEDIUMTEXT not null,
    loop_id varchar(255) not null,
    primary key (id)
    ) engine=InnoDB;

create table if not exists loop_templates (
    name varchar(255) not null,
    created_by varchar(255),
    created_timestamp datetime(6) not null,
    updated_by varchar(255),
    updated_timestamp datetime(6) not null,
    allowed_loop_type varchar(255),
    blueprint_yaml MEDIUMTEXT,
    dcae_blueprint_id varchar(255),
    maximum_instances_allowed integer,
    svg_representation MEDIUMTEXT,
    unique_blueprint boolean default false,
    service_uuid varchar(255),
    primary key (name)
    ) engine=InnoDB;

create table if not exists loopelementmodels_to_policymodels (
    loop_element_name varchar(255) not null,
    policy_model_type varchar(255) not null,
    policy_model_version varchar(255) not null,
    primary key (loop_element_name, policy_model_type, policy_model_version)
    ) engine=InnoDB;

create table if not exists loops (
    name varchar(255) not null,
    created_by varchar(255),
    created_timestamp datetime(6) not null,
    updated_by varchar(255),
    updated_timestamp datetime(6) not null,
    dcae_deployment_id varchar(255),
    dcae_deployment_status_url varchar(255),
    global_properties_json json,
    last_computed_state varchar(255) not null,
    svg_representation MEDIUMTEXT,
    loop_template_name varchar(255) not null,
    service_uuid varchar(255),
    primary key (name)
    ) engine=InnoDB;

create table if not exists loops_to_microservicepolicies (
    loop_name varchar(255) not null,
    microservicepolicy_name varchar(255) not null,
    primary key (loop_name, microservicepolicy_name)
    ) engine=InnoDB;

create table if not exists looptemplates_to_loopelementmodels (
    loop_element_model_name varchar(255) not null,
    loop_template_name varchar(255) not null,
    flow_order integer not null,
    primary key (loop_element_model_name, loop_template_name)
    ) engine=InnoDB;

create table if not exists micro_service_policies (
    name varchar(255) not null,
    created_by varchar(255),
    created_timestamp datetime(6) not null,
    updated_by varchar(255),
    updated_timestamp datetime(6) not null,
    configurations_json json,
    json_representation json not null,
    pdp_group varchar(255),
    pdp_sub_group varchar(255),
    context varchar(255),
    dcae_blueprint_id varchar(255),
    dcae_deployment_id varchar(255),
    dcae_deployment_status_url varchar(255),
    device_type_scope varchar(255),
    shared bit not null,
    loop_element_model_id varchar(255),
    policy_model_type varchar(255),
    policy_model_version varchar(255),
    primary key (name)
    ) engine=InnoDB;

create table if not exists operational_policies (
    name varchar(255) not null,
    created_by varchar(255),
    created_timestamp datetime(6) not null,
    updated_by varchar(255),
    updated_timestamp datetime(6) not null,
    configurations_json json,
    json_representation json not null,
    pdp_group varchar(255),
    pdp_sub_group varchar(255),
    loop_element_model_id varchar(255),
    policy_model_type varchar(255),
    policy_model_version varchar(255),
    loop_id varchar(255) not null,
    primary key (name)
    ) engine=InnoDB;

create table if not exists policy_models (
    policy_model_type varchar(255) not null,
    version varchar(255) not null,
    created_by varchar(255),
    created_timestamp datetime(6) not null,
    updated_by varchar(255),
    updated_timestamp datetime(6) not null,
    policy_acronym varchar(255),
    policy_tosca MEDIUMTEXT,
    policy_pdp_group json,
    primary key (policy_model_type, version)
    ) engine=InnoDB;

create table if not exists services (
    service_uuid varchar(255) not null,
    name varchar(255) not null,
    resource_details json,
    service_details json,
    version varchar(255),
    primary key (service_uuid)
    ) engine=InnoDB;

alter table dictionary_to_dictionaryelements
    add constraint FK68hjjinnm8nte2owstd0xwp23
        foreign key (dictionary_element_short_name)
            references dictionary_elements (short_name);

alter table dictionary_to_dictionaryelements
    add constraint FKtqfxg46gsxwlm2gkl6ne3cxfe
        foreign key (dictionary_name)
            references dictionary (name);

alter table loop_logs
    add constraint FK1j0cda46aickcaoxqoo34khg2
        foreign key (loop_id)
            references loops (name);

alter table loop_templates
    add constraint FKn692dk6281wvp1o95074uacn6
        foreign key (service_uuid)
            references services (service_uuid);

alter table loopelementmodels_to_policymodels
    add constraint FK23j2q74v6kaexefy0tdabsnda
        foreign key (policy_model_type, policy_model_version)
            references policy_models (policy_model_type, version);

alter table loopelementmodels_to_policymodels
    add constraint FKjag1iu0olojfwryfkvb5o0rk5
        foreign key (loop_element_name)
            references loop_element_models (name);

alter table loops
    add constraint FK844uwy82wt0l66jljkjqembpj
        foreign key (loop_template_name)
            references loop_templates (name);

alter table loops
    add constraint FK4b9wnqopxogwek014i1shqw7w
        foreign key (service_uuid)
            references services (service_uuid);

alter table loops_to_microservicepolicies
    add constraint FKle255jmi7b065fwbvmwbiehtb
        foreign key (microservicepolicy_name)
            references micro_service_policies (name);

alter table loops_to_microservicepolicies
    add constraint FK8avfqaf7xl71l7sn7a5eri68d
        foreign key (loop_name)
            references loops (name);

alter table looptemplates_to_loopelementmodels
    add constraint FK1k7nbrbugvqa0xfxkq3cj1yn9
        foreign key (loop_element_model_name)
            references loop_element_models (name);

alter table looptemplates_to_loopelementmodels
    add constraint FKj29yxyw0x7ue6mwgi6d3qg748
        foreign key (loop_template_name)
            references loop_templates (name);

alter table micro_service_policies
    add constraint FKqvvdypacbww07fuv8xvlvdjgl
        foreign key (loop_element_model_id)
            references loop_element_models (name);

alter table micro_service_policies
    add constraint FKn17j9ufmyhqicb6cvr1dbjvkt
        foreign key (policy_model_type, policy_model_version)
            references policy_models (policy_model_type, version);

alter table operational_policies
    add constraint FKi9kh7my40737xeuaye9xwbnko
        foreign key (loop_element_model_id)
            references loop_element_models (name);

alter table operational_policies
    add constraint FKlsyhfkoqvkwj78ofepxhoctip
        foreign key (policy_model_type, policy_model_version)
            references policy_models (policy_model_type, version);

alter table operational_policies
    add constraint FK1ddoggk9ni2bnqighv6ecmuwu
        foreign key (loop_id)
            references loops (name);
