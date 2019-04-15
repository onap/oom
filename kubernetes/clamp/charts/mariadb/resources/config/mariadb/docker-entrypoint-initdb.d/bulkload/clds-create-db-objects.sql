/* Copyright © 2017-2019 AT&T, Amdocs, Bell Canada
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

#
# Create CLDS database objects (tables, etc.)
#
#
CREATE DATABASE `cldsdb4`;
USE `cldsdb4`;
DROP USER 'clds';
CREATE USER 'clds';
GRANT ALL on cldsdb4.* to 'clds' identified by 'sidnnd83K' with GRANT OPTION;
GRANT SELECT on mysql.proc TO 'clds';
FLUSH PRIVILEGES;


CREATE TABLE template (
  template_id VARCHAR(36) NOT NULL,
  template_name VARCHAR(80) NOT NULL,
  template_bpmn_id VARCHAR(36) NULL,
  template_image_id VARCHAR(36) NULL,
  template_doc_id VARCHAR(36) NULL,
  PRIMARY KEY (template_id),
  UNIQUE (template_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE template_bpmn (
  template_bpmn_id VARCHAR(36) NOT NULL,
  template_id VARCHAR(36) NOT NULL,
  template_bpmn_text MEDIUMTEXT NOT NULL,
  user_id VARCHAR(80),
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (template_bpmn_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE template_image (
  template_image_id VARCHAR(36) NOT NULL,
  template_id VARCHAR(36) NOT NULL,
  template_image_text MEDIUMTEXT NULL,
  user_id VARCHAR(80),
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (template_image_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE template_doc (
  template_doc_id VARCHAR(36) NOT NULL,
  template_id VARCHAR(36) NOT NULL,
  template_doc_text MEDIUMTEXT NULL,
  user_id VARCHAR(80),
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (template_doc_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE model (
  model_id VARCHAR(36) NOT NULL,
  model_name VARCHAR(80) NOT NULL,
  template_id VARCHAR(36) NULL,
  model_prop_id VARCHAR(36) NULL,
  model_blueprint_id VARCHAR(36) NULL,
  event_id VARCHAR(36) NULL,
  control_name_prefix VARCHAR(80) NULL,
  control_name_uuid VARCHAR(36) NOT NULL,
  service_type_id VARCHAR(80) NULL,
  deployment_id VARCHAR(80) NULL,
  deployment_status_url VARCHAR(300) NULL,
  PRIMARY KEY (model_id),
  UNIQUE (model_name),
  UNIQUE (control_name_uuid),
  UNIQUE (service_type_id),
  UNIQUE (deployment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE model_properties (
  model_prop_id VARCHAR(36) NOT NULL,
  model_id VARCHAR(36) NOT NULL,
  model_prop_text MEDIUMTEXT NULL,
  user_id VARCHAR(80),
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (model_prop_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE model_blueprint (
  model_blueprint_id VARCHAR(36) NOT NULL,
  model_id VARCHAR(36) NOT NULL,
  model_blueprint_text MEDIUMTEXT NULL,
  user_id VARCHAR(80),
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (model_blueprint_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE model_instance (
  model_instance_id VARCHAR(36) NOT NULL,
  model_id VARCHAR(36) NOT NULL,
  vm_name VARCHAR(250) NOT NULL,
  location VARCHAR(250) NULL,
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (model_instance_id),
  UNIQUE (model_id, vm_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE event (
  event_id VARCHAR(36) NOT NULL,
  model_id VARCHAR(36) NULL,
  action_cd VARCHAR(80) NOT NULL,
  action_state_cd VARCHAR(80) NULL,
  prev_event_id VARCHAR(36) NULL,
  process_instance_id VARCHAR(80) NULL,
  user_id VARCHAR(80) NULL,
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE IF NOT EXISTS tosca_model (
  tosca_model_id VARCHAR(36) NOT NULL,
  tosca_model_name VARCHAR(80) NOT NULL,
  policy_type VARCHAR(80) NULL,
  user_id VARCHAR(80),
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (tosca_model_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE IF NOT EXISTS tosca_model_revision (
  tosca_model_revision_id VARCHAR(36) NOT NULL,
  tosca_model_id VARCHAR(36) NOT NULL,
  version DOUBLE NOT NULL DEFAULT 1,
  tosca_model_yaml MEDIUMTEXT NULL,
  tosca_model_json MEDIUMTEXT NULL,
  user_id VARCHAR(80),
  createdTimestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  lastUpdatedTimestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (tosca_model_revision_id),
  CONSTRAINT tosca_model_revision_ukey UNIQUE KEY (tosca_model_id, version),
  CONSTRAINT tosca_model_revision_fkey01 FOREIGN KEY (tosca_model_id) REFERENCES tosca_model (tosca_model_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE IF NOT EXISTS dictionary (
  dictionary_id VARCHAR(36) NOT NULL,
  dictionary_name VARCHAR(80) NOT NULL,
  created_by VARCHAR(80),
  modified_by VARCHAR(80),
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (dictionary_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE IF NOT EXISTS dictionary_elements (
  dict_element_id VARCHAR(36) NOT NULL,
  dictionary_id VARCHAR(36) NOT NULL,
  dict_element_name VARCHAR(250) NOT NULL,
  dict_element_short_name VARCHAR(80) NOT NULL,
  dict_element_description VARCHAR(250),
  dict_element_type VARCHAR(80) NOT NULL,
  created_by VARCHAR(80),
  modified_by VARCHAR(80),
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (dict_element_id),
  CONSTRAINT dictionary_elements_ukey UNIQUE KEY (dict_element_name, dict_element_short_name),
  CONSTRAINT dictionary_elements_ukey_fkey01 FOREIGN KEY (dictionary_id) REFERENCES dictionary (dictionary_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

ALTER TABLE template
    ADD CONSTRAINT template_bpmn_id_fkey01
    FOREIGN KEY (template_bpmn_id)
    REFERENCES template_bpmn (template_bpmn_id);

ALTER TABLE template
    ADD CONSTRAINT template_image_id_fkey01
    FOREIGN KEY (template_image_id)
    REFERENCES template_image (template_image_id);

ALTER TABLE template
    ADD CONSTRAINT template_doc_id_fkey01
    FOREIGN KEY (template_doc_id)
    REFERENCES template_doc (template_doc_id);

ALTER TABLE template_bpmn
    ADD CONSTRAINT template_id_fkey02
    FOREIGN KEY (template_id)
    REFERENCES template (template_id);

ALTER TABLE template_image
    ADD CONSTRAINT template_id_fkey03
    FOREIGN KEY (template_id)
    REFERENCES template (template_id);

ALTER TABLE template_doc
    ADD CONSTRAINT template_id_fkey04
    FOREIGN KEY (template_id)
    REFERENCES template (template_id);

ALTER TABLE model
    ADD CONSTRAINT template_id_fkey01
    FOREIGN KEY (template_id)
    REFERENCES template (template_id);

ALTER TABLE model
    ADD CONSTRAINT model_prop_id_fkey01
    FOREIGN KEY (model_prop_id)
    REFERENCES model_properties (model_prop_id);

ALTER TABLE model
    ADD CONSTRAINT model_blueprint_id_fkey01
    FOREIGN KEY (model_blueprint_id)
    REFERENCES model_blueprint (model_blueprint_id);

ALTER TABLE model
    ADD CONSTRAINT event_id_fkey01
    FOREIGN KEY (event_id)
    REFERENCES event (event_id);

ALTER TABLE model_properties
    ADD CONSTRAINT model_id_fkey01
    FOREIGN KEY (model_id)
    REFERENCES model (model_id);

ALTER TABLE model_blueprint
    ADD CONSTRAINT model_id_fkey02
    FOREIGN KEY (model_id)
    REFERENCES model (model_id);

ALTER TABLE model_instance
    ADD CONSTRAINT model_id_fkey04
    FOREIGN KEY (model_id)
    REFERENCES model (model_id);

ALTER TABLE event
    ADD CONSTRAINT model_id_fkey03
    FOREIGN KEY (model_id)
    REFERENCES model (model_id);
