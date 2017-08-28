SOURCE ../../camunda/mariadb_engine_7.6.0.sql
SOURCE ../../camunda/mariadb_identity_7.6.0.sql

--
-- Create an admin user automatically for the cockpit
--
SOURCE ../../camunda/mysql_create_camunda_admin.sql

--
-- Current Database: `mso_requests`
--

DROP DATABASE IF EXISTS `mso_requests`;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mso_requests` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `mso_requests`;

SOURCE ../../main-schemas/MySQL-Requests-schema.sql
SOURCE ../../sub-sql-files/site_status_updated_timestamp.sql


--
-- Current Database: `mso_catalog`
--

DROP DATABASE IF EXISTS `mso_catalog`;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mso_catalog` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `mso_catalog`;

SOURCE ../../main-schemas/MySQL-Catalog-schema.sql
SOURCE ../../sub-sql-files/catalog_timestamp_mso_db.sql
SOURCE ../../sub-sql-files/catalog_add_constraints.sql

LOCK TABLES `NETWORK_RECIPE` WRITE;
/*!40000 ALTER TABLE `NETWORK_RECIPE` DISABLE KEYS */;
INSERT INTO `NETWORK_RECIPE`(`ID`, `NETWORK_TYPE`, `ACTION`, `VERSION_STR`, `DESCRIPTION`, `ORCHESTRATION_URI`, `NETWORK_PARAM_XSD`, `RECIPE_TIMEOUT`, `SERVICE_TYPE`) VALUES
(1,'CONTRAIL_BASIC','CREATE','1',NULL,'/mso/async/services/CreateNetworkV2',NULL,180,NULL),
(2,'CONTRAIL_BASIC','DELETE','1',NULL,'/mso/async/services/DeleteNetworkV2',NULL,180,NULL),
(3,'CONTRAIL_BASIC','UPDATE','1',NULL,'/mso/async/services/UpdateNetworkV2',NULL,180,NULL),
(4,'CONTRAIL_SHARED','CREATE','1',NULL,'/mso/async/services/CreateNetworkV2',NULL,180,NULL),
(5,'CONTRAIL_SHARED','UPDATE','1',NULL,'/mso/async/services/UpdateNetworkV2',NULL,180,NULL),
(6,'CONTRAIL_SHARED','DELETE','1',NULL,'/mso/async/services/DeleteNetworkV2',NULL,180,NULL),
(7,'CONTRAIL_EXTERNAL','CREATE','1',NULL,'/mso/async/services/CreateNetworkV2',NULL,180,NULL),
(8,'CONTRAIL_EXTERNAL','UPDATE','1',NULL,'/mso/async/services/UpdateNetworkV2',NULL,180,NULL),
(9,'CONTRAIL_EXTERNAL','DELETE','1',NULL,'/mso/async/services/DeleteNetworkV2',NULL,180,NULL);

/*!40000 ALTER TABLE `NETWORK_RECIPE` ENABLE KEYS */;
UNLOCK TABLES;
INSERT INTO `NETWORK_RECIPE`(`NETWORK_TYPE`, `ACTION`, `VERSION_STR`, `DESCRIPTION`, `ORCHESTRATION_URI`, `NETWORK_PARAM_XSD`, `RECIPE_TIMEOUT`, `SERVICE_TYPE`) VALUES
('CONTRAIL30_BASIC','CREATE','1',NULL,'/mso/async/services/CreateNetworkV2',NULL,180,NULL),
('CONTRAIL30_BASIC','UPDATE','1',NULL,'/mso/async/services/UpdateNetworkV2',NULL,180,NULL),
('CONTRAIL30_BASIC','DELETE','1',NULL,'/mso/async/services/DeleteNetworkV2',NULL,180,NULL),
('CONTRAIL30_MPSCE','CREATE','1',NULL,'/mso/async/services/CreateNetworkV2',NULL,180,NULL),
('CONTRAIL30_MPSCE','UPDATE','1',NULL,'/mso/async/services/UpdateNetworkV2',NULL,180,NULL),
('CONTRAIL30_MPSCE','DELETE','1',NULL,'/mso/async/services/DeleteNetworkV2',NULL,180,NULL);


LOCK TABLES `VNF_RECIPE` WRITE;
/*!40000 ALTER TABLE `VNF_RECIPE` DISABLE KEYS */;
INSERT INTO `VNF_RECIPE`(`ID`, `VNF_TYPE`, `VF_MODULE_ID`, `ACTION`, `VERSION_STR`, `DESCRIPTION`, `ORCHESTRATION_URI`, `VNF_PARAM_XSD`, `RECIPE_TIMEOUT`, `SERVICE_TYPE`) VALUES
(1,'*',NULL,'CREATE','1','Recipe Match All for VNFs if no custom flow exists','/mso/workflow/services/CreateGenericVNFV1',NULL,180,NULL),
(2,'*',NULL,'DELETE','1','Recipe Match All for VNFs if no custom flow exists','/mso/async/services//deleteGenericVNFV1',NULL,180,NULL),
(3,'*',NULL,'UPDATE','1','Recipe Match All for VNFs if no custom flow exists','/mso/workflow/services/updateGenericVNFV1',NULL,180,NULL),
(4,NULL,'*','CREATE_VF_MODULE','1','Recipe Match All for VNFs if no custom flow exists','/mso/async/services/CreateVfModule',NULL,180,NULL),
(5,NULL,'*','DELETE_VF_MODULE','1','Recipe Match All for VNFs if no custom flow exists','/mso/async/services/DeleteVfModule',NULL,180,NULL),
(6,NULL,'*','UPDATE_VF_MODULE','1','Recipe Match All for VNFs if no custom flow exists','/mso/async/services/UpdateVfModule',NULL,180,NULL);
/*!40000 ALTER TABLE `VNF_RECIPE` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `VNF_COMPONENTS_RECIPE` WRITE;
/*!40000 ALTER TABLE `VNF_COMPONENTS_RECIPE` DISABLE KEYS */;
INSERT INTO `VNF_COMPONENTS_RECIPE`
(`ID`, `VNF_TYPE`, `VF_MODULE_ID`, `ACTION`, `VERSION`, `DESCRIPTION`, `ORCHESTRATION_URI`,`VNF_COMPONENT_TYPE`, `VNF_COMPONENT_PARAM_XSD`, `RECIPE_TIMEOUT`, `SERVICE_TYPE`) VALUES
(1,'*',NULL,'CREATE','1','Recipe Match All for VF Modules if no custom flow exists','/mso/async/services/createCinderVolumeV1','VOLUME_GROUP',NULL,180,NULL),
(2,'*',NULL,'DELETE','1','Recipe Match All for VF Modules if no custom flow exists','/mso/async/services/deleteCinderVolumeV1','VOLUME_GROUP',NULL,180,NULL),
(3,'*',NULL,'UPDATE','1','Recipe Match All for VF Modules if no custom flow exists','/mso/async/services/updateCinderVolumeV1','VOLUME_GROUP',NULL,180,NULL),
(4,NULL,'*','CREATE_VF_MODULE_VOL','1','Recipe Match All for VF Modules if no custom flow exists','/mso/async/services/CreateVfModuleVolume','VOLUME_GROUP',NULL,180,NULL),
(5,NULL,'*','DELETE_VF_MODULE_VOL','1','Recipe Match All for VF Modules if no custom flow exists','/mso/async/services/DeleteVfModuleVolume','VOLUME_GROUP',NULL,180,NULL),
(6,NULL,'*','UPDATE_VF_MODULE_VOL','1','Recipe Match All for VF Modules if no custom flow exists','/mso/async/services/UpdateVfModuleVolume','VOLUME_GROUP',NULL,180,NULL);
/*!40000 ALTER TABLE `VNF_COMPONENTS_RECIPE` ENABLE KEYS */;
UNLOCK TABLES;

INSERT INTO service (id, SERVICE_NAME, VERSION_STR, DESCRIPTION, SERVICE_NAME_VERSION_ID) VALUES ('4', 'VID_DEFAULT', '1.0', 'Default service for VID to use for infra APIH orchestration', 'MANUAL_RECORD');
INSERT INTO service (id, SERVICE_NAME, VERSION_STR, DESCRIPTION, SERVICE_NAME_VERSION_ID) VALUES ('5', '*', '1.0', 'Default service to use for infra APIH orchestration', 'MANUAL_RECORD');
INSERT INTO service_recipe (SERVICE_ID, ACTION, VERSION_STR, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT) VALUES ('4', 'createInstance', '1', 'VID_DEFAULT recipe to create service-instance if no custom BPMN flow is found', '/mso/async/services/CreateGenericALaCarteServiceInstance', '180');
INSERT INTO service_recipe (SERVICE_ID, ACTION, VERSION_STR, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT) VALUES ('4', 'deleteInstance', '1', 'VID_DEFAULT recipe to delete service-instance if no custom BPMN flow is found', '/mso/async/services/DelServiceInstance', '180');
INSERT INTO service_recipe (SERVICE_ID, ACTION, VERSION_STR, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT) VALUES ('5', 'createInstance', '1', 'DEFAULT recipe to create service-instance if no custom BPMN flow is found', '/mso/async/services/CreateGenericALaCarteServiceInstance', '180');
INSERT INTO service_recipe (SERVICE_ID, ACTION, VERSION_STR, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT) VALUES ('5', 'deleteInstance', '1', 'DEFAULT recipe to delete service-instance if no custom BPMN flow is found', '/mso/async/services/DeleteGenericALaCarteServiceInstance', '180');
INSERT INTO vnf_recipe (VNF_TYPE, ACTION, VERSION_STR, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT) VALUES ('VID_DEFAULT', 'createInstance', '1', 'VID_DEFAULT recipe to create VNF if no custom BPMN flow is found', '/mso/async/services/CreateVnfInfra', '180');
INSERT INTO vnf_recipe (VNF_TYPE, ACTION, VERSION_STR, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT) VALUES ('VID_DEFAULT', 'deleteInstance', '1', 'VID_DEFAULT recipe to delete VNF if no custom BPMN flow is found', '/mso/async/services/DeleteVnfInfra', '180');
INSERT INTO vnf_components_recipe (VNF_TYPE, VNF_COMPONENT_TYPE, ACTION, VERSION, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT, VF_MODULE_ID) VALUES (NULL, 'volumeGroup', 'createInstance', '1', 'VID_DEFAULT recipe to create volume-group if no custom BPMN flow is found', '/mso/async/services/CreateVfModuleVolumeInfraV1', '180', 'VID_DEFAULT');
INSERT INTO vnf_components_recipe (VNF_TYPE, VNF_COMPONENT_TYPE, ACTION, VERSION, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT, VF_MODULE_ID) VALUES (NULL, 'volumeGroup', 'deleteInstance', '1', 'VID_DEFAULT recipe to delete volume-group if no custom BPMN flow is found', '/mso/async/services/DeleteVfModuleVolumeInfraV1', '180', 'VID_DEFAULT');
INSERT INTO vnf_components_recipe (VNF_TYPE, VNF_COMPONENT_TYPE, ACTION, VERSION, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT, VF_MODULE_ID) VALUES (NULL, 'volumeGroup', 'updateInstance', '1', 'VID_DEFAULT recipe to update volume-group if no custom BPMN flow is found', '/mso/async/services/UpdateVfModuleVolumeInfraV1', '180', 'VID_DEFAULT');
INSERT INTO vnf_components_recipe (VNF_COMPONENT_TYPE, ACTION, VERSION, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT, VF_MODULE_ID) VALUES ('vfModule', 'createInstance', '1', 'VID_DEFAULT recipe to create vf-module if no custom BPMN flow is found', '/mso/async/services/CreateVfModuleInfra', '180', 'VID_DEFAULT');
INSERT INTO vnf_components_recipe (VNF_COMPONENT_TYPE, ACTION, VERSION, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT, VF_MODULE_ID) VALUES ('vfModule', 'deleteInstance', '1', 'VID_DEFAULT recipe to delete vf-module if no custom BPMN flow is found', '/mso/async/services/DeleteVfModuleInfra', '180', 'VID_DEFAULT');
INSERT INTO vnf_components_recipe (VNF_COMPONENT_TYPE, ACTION, VERSION, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT, VF_MODULE_ID) VALUES ('vfModule', 'updateInstance', '1', 'VID_DEFAULT recipe to update vf-module if no custom BPMN flow is found', '/mso/async/services/UpdateVfModuleInfra', '180', 'VID_DEFAULT');
INSERT INTO network_recipe (NETWORK_TYPE, ACTION, VERSION_STR, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT) VALUES ('VID_DEFAULT', 'createInstance', '1.0', 'VID_DEFAULT recipe to create network if no custom BPMN flow is found', '/mso/async/services/CreateNetworkInstance', '180');
INSERT INTO network_recipe (NETWORK_TYPE, ACTION, VERSION_STR, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT) VALUES ('VID_DEFAULT', 'updateInstance', '1.0', 'VID_DEFAULT recipe to update network if no custom BPMN flow is found', '/mso/async/services/UpdateNetworkInstance', '180');
INSERT INTO network_recipe (NETWORK_TYPE, ACTION, VERSION_STR, DESCRIPTION, ORCHESTRATION_URI, RECIPE_TIMEOUT) VALUES ('VID_DEFAULT', 'deleteInstance', '1.0', 'VID_DEFAULT recipe to delete network if no custom BPMN flow is found', '/mso/async/services/DeleteNetworkInstance', '180');
