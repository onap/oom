/* Copyright © 2019 AT&T
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*       http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
    create table hibernate_sequence (
       next_val bigint
    ) engine=InnoDB;

    insert into hibernate_sequence values ( 1 );

    create table loop_logs (
       id bigint not null,
        log_instant datetime(6) not null,
        log_type varchar(255) not null,
        message varchar(255) not null,
        loop_id varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table loops (
       name varchar(255) not null,
        blueprint_yaml MEDIUMTEXT not null,
        dcae_blueprint_id varchar(255),
        dcae_deployment_id varchar(255),
        dcae_deployment_status_url varchar(255),
        global_properties_json json,
        last_computed_state varchar(255) not null,
        model_properties_json json,
        svg_representation MEDIUMTEXT,
        primary key (name)
    ) engine=InnoDB;

    create table loops_microservicepolicies (
       loop_id varchar(255) not null,
        microservicepolicy_id varchar(255) not null,
        primary key (loop_id, microservicepolicy_id)
    ) engine=InnoDB;

    create table micro_service_policies (
       name varchar(255) not null,
        json_representation json not null,
        model_type varchar(255) not null,
        policy_tosca MEDIUMTEXT not null,
        properties json,
        shared bit not null,
        primary key (name)
    ) engine=InnoDB;

    create table operational_policies (
       name varchar(255) not null,
        configurations_json json,
        loop_id varchar(255) not null,
        primary key (name)
    ) engine=InnoDB;

    alter table loop_logs
       add constraint FK1j0cda46aickcaoxqoo34khg2
       foreign key (loop_id)
       references loops (name);

    alter table loops_microservicepolicies
       add constraint FKem7tp1cdlpwe28av7ef91j1yl
       foreign key (microservicepolicy_id)
       references micro_service_policies (name);

    alter table loops_microservicepolicies
       add constraint FKsvx91jekgdkfh34iaxtjfgebt
       foreign key (loop_id)
       references loops (name);

    alter table operational_policies
       add constraint FK1ddoggk9ni2bnqighv6ecmuwu
       foreign key (loop_id)
       references loops (name);
