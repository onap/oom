#
# Create CLDS database objects (tables, etc.)
#
#
CREATE DATABASE `camundabpm`;
USE `camundabpm`;
DROP USER 'camunda';
CREATE USER 'camunda';
GRANT ALL on camundabpm.* to 'camunda' identified by 'ndMSpw4CAM' with GRANT OPTION;
FLUSH PRIVILEGES;

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

CREATE TABLE clds_service_cache (
  invariant_service_id VARCHAR(36) NOT NULL,
  service_id VARCHAR(36) NULL,
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  object_data MEDIUMBLOB NULL,
  PRIMARY KEY (invariant_service_id)
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
