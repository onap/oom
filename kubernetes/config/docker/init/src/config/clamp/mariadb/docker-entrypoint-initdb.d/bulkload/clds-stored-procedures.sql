#
# CLDS stored procedures
#

USE cldsdb4;

DROP PROCEDURE IF EXISTS upd_event;
DROP PROCEDURE IF EXISTS ins_event;
DROP PROCEDURE IF EXISTS del_all_model_instances;
DROP PROCEDURE IF EXISTS del_model_instance;
DROP PROCEDURE IF EXISTS ins_model_instance;
DROP PROCEDURE IF EXISTS set_model;
DROP PROCEDURE IF EXISTS get_model;
DROP PROCEDURE IF EXISTS get_model_template;
DROP PROCEDURE IF EXISTS set_template;
DROP PROCEDURE IF EXISTS get_template;
DELIMITER //
CREATE PROCEDURE get_template
  (IN v_template_name VARCHAR(80),
   OUT v_template_id VARCHAR(36),
   OUT v_template_bpmn_id VARCHAR(36),
   OUT v_template_bpmn_user_id VARCHAR(80),
   OUT v_template_bpmn_text MEDIUMTEXT,
   OUT v_template_image_id VARCHAR(36),
   OUT v_template_image_user_id VARCHAR(80),
   OUT v_template_image_text MEDIUMTEXT,
   OUT v_template_doc_id VARCHAR(36),
   OUT v_template_doc_user_id VARCHAR(80),
   OUT v_template_doc_text MEDIUMTEXT)
BEGIN
  SELECT t.template_id,
		 tb.template_bpmn_id,
		 tb.user_id,
		 tb.template_bpmn_text,
		 ti.template_image_id,
		 ti.user_id,
		 ti.template_image_text,
		 td.template_doc_id,
		 td.user_id,
		 td.template_doc_text
    INTO v_template_id,
         v_template_bpmn_id,
         v_template_bpmn_user_id,
         v_template_bpmn_text,
         v_template_image_id,
         v_template_image_user_id,
         v_template_image_text,
         v_template_doc_id,
         v_template_doc_user_id,
         v_template_doc_text
    FROM template t,
         template_bpmn tb,
		 template_image ti,
		 template_doc td
    WHERE t.template_bpmn_id = tb.template_bpmn_id
	  AND t.template_image_id = ti.template_image_id
	  AND t.template_doc_id = td.template_doc_id
      AND t.template_name = v_template_name;
END;
CREATE PROCEDURE set_template
  (IN v_template_name VARCHAR(80),
   IN v_user_id VARCHAR(80),
   IN v_template_bpmn_text MEDIUMTEXT,
   IN v_template_image_text MEDIUMTEXT,
   IN v_template_doc_text MEDIUMTEXT,
   OUT v_template_id VARCHAR(36),
   OUT v_template_bpmn_id VARCHAR(36),
   OUT v_template_bpmn_user_id VARCHAR(80),
   OUT v_template_image_id VARCHAR(36),
   OUT v_template_image_user_id VARCHAR(80),
   OUT v_template_doc_id VARCHAR(36),
   OUT v_template_doc_user_id VARCHAR(80))
BEGIN
  DECLARE v_old_template_bpmn_text MEDIUMTEXT;
  DECLARE v_old_template_image_text MEDIUMTEXT;
  DECLARE v_old_template_doc_text MEDIUMTEXT;
  SET v_template_id = NULL;
  CALL get_template(
    v_template_name,
    v_template_id,
    v_template_bpmn_id,
    v_template_bpmn_user_id,
    v_old_template_bpmn_text,
    v_template_image_id,
    v_template_image_user_id,
    v_old_template_image_text,
    v_template_doc_id,
    v_template_doc_user_id,
    v_old_template_doc_text);
  IF v_template_id IS NULL THEN
    BEGIN
	  SET v_template_id = UUID();
      INSERT INTO template
	    (template_id, template_name)
	    VALUES (v_template_id, v_template_name);
	END;
  END IF;
  IF v_template_bpmn_id IS NULL OR v_template_bpmn_text <> v_old_template_bpmn_text THEN
	SET v_template_bpmn_id = UUID();
    INSERT INTO template_bpmn
	  (template_bpmn_id, template_id, template_bpmn_text, user_id)
	  VALUES (v_template_bpmn_id, v_template_id, v_template_bpmn_text, v_user_id);
	SET v_template_bpmn_user_id = v_user_id;
  END IF;
  IF v_template_image_id IS NULL OR v_template_image_text <> v_old_template_image_text THEN
	SET v_template_image_id = UUID();
    INSERT INTO template_image
	  (template_image_id, template_id, template_image_text, user_id)
	  VALUES (v_template_image_id, v_template_id, v_template_image_text, v_user_id);
	SET v_template_image_user_id = v_user_id;
  END IF;
  IF v_template_doc_id IS NULL OR v_template_doc_text <> v_old_template_doc_text THEN
	SET v_template_doc_id = UUID();
    INSERT INTO template_doc
	  (template_doc_id, template_id, template_doc_text, user_id)
	  VALUES (v_template_doc_id, v_template_id, v_template_doc_text, v_user_id);
	SET v_template_doc_user_id = v_user_id;
  END IF;
  UPDATE template
    SET template_bpmn_id = v_template_bpmn_id,
	    template_image_id = v_template_image_id,
	    template_doc_id = v_template_doc_id
    WHERE template_id = v_template_id;
END;
CREATE PROCEDURE get_model
  (IN v_model_name VARCHAR(80),
   OUT v_control_name_prefix VARCHAR(80),
   INOUT v_control_name_uuid VARCHAR(36),
   OUT v_model_id VARCHAR(36),
   OUT v_service_type_id VARCHAR(80),
   OUT v_deployment_id VARCHAR(80),
   OUT v_template_name VARCHAR(80),
   OUT v_template_id VARCHAR(36),
   OUT v_model_prop_id VARCHAR(36),
   OUT v_model_prop_user_id VARCHAR(80),
   OUT v_model_prop_text MEDIUMTEXT,
   OUT v_model_blueprint_id VARCHAR(36),
   OUT v_model_blueprint_user_id VARCHAR(80),
   OUT v_model_blueprint_text MEDIUMTEXT,
   OUT v_event_id VARCHAR(36),
   OUT v_action_cd VARCHAR(80),
   OUT v_action_state_cd VARCHAR(80),
   OUT v_event_process_instance_id VARCHAR(80),
   OUT v_event_user_id VARCHAR(80))
BEGIN
  SELECT m.control_name_prefix,
		 m.control_name_uuid,
		 m.model_id,
		 m.service_type_id,
		 m.deployment_id,
		 t.template_name,
		 m.template_id,
		 mp.model_prop_id,
		 mp.user_id,
		 mp.model_prop_text,
		 mb.model_blueprint_id,
		 mb.user_id,
		 mb.model_blueprint_text,
		 e.event_id,
		 e.action_cd,
		 e.action_state_cd,
		 e.process_instance_id,
		 e.user_id
    INTO v_control_name_prefix,
         v_control_name_uuid,
		 v_model_id,
		 v_service_type_id,
		 v_deployment_id,
		 v_template_name,
         v_template_id,
         v_model_prop_id,
         v_model_prop_user_id,
         v_model_prop_text,
         v_model_blueprint_id,
         v_model_blueprint_user_id,
         v_model_blueprint_text,
         v_event_id,
         v_action_cd,
		 v_action_state_cd,
         v_event_process_instance_id,
         v_event_user_id
    FROM model m,
		 template t,
		 model_properties mp,
		 model_blueprint mb,
		 event e
    WHERE m.template_id = t.template_id
	  AND m.model_prop_id = mp.model_prop_id
	  AND m.model_blueprint_id = mb.model_blueprint_id
	  AND m.event_id = e.event_id
      AND (m.model_name = v_model_name
      OR  m.control_name_uuid = v_control_name_uuid);
    SELECT model_instance_id,
           vm_name,
           location,
           timestamp
    FROM model_instance
    WHERE model_id = v_model_id
    ORDER BY 2;
END;
CREATE PROCEDURE get_model_template
  (IN v_model_name VARCHAR(80),
   OUT v_control_name_prefix VARCHAR(80),
   INOUT v_control_name_uuid VARCHAR(36),
   OUT v_model_id VARCHAR(36),
   OUT v_service_type_id VARCHAR(80),
   OUT v_deployment_id VARCHAR(80),
   OUT v_template_name VARCHAR(80),
   OUT v_template_id VARCHAR(36),
   OUT v_model_prop_id VARCHAR(36),
   OUT v_model_prop_user_id VARCHAR(80),
   OUT v_model_prop_text MEDIUMTEXT,
   OUT v_model_blueprint_id VARCHAR(36),
   OUT v_model_blueprint_user_id VARCHAR(80),
   OUT v_model_blueprint_text MEDIUMTEXT,
   OUT v_template_bpmn_id VARCHAR(36),
   OUT v_template_bpmn_user_id VARCHAR(80),
   OUT v_template_bpmn_text MEDIUMTEXT,
   OUT v_template_image_id VARCHAR(36),
   OUT v_template_image_user_id VARCHAR(80),
   OUT v_template_image_text MEDIUMTEXT,
   OUT v_template_doc_id VARCHAR(36),
   OUT v_template_doc_user_id VARCHAR(80),
   OUT v_template_doc_text MEDIUMTEXT,
   OUT v_event_id VARCHAR(36),
   OUT v_action_cd VARCHAR(80),
   OUT v_action_state_cd VARCHAR(80),
   OUT v_event_process_instance_id VARCHAR(80),
   OUT v_event_user_id VARCHAR(80))
BEGIN
  CALL get_model(
    v_model_name,
    v_control_name_prefix,
    v_control_name_uuid,
    v_model_id,
	v_service_type_id,
	v_deployment_id,
    v_template_name,
    v_template_id,
    v_model_prop_id,
    v_model_prop_user_id,
    v_model_prop_text,
    v_model_blueprint_id,
    v_model_blueprint_user_id,
    v_model_blueprint_text,
	v_event_id,
	v_action_cd,
	v_action_state_cd,
	v_event_process_instance_id,
	v_event_user_id);
  CALL get_template(
    v_template_name,
    v_template_id,
    v_template_bpmn_id,
    v_template_bpmn_user_id,
    v_template_bpmn_text,
    v_template_image_id,
    v_template_image_user_id,
    v_template_image_text,
    v_template_doc_id,
    v_template_doc_user_id,
    v_template_doc_text);
  END;
CREATE PROCEDURE set_model
  (IN v_model_name VARCHAR(80),
   IN v_template_id VARCHAR(36),
   IN v_user_id VARCHAR(80),
   IN v_model_prop_text MEDIUMTEXT,
   IN v_model_blueprint_text MEDIUMTEXT,
   IN v_service_type_id VARCHAR(80),
   IN v_deployment_id VARCHAR(80),
   INOUT v_control_name_prefix VARCHAR(80),
   INOUT v_control_name_uuid VARCHAR(36),
   OUT v_model_id VARCHAR(36),
   OUT v_model_prop_id VARCHAR(36),
   OUT v_model_prop_user_id VARCHAR(80),
   OUT v_model_blueprint_id VARCHAR(36),
   OUT v_model_blueprint_user_id VARCHAR(80),
   OUT v_event_id VARCHAR(36),
   OUT v_action_cd VARCHAR(80),
   OUT v_action_state_cd VARCHAR(80),
   OUT v_event_process_instance_id VARCHAR(80),
   OUT v_event_user_id VARCHAR(80))
BEGIN
  DECLARE v_old_template_name VARCHAR(80);
  DECLARE v_old_template_id VARCHAR(36);
  DECLARE v_old_control_name_prefix VARCHAR(80);
  DECLARE v_old_control_name_uuid VARCHAR(36);
  DECLARE v_old_model_prop_text MEDIUMTEXT;
  DECLARE v_old_model_blueprint_text MEDIUMTEXT;
  DECLARE v_old_service_type_id VARCHAR(80);
  DECLARE v_old_deployment_id VARCHAR(80);
  SET v_model_id = NULL;
  CALL get_model(
    v_model_name,
    v_old_control_name_prefix,
    v_old_control_name_uuid,
    v_model_id,
	v_old_service_type_id,
	v_old_deployment_id,
    v_old_template_name,
    v_old_template_id,
    v_model_prop_id,
    v_model_prop_user_id,
    v_old_model_prop_text,
    v_model_blueprint_id,
    v_model_blueprint_user_id,
    v_old_model_blueprint_text,
	v_event_id,
	v_action_cd,
	v_action_state_cd,
	v_event_process_instance_id,
	v_event_user_id);
  IF v_model_id IS NULL THEN
    BEGIN
      # UUID can be provided initially but cannot be updated
	  # if not provided (this is expected) then it will be set here
      IF v_control_name_uuid IS NULL THEN
	    SET v_control_name_uuid = UUID();
	  END IF;
      SET v_model_id = v_control_name_uuid;
      INSERT INTO model
	    (model_id, model_name, template_id, control_name_prefix, control_name_uuid, service_type_id, deployment_id)
	    VALUES (v_model_id, v_model_name, v_template_id, v_control_name_prefix, v_control_name_uuid, v_service_type_id, v_deployment_id);
	  # since just created model, insert CREATED event as initial default event
	  SET v_action_cd = 'CREATE';
	  SET v_action_state_cd = 'COMPLETED';
	  SET v_event_user_id = v_user_id;
      SET v_event_id = UUID();
      INSERT INTO event
	    (event_id, model_id, action_cd, action_state_cd, user_id)
	    VALUES (v_event_id, v_model_id, v_action_cd, v_action_state_cd, v_event_user_id);
	  UPDATE model
		SET event_id = v_event_id
		WHERE model_id = v_model_id;
	END;
  ELSE
    BEGIN
	  # use old control_name_prefix if null value is provided
      IF v_control_name_prefix IS NULL THEN
	     SET v_control_name_prefix = v_old_control_name_prefix;
	  END IF;
	  # UUID can not be updated after initial insert
	  SET v_control_name_uuid = v_old_control_name_uuid;
	END;
  END IF;
  IF v_model_prop_id IS NULL OR v_model_prop_text <> v_old_model_prop_text THEN
	SET v_model_prop_id = UUID();
    INSERT INTO model_properties
	  (model_prop_id, model_id, model_prop_text, user_id)
	  VALUES (v_model_prop_id, v_model_id, v_model_prop_text, v_user_id);
	SET v_model_prop_user_id = v_user_id;
  END IF;
  IF v_model_blueprint_id IS NULL OR v_model_blueprint_text <> v_old_model_blueprint_text THEN
	SET v_model_blueprint_id = UUID();
    INSERT INTO model_blueprint
	  (model_blueprint_id, model_id, model_blueprint_text, user_id)
	  VALUES (v_model_blueprint_id, v_model_id, v_model_blueprint_text, v_user_id);
	SET v_model_blueprint_user_id = v_user_id;
  END IF;
  UPDATE model
    SET control_name_prefix = v_control_name_prefix,
	    model_prop_id = v_model_prop_id,
	    model_blueprint_id = v_model_blueprint_id,
	    service_type_id = v_service_type_id,
	    deployment_id = v_deployment_id
    WHERE model_id = v_model_id;
END;
CREATE PROCEDURE ins_model_instance
  (IN v_control_name_uuid VARCHAR(36),
   IN v_vm_name VARCHAR(250),
   IN v_location VARCHAR(250),
   OUT v_model_id VARCHAR(36),
   OUT v_model_instance_id VARCHAR(36))
BEGIN
   SELECT m.model_id
    INTO v_model_id
    FROM model m
    WHERE m.control_name_uuid = v_control_name_uuid;
  SET v_model_instance_id = UUID();
  INSERT INTO model_instance
	(model_instance_id, model_id, vm_name, location)
	VALUES (v_model_instance_id, v_model_id, v_vm_name, v_location);
END;
CREATE PROCEDURE del_model_instance
  (IN v_control_name_uuid VARCHAR(36),
   IN v_vm_name VARCHAR(250),
   OUT v_model_id VARCHAR(36),
   OUT v_model_instance_id VARCHAR(36))
BEGIN
   SELECT m.model_id, i.model_instance_id
    INTO v_model_id,
         v_model_instance_id
    FROM model m,
         model_instance i
    WHERE m.model_id = i.model_id
     AND  m.control_name_uuid = v_control_name_uuid
     AND  i.vm_name = v_vm_name;
  DELETE FROM model_instance
  WHERE model_instance_id = v_model_instance_id;
END;
CREATE PROCEDURE del_all_model_instances
  (IN v_control_name_uuid VARCHAR(36),
   OUT v_model_id VARCHAR(36))
BEGIN
  SELECT m.model_id
    INTO v_model_id
    FROM model m
    WHERE m.control_name_uuid = v_control_name_uuid;
  DELETE FROM model_instance
  WHERE model_id = v_model_id;
END;
CREATE PROCEDURE ins_event
  (IN v_model_name VARCHAR(80),
   IN v_control_name_prefix VARCHAR(80),
   IN v_control_name_uuid VARCHAR(36),
   IN v_user_id VARCHAR(80),
   IN v_action_cd VARCHAR(80),
   IN v_action_state_cd VARCHAR(80),
   IN v_process_instance_id VARCHAR(80),
   OUT v_model_id VARCHAR(36),
   OUT v_event_id VARCHAR(36))
BEGIN
  DECLARE v_prev_event_id VARCHAR(36);
  SELECT m.model_id,
		 m.event_id
    INTO v_model_id,
         v_prev_event_id
    FROM model m
    WHERE m.model_name = v_model_name
	  OR  m.control_name_uuid = v_control_name_uuid;
  SET v_event_id = UUID();
  INSERT INTO event
	(event_id, model_id, action_cd, action_state_cd, prev_event_id, process_instance_id, user_id)
	VALUES (v_event_id, v_model_id, v_action_cd, v_action_state_cd, v_prev_event_id, v_process_instance_id, v_user_id);
  UPDATE model
	SET event_id = v_event_id
	WHERE model_id = v_model_id;
END;
CREATE PROCEDURE upd_event
  (IN v_event_id VARCHAR(36),
   IN v_process_instance_id VARCHAR(80))
BEGIN
  UPDATE event
	SET process_instance_id = v_process_instance_id
	WHERE event_id = v_event_id;
END
//
DELIMITER ;
