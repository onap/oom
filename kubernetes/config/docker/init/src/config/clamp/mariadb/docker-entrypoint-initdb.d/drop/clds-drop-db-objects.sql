#
# Drop CLDS database objects (tables, etc.)
#


ALTER TABLE template
    DROP FOREIGN KEY template_image_id_fkey01;
ALTER TABLE template
    DROP FOREIGN KEY template_bpmn_id_fkey01;
ALTER TABLE template
    DROP FOREIGN KEY template_doc_id_fkey01;

ALTER TABLE model
    DROP FOREIGN KEY template_id_fkey01;
ALTER TABLE model
    DROP FOREIGN KEY model_prop_id_fkey01;
ALTER TABLE model
    DROP FOREIGN KEY model_blueprint_id_fkey01;
ALTER TABLE model
    DROP FOREIGN KEY event_id_fkey01;

DROP TABLE clds_service_cache;

DROP TABLE model_instance;
DROP TABLE model_blueprint;
DROP TABLE model_properties;
DROP TABLE event;
DROP TABLE model;

DROP TABLE template_doc;
DROP TABLE template_image;
DROP TABLE template_bpmn;
DROP TABLE template;
