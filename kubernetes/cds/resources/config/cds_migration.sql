
SET FOREIGN_KEY_CHECKS=0;

--
-- table BLUEPRINT_CONTENT_RUNTIME
--

DROP TABLE IF EXISTS `BLUEPRINT_CONTENT_RUNTIME`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BLUEPRINT_CONTENT_RUNTIME` (
  `blueprint_content_runtime_id` varchar(255) NOT NULL,
  `content` longblob NOT NULL,
  `content_type` varchar(255) NOT NULL,
  `updated_date` datetime DEFAULT NULL,
  `description` longtext,
  `name` varchar(255) NOT NULL,
  `blueprint_runtime_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`blueprint_content_runtime_id`),
  KEY `FKg3p6ca9ab6rd2e1l96s21l0e9` (`blueprint_runtime_id`),
  CONSTRAINT `FKg3p6ca9ab6rd2e1l96s21l0e9` FOREIGN KEY (`blueprint_runtime_id`) REFERENCES `BLUEPRINT_RUNTIME` (`blueprint_runtime_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `BLUEPRINT_CONTENT_RUNTIME` WRITE;
/*!40000 ALTER TABLE `BLUEPRINT_CONTENT_RUNTIME` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLUEPRINT_CONTENT_RUNTIME` ENABLE KEYS */;
UNLOCK TABLES;

--
-- table BLUEPRINT_RUNTIME
--

DROP TABLE IF EXISTS `BLUEPRINT_RUNTIME`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BLUEPRINT_RUNTIME` (
  `blueprint_runtime_id` varchar(255) NOT NULL,
  `artifact_description` longtext,
  `artifact_name` varchar(255) NOT NULL,
  `artifact_type` varchar(255) DEFAULT NULL,
  `artifact_version` varchar(255) NOT NULL,
  `creation_date` datetime DEFAULT NULL,
  `tags` longtext NOT NULL,
  `updated_by` varchar(255) NOT NULL,
  PRIMARY KEY (`blueprint_runtime_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `BLUEPRINT_RUNTIME` WRITE;
/*!40000 ALTER TABLE `BLUEPRINT_RUNTIME` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLUEPRINT_RUNTIME` ENABLE KEYS */;
UNLOCK TABLES;

--
-- table CONFIG_MODEL
--

ALTER TABLE `CONFIG_MODEL_CONTENT` 
DROP  FOREIGN KEY `FKnsij8yv7crk20bsr57ehwshe1`;

ALTER TABLE `CONFIG_MODEL`
MODIFY COLUMN `config_model_id` varchar(255) NOT NULL,
ADD UNIQUE KEY `UKbhw5m1u2ns28uxvtr8kdxcphk` (`artifact_name`,`artifact_version`),
ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- table CONFIG_MODEL_CONTENT
--

ALTER TABLE CONFIG_MODEL_CONTENT
MODIFY COLUMN `config_model_content_id` varchar(255) NOT NULL,
MODIFY COLUMN `content` longblob NOT NULL,
MODIFY COLUMN `config_model_id` varchar(255) DEFAULT NULL,
ADD CONSTRAINT `FKnsij8yv7crk20bsr57ehwshe1` FOREIGN KEY (`config_model_id`) REFERENCES `CONFIG_MODEL` (`config_model_id`),
ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- table RESOURCE_RESOLUTION_RESULT
--

DROP TABLE IF EXISTS `RESOURCE_RESOLUTION_RESULT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RESOURCE_RESOLUTION_RESULT` (
  `resource_resolution_result_id` varchar(255) NOT NULL,
  `artifact_name` varchar(255) NOT NULL,
  `blueprint_name` varchar(255) NOT NULL,
  `blueprint_version` varchar(255) NOT NULL,
  `creation_date` datetime DEFAULT NULL,
  `resolution_key` varchar(255) NOT NULL,
  `result` longtext NOT NULL,
  PRIMARY KEY (`resource_resolution_result_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `RESOURCE_RESOLUTION_RESULT` WRITE;
/*!40000 ALTER TABLE `RESOURCE_RESOLUTION_RESULT` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_RESOLUTION_RESULT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- table MODEL_TYPE
--

INSERT into `MODEL_TYPE` Values('artifact-dictionary-resource','2019-05-02 04:30:57.286000','{\n  \"description\" : \"Resource Dictionary File used along with Configuration template\",\n  \"version\" : \"1.0.0\",\n  \"file_ext\" : [ \"json\" ],\n  \"derived_from\" : \"tosca.artifacts.Implementation\"\n}','artifact_type','tosca.artifacts.Implementation','Resource Dictionary File used along with Configuration template','artifact-dictionary-resource,tosca.artifacts.Implementation,artifact_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('artifact-script-ansible','2019-05-02 04:30:57.266000','{\n  \"description\" : \"Ansible Script file\",\n  \"version\" : \"1.0.0\",\n  \"file_ext\" : [ \"yaml\" ],\n  \"derived_from\" : \"tosca.artifacts.Implementation\"\n}','artifact_type','tosca.artifacts.Implementation','Ansible Script file','artifact-script-ansible,tosca.artifacts.Implementation,artifact_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('artifact-script-jython','2019-05-02 04:30:57.298000','{\n  \"description\" : \"Jython Script File\",\n  \"version\" : \"1.0.0\",\n  \"file_ext\" : [ \"py\" ],\n  \"derived_from\" : \"tosca.artifacts.Implementation\"\n}','artifact_type','tosca.artifacts.Implementation','Jython Script File','artifact-script-jython,tosca.artifacts.Implementation,artifact_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('artifact-script-kotlin','2019-05-02 04:30:57.272000','{\n  \"description\" : \"Kotlin Script file\",\n  \"version\" : \"1.0.0\",\n  \"file_ext\" : [ \"kts\" ],\n  \"derived_from\" : \"tosca.artifacts.Implementation\"\n}','artifact_type','tosca.artifacts.Implementation','Kotlin Script file','artifact-script-kotlin,tosca.artifacts.Implementation,artifact_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('artifact-template-jinja','2019-05-02 04:30:57.326000','{\n  \"description\" : \" Jinja Template used for Configuration\",\n  \"version\" : \"1.0.0\",\n  \"file_ext\" : [ \"jinja\" ],\n  \"derived_from\" : \"tosca.artifacts.Implementation\"\n}','artifact_type','tosca.artifacts.Implementation',' Jinja Template used for Configuration','artifact-template-jinja,tosca.artifacts.Implementation,artifact_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('component-jython-executor','2019-05-02 04:30:57.495000','{\n  \"description\" : \"This is Jython Execution Component.\",\n  \"version\" : \"1.0.0\",\n  \"capabilities\" : {\n    \"component-node\" : {\n      \"type\" : \"tosca.capabilities.Node\"\n    }\n  },\n  \"interfaces\" : {\n    \"ComponentJythonExecutor\" : {\n      \"operations\" : {\n        \"process\" : {\n          \"inputs\" : {\n            \"instance-dependencies\" : {\n              \"required\" : true,\n              \"description\" : \"Instance Names to Inject to Jython Script.\",\n              \"type\" : \"list\",\n              \"entry_schema\" : {\n                \"type\" : \"string\"\n              }\n            },\n            \"dynamic-properties\" : {\n              \"description\" : \"Dynamic Json Content or DSL Json reference.\",\n              \"required\" : false,\n              \"type\" : \"json\"\n            }\n          },\n          \"outputs\" : {\n            \"response-data\" : {\n              \"description\" : \"Execution Response Data in JSON format.\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"status\" : {\n              \"description\" : \"Status of the Component Execution ( success or failure )\",\n              \"required\" : true,\n              \"type\" : \"string\"\n            }\n          }\n        }\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.Component\"\n}','node_type','tosca.nodes.Component','This is Jython Execution Component.','component-jython-executor,tosca.nodes.Component,node_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('component-remote-python-executor','2019-05-02 04:30:57.576000','{\n  \"description\" : \"This is Remote Python Execution Component.\",\n  \"version\" : \"1.0.0\",\n  \"attributes\" : {\n    \"prepare-environment-logs\" : {\n      \"required\" : false,\n      \"type\" : \"string\"\n    },\n    \"execute-command-logs\" : {\n      \"required\" : false,\n      \"type\" : \"string\"\n    }\n  },\n  \"capabilities\" : {\n    \"component-node\" : {\n      \"type\" : \"tosca.capabilities.Node\"\n    }\n  },\n  \"interfaces\" : {\n    \"ComponentRemotePythonExecutor\" : {\n      \"operations\" : {\n        \"process\" : {\n          \"inputs\" : {\n            \"endpoint-selector\" : {\n              \"description\" : \"Remote Container or Server selector name.\",\n              \"required\" : false,\n              \"type\" : \"string\",\n              \"default\" : \"remote-python\"\n            },\n            \"dynamic-properties\" : {\n              \"description\" : \"Dynamic Json Content or DSL Json reference.\",\n              \"required\" : false,\n              \"type\" : \"json\"\n            },\n            \"argument-properties\" : {\n              \"description\" : \"Argument Json Content or DSL Json reference.\",\n              \"required\" : false,\n              \"type\" : \"json\"\n            },\n            \"command\" : {\n              \"description\" : \"Command to execute.\",\n              \"required\" : true,\n              \"type\" : \"string\"\n            },\n            \"packages\" : {\n              \"description\" : \"Packages to install based on type.\",\n              \"required\" : false,\n              \"type\" : \"list\",\n              \"entry_schema\" : {\n                \"type\" : \"dt-system-packages\"\n              }\n            }\n          }\n        }\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.Component\"\n}','node_type','tosca.nodes.Component','This is Remote Python Execution Component.','component-remote-python-executor,tosca.nodes.Component,node_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('component-resource-resolution','2019-05-02 04:30:57.545000','{\n  \"description\" : \"This is Resource Assignment Component API\",\n  \"version\" : \"1.0.0\",\n  \"attributes\" : {\n    \"assignment-params\" : {\n      \"required\" : true,\n      \"type\" : \"string\"\n    }\n  },\n  \"capabilities\" : {\n    \"component-node\" : {\n      \"type\" : \"tosca.capabilities.Node\"\n    }\n  },\n  \"interfaces\" : {\n    \"ResourceResolutionComponent\" : {\n      \"operations\" : {\n        \"process\" : {\n          \"inputs\" : {\n            \"resolution-key\" : {\n              \"description\" : \"Key for service instance related correlation.\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"store-result\" : {\n              \"description\" : \"Whether or not to store the output.\",\n              \"required\" : false,\n              \"type\" : \"boolean\"\n            },\n            \"resource-type\" : {\n              \"description\" : \"Request type.\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"artifact-prefix-names\" : {\n              \"required\" : true,\n              \"description\" : \"Template , Resource Assignment Artifact Prefix names\",\n              \"type\" : \"list\",\n              \"entry_schema\" : {\n                \"type\" : \"string\"\n              }\n            },\n            \"request-id\" : {\n              \"description\" : \"Request Id, Unique Id for the request.\",\n              \"required\" : true,\n              \"type\" : \"string\"\n            },\n            \"resource-id\" : {\n              \"description\" : \"Resource Id.\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"action-name\" : {\n              \"description\" : \"Action Name of the process\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"dynamic-properties\" : {\n              \"description\" : \"Dynamic Json Content or DSL Json reference.\",\n              \"required\" : false,\n              \"type\" : \"json\"\n            }\n          },\n          \"outputs\" : {\n            \"resource-assignment-params\" : {\n              \"required\" : true,\n              \"type\" : \"string\"\n            },\n            \"status\" : {\n              \"required\" : true,\n              \"type\" : \"string\"\n            }\n          }\n        }\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.Component\"\n}','node_type','tosca.nodes.Component','This is Resource Assignment Component API','component-resource-resolution,tosca.nodes.Component,node_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('component-restconf-executor','2019-05-02 04:30:57.464000','{\n  \"description\" : \"This is Restconf Transaction Configuration Component API\",\n  \"version\" : \"1.0.0\",\n  \"capabilities\" : {\n    \"component-node\" : {\n      \"type\" : \"tosca.capabilities.Node\"\n    }\n  },\n  \"interfaces\" : {\n    \"ComponentRestconfExecutor\" : {\n      \"operations\" : {\n        \"process\" : {\n          \"inputs\" : {\n            \"script-type\" : {\n              \"description\" : \"Script type, kotlin type is supported\",\n              \"required\" : true,\n              \"type\" : \"string\",\n              \"default\" : \"internal\",\n              \"constraints\" : [ {\n                \"valid_values\" : [ \"kotlin\", \"jython\", \"internal\" ]\n              } ]\n            },\n            \"script-class-reference\" : {\n              \"description\" : \"Kotlin Script class name or jython script name.\",\n              \"required\" : true,\n              \"type\" : \"string\"\n            },\n            \"instance-dependencies\" : {\n              \"required\" : true,\n              \"description\" : \"Instance names to inject to Jython or Kotlin Script.\",\n              \"type\" : \"list\",\n              \"entry_schema\" : {\n                \"type\" : \"string\"\n              }\n            },\n            \"dynamic-properties\" : {\n              \"description\" : \"Dynamic Json Content or DSL Json reference.\",\n              \"required\" : false,\n              \"type\" : \"json\"\n            }\n          },\n          \"outputs\" : {\n            \"response-data\" : {\n              \"description\" : \"Execution Response Data in JSON format.\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"status\" : {\n              \"description\" : \"Status of the Component Execution ( success or failure )\",\n              \"required\" : true,\n              \"type\" : \"string\"\n            }\n          }\n        }\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.Component\"\n}','node_type','tosca.nodes.Component','This is Restconf Transaction Configuration Component API','component-restconf-executor,tosca.nodes.Component,node_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('dg-generic','2019-05-02 04:30:57.448000','{\n  \"description\" : \"This is Generic Directed Graph Type\",\n  \"version\" : \"1.0.0\",\n  \"properties\" : {\n    \"content\" : {\n      \"required\" : true,\n      \"type\" : \"string\"\n    },\n    \"dependency-node-templates\" : {\n      \"required\" : true,\n      \"description\" : \"Dependent Step Components NodeTemplate name.\",\n      \"type\" : \"list\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.Workflow\"\n}','node_type','tosca.nodes.Workflow','This is Generic Directed Graph Type','dg-generic,tosca.nodes.Workflow,node_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('dt-netbox-ip','2019-05-02 04:30:57.105000','{\n  \"version\" : \"1.0.0\",\n  \"description\" : \"This is Netbox IP Data Type\",\n  \"properties\" : {\n    \"address\" : {\n      \"required\" : true,\n      \"type\" : \"string\"\n    },\n    \"id\" : {\n      \"required\" : true,\n      \"type\" : \"integer\"\n    }\n  },\n  \"derived_from\" : \"tosca.datatypes.Root\"\n}','data_type','tosca.datatypes.Root','This is Netbox IP Data Type','dt-netbox-ip,tosca.datatypes.Root,data_type','System','1.0.0');


INSERT into `MODEL_TYPE` Values('dt-system-packages','2019-05-02 04:30:57.136000','{\n  \"description\" : \"This represent System Package Data Type\",\n  \"version\" : \"1.0.0\",\n  \"properties\" : {\n    \"type\" : {\n      \"required\" : true,\n      \"type\" : \"string\",\n      \"constraints\" : [ {\n        \"valid_values\" : [ \"ansible_galaxy\", \"pip\" ]\n      } ]\n    },\n    \"package\" : {\n      \"required\" : true,\n      \"type\" : \"list\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.datatypes.Root\"\n}','data_type','tosca.datatypes.Root','This represent System Package Data Type','dt-system-packages,tosca.datatypes.Root,data_type','System','1.0.0');


INSERT into `MODEL_TYPE` Values('source-capability','2019-05-02 04:30:57.502000','{\n  \"description\" : \"This is Component Resource Source Node Type\",\n  \"version\" : \"1.0.0\",\n  \"properties\" : {\n    \"script-type\" : {\n      \"required\" : true,\n      \"type\" : \"string\",\n      \"default\" : \"kotlin\",\n      \"constraints\" : [ {\n        \"valid_values\" : [ \"kotlin\", \"internal\", \"jython\" ]\n      } ]\n    },\n    \"script-class-reference\" : {\n      \"description\" : \"Capability reference name for internal and kotlin, for jython script file path\",\n      \"required\" : true,\n      \"type\" : \"string\"\n    },\n    \"instance-dependencies\" : {\n      \"required\" : false,\n      \"description\" : \"Instance dependency Names to Inject to Kotlin / Jython Script.\",\n      \"type\" : \"list\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    },\n    \"key-dependencies\" : {\n      \"description\" : \"Resource Resolution dependency dictionary names.\",\n      \"required\" : true,\n      \"type\" : \"list\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.ResourceSource\"\n}','node_type','tosca.nodes.ResourceSource','This is Component Resource Source Node Type','source-capability,tosca.nodes.ResourceSource,node_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('source-primary-db','2019-05-02 04:30:57.519000','{\n  \"description\" : \"This is Database Resource Source Node Type\",\n  \"version\" : \"1.0.0\",\n  \"properties\" : {\n    \"type\" : {\n      \"required\" : true,\n      \"default\" : \"SQL\",\n      \"type\" : \"string\",\n      \"constraints\" : [ {\n        \"valid_values\" : [ \"SQL\" ]\n      } ]\n    },\n    \"endpoint-selector\" : {\n      \"required\" : false,\n      \"type\" : \"string\"\n    },\n    \"query\" : {\n      \"required\" : true,\n      \"type\" : \"string\"\n    },\n    \"input-key-mapping\" : {\n      \"required\" : false,\n      \"type\" : \"map\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    },\n    \"output-key-mapping\" : {\n      \"required\" : false,\n      \"type\" : \"map\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    },\n    \"key-dependencies\" : {\n      \"required\" : true,\n      \"type\" : \"list\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.ResourceSource\"\n}','node_type','tosca.nodes.ResourceSource','This is Database Resource Source Node Type','source-primary-db,tosca.nodes.ResourceSource,node_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('source-processor-db','2019-05-02 04:30:57.713000','{\n  \"description\" : \"This is Database Resource Source Node Type\",\n  \"version\" : \"1.0.0\",\n  \"properties\" : {\n    \"type\" : {\n      \"required\" : true,\n      \"type\" : \"string\",\n      \"constraints\" : [ {\n        \"valid_values\" : [ \"SQL\", \"PLSQL\" ]\n      } ]\n    },\n    \"endpoint-selector\" : {\n      \"required\" : false,\n      \"type\" : \"string\"\n    },\n    \"query\" : {\n      \"required\" : true,\n      \"type\" : \"string\"\n    },\n    \"input-key-mapping\" : {\n      \"required\" : false,\n      \"type\" : \"map\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    },\n    \"output-key-mapping\" : {\n      \"required\" : false,\n      \"type\" : \"map\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    },\n    \"key-dependencies\" : {\n      \"required\" : true,\n      \"type\" : \"list\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.ResourceSource\"\n}','node_type','tosca.nodes.ResourceSource','This is Database Resource Source Node Type','source-processor-db,tosca.nodes.ResourceSource,node_type','System','1.0.0');



INSERT into `MODEL_TYPE` Values('tosca.nodes.Workflow','2019-05-02 04:30:57.677000','{\n  \"description\" : \"This is Directed Graph Node Type\",\n  \"version\" : \"1.0.0\",\n  \"derived_from\" : \"tosca.nodes.Root\"\n}','node_type','tosca.nodes.Root','This is Directed Graph Node Type','tosca.nodes.Workflow,tosca.nodes.Root,node_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('tosca.relationships.AttachesTo','2019-05-02 04:30:57.407000','{\n  \"description\" : \"Relationship tosca.relationships.AttachesTo\",\n  \"version\" : \"1.0.0\",\n  \"derived_from\" : \"tosca.relationships.Root\"\n}','relationship_type','tosca.relationships.Root','Relationship tosca.relationships.AttachesTo','tosca.relationships.AttachesTo,tosca.relationships.Root,relationship_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('tosca.relationships.ConnectsTo','2019-05-02 04:30:57.414000','{\n  \"description\" : \"Relationship tosca.relationships.ConnectsTo\",\n  \"version\" : \"1.0.0\",\n  \"derived_from\" : \"tosca.relationships.Root\"\n}','relationship_type','tosca.relationships.Root','Relationship tosca.relationships.ConnectsTo','tosca.relationships.ConnectsTo,tosca.relationships.Root,relationship_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('tosca.relationships.DependsOn','2019-05-02 04:30:57.421000','{\n  \"description\" : \"Relationship tosca.relationships.DependsOn\",\n  \"version\" : \"1.0.0\",\n  \"derived_from\" : \"tosca.relationships.Root\"\n}','relationship_type','tosca.relationships.Root','Relationship tosca.relationships.DependsOn','tosca.relationships.DependsOn,tosca.relationships.Root,relationship_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('tosca.relationships.HostedOn','2019-05-02 04:30:57.391000','{\n  \"description\" : \"Relationship tosca.relationships.HostedOn\",\n  \"version\" : \"1.0.0\",\n  \"derived_from\" : \"tosca.relationships.Root\"\n}','relationship_type','tosca.relationships.Root','Relationship tosca.relationships.HostedOn','tosca.relationships.HostedOn,tosca.relationships.Root,relationship_type','System','1.0.0');

INSERT into `MODEL_TYPE` Values('tosca.relationships.RoutesTo','2019-05-02 04:30:57.401000','{\n  \"description\" : \"Relationship tosca.relationships.RoutesTo\",\n  \"version\" : \"1.0.0\",\n  \"derived_from\" : \"tosca.relationships.Root\"\n}','relationship_type','tosca.relationships.Root','Relationship tosca.relationships.RoutesTo','tosca.relationships.RoutesTo,tosca.relationships.Root,relationship_type','System','1.0.0');


UPDATE `MODEL_TYPE` 
SET definition = '{\n  \"description\" : \"This is VNF Device with Netconf  Capability\",\n  \"version\" : \"1.0.0\",\n  \"capabilities\" : {\n    \"netconf\" : {\n      \"type\" : \"tosca.capabilities.Netconf\",\n      \"properties\" : {\n        \"login-key\" : {\n          \"required\" : true,\n          \"type\" : \"string\",\n          \"default\" : \"sdnc\"\n        },\n        \"login-account\" : {\n          \"required\" : true,\n          \"type\" : \"string\",\n          \"default\" : \"sdnc-tacacs\"\n        },\n        \"source\" : {\n          \"required\" : true,\n          \"type\" : \"string\",\n          \"default\" : \"npm\"\n        },\n        \"target-ip-address\" : {\n          \"required\" : true,\n          \"type\" : \"string\"\n        },\n        \"port-number\" : {\n          \"required\" : true,\n          \"type\" : \"integer\",\n          \"default\" : 830\n        },\n        \"connection-time-out\" : {\n          \"required\" : false,\n          \"type\" : \"integer\",\n          \"default\" : 30\n        }\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.Vnf\"\n}'
WHERE model_name = 'vnf-netconf-device';
	
UPDATE `MODEL_TYPE` 
SET definition = '{\n  \"description\" : \"This is Rest Resource Source Node Type\",\n  \"version\" : \"1.0.0\",\n  \"properties\" : {\n    \"type\" : {\n      \"required\" : true,\n      \"type\" : \"string\",\n      \"default\" : \"JSON\",\n      \"constraints\" : [ {\n        \"valid_values\" : [ \"JSON\" ]\n      } ]\n    },\n    \"verb\" : {\n      \"required\" : true,\n      \"type\" : \"string\",\n      \"default\" : \"GET\",\n      \"constraints\" : [ {\n        \"valid_values\" : [ \"GET\", \"POST\", \"DELETE\", \"PUT\" ]\n      } ]\n    },\n    \"payload\" : {\n      \"required\" : false,\n      \"type\" : \"string\",\n      \"default\" : \"\"\n    },\n    \"endpoint-selector\" : {\n      \"required\" : false,\n      \"type\" : \"string\"\n    },\n    \"url-path\" : {\n      \"required\" : true,\n      \"type\" : \"string\"\n    },\n    \"path\" : {\n      \"required\" : true,\n      \"type\" : \"string\"\n    },\n    \"expression-type\" : {\n      \"required\" : false,\n      \"type\" : \"string\",\n      \"default\" : \"JSON_PATH\",\n      \"constraints\" : [ {\n        \"valid_values\" : [ \"JSON_PATH\", \"JSON_POINTER\" ]\n      } ]\n    },\n    \"input-key-mapping\" : {\n      \"required\" : false,\n      \"type\" : \"map\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    },\n    \"output-key-mapping\" : {\n      \"required\" : false,\n      \"type\" : \"map\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    },\n    \"key-dependencies\" : {\n      \"required\" : true,\n      \"type\" : \"list\",\n      \"entry_schema\" : {\n        \"type\" : \"string\"\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.ResourceSource\"\n}'
WHERE model_name = 'source-rest';
	
UPDATE `MODEL_TYPE` 
SET definition = '{\n  \"description\" : \"This is Input Resource Source Node Type\",\n  \"version\" : \"1.0.0\",\n  \"properties\" : { },\n  \"derived_from\" : \"tosca.nodes.ResourceSource\"\n}'
WHERE model_name = 'source-input';
	
	
UPDATE `MODEL_TYPE` 
SET definition = '{\n  \"description\" : \"This is Default Resource Source Node Type\",\n  \"version\" : \"1.0.0\",\n  \"properties\" : { },\n  \"derived_from\" : \"tosca.nodes.ResourceSource\"\n}'
WHERE model_name = 'source-default';
	
UPDATE `MODEL_TYPE` 
SET definition = '{\n  \"description\" : \"This is Netconf Transaction Configuration Component API\",\n  \"version\" : \"1.0.0\",\n  \"capabilities\" : {\n    \"component-node\" : {\n      \"type\" : \"tosca.capabilities.Node\"\n    }\n  },\n  \"requirements\" : {\n    \"netconf-connection\" : {\n      \"capability\" : \"netconf\",\n      \"node\" : \"vnf-netconf-device\",\n      \"relationship\" : \"tosca.relationships.ConnectsTo\"\n    }\n  },\n  \"interfaces\" : {\n    \"org-openecomp-sdnc-netconf-adaptor-service-NetconfExecutorNode\" : {\n      \"operations\" : {\n        \"process\" : {\n          \"inputs\" : {\n            \"request-id\" : {\n              \"description\" : \"Request Id used to store the generated configuration, in the database along with the template-name\",\n              \"required\" : true,\n              \"type\" : \"string\"\n            },\n            \"template-name\" : {\n              \"description\" : \"Service Template Name\",\n              \"required\" : true,\n              \"type\" : \"string\"\n            },\n            \"template-version\" : {\n              \"description\" : \"Service Template Version\",\n              \"required\" : true,\n              \"type\" : \"string\"\n            },\n            \"action-name\" : {\n              \"description\" : \"Action Name to get from Database, Either (message & mask-info ) or ( resource-id & resource-type & action-name & template-name ) should be present. Message will be given higest priority\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"resource-type\" : {\n              \"description\" : \"Resource Type to get from Database, Either (message & mask-info ) or( resource-id & resource-type & action-name & template-name ) should be present. Message will be given higest priority\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"resource-id\" : {\n              \"description\" : \"Resource Id to get from Database, Either (message & mask-info ) or ( resource-id & resource-type & action-name & template-name ) should be present. Message will be given higest priority\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"reservation-id\" : {\n              \"description\" : \"Reservation Id used to send to NPM\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"execution-script\" : {\n              \"description\" : \"Python Script to Execute for this Component action, It should refer any one of Prython Artifact Definition for this Node Template.\",\n              \"required\" : true,\n              \"type\" : \"string\"\n            }\n          },\n          \"outputs\" : {\n            \"response-data\" : {\n              \"description\" : \"Execution Response Data in JSON format.\",\n              \"required\" : false,\n              \"type\" : \"string\"\n            },\n            \"status\" : {\n              \"description\" : \"Status of the Component Execution ( success or failure )\",\n              \"required\" : true,\n              \"type\" : \"string\"\n            }\n          }\n        }\n      }\n    }\n  },\n  \"derived_from\" : \"tosca.nodes.Component\"\n}'
WHERE model_name = 'component-netconf-executor';
	
UPDATE `MODEL_TYPE` 
SET definition = '{\n  \"description\" : \"Python Script file\",\n  \"version\" : \"1.0.0\",\n  \"file_ext\" : [ \"py\" ],\n  \"derived_from\" : \"tosca.artifacts.Implementation\"\n}'
WHERE model_name = 'artifact-script-python';
	
	
UPDATE `MODEL_TYPE` 
SET description = 'Python Script file'
WHERE model_name = 'artifact-script-python';
	
	
UPDATE `MODEL_TYPE` 
SET description = 'Resource Mapping File used along with Configuration template'
WHERE model_name = 'artifact-mapping-resource';


--
-- table RESOURCE_DICTIONARY
--


INSERT into `RESOURCE_DICTIONARY` Values('hostname','2019-05-02 04:30:58.724000','string','{\"tags\":\"hostname\",\"name\":\"hostname\",\"property\":{\"description\":\"hostname\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\"}}}','hostname',NULL,'hostname','Singal, Kapil <ks220y@att.com>');

INSERT into `RESOURCE_DICTIONARY` Values('pnf-id','2019-05-02 04:30:57.925000','string','{\"tags\":\"pnf-id\",\"name\":\"pnf-id\",\"property\":{\"description\":\"pnf-id\",\"type\":\"string\"},\"updated-by\":\"Rodrigo Ottero <rodrigo.ottero@est.tech>\",\"sources\":{\"input\":{\"type\":\"source-input\",\"properties\":{}}}}','pnf-id',NULL,'pnf-id','Rodrigo Ottero <rodrigo.ottero@est.tech>');

INSERT into `RESOURCE_DICTIONARY` Values('pnf-ipv4-address','2019-05-02 04:30:58.263000','string','{\"tags\":\"pnf-ipv4-address\",\"name\":\"pnf-ipv4-address\",\"property\":{\"description\":\"pnf-ipv4-address\",\"type\":\"string\"},\"updated-by\":\"Rodrigo Ottero <rodrigo.ottero@est.tech>\",\"sources\":{\"input\":{\"type\":\"source-input\",\"properties\":{}}}}','pnf-ipv4-address',NULL,'pnf-ipv4-address','Rodrigo Ottero <rodrigo.ottero@est.tech>');

INSERT into `RESOURCE_DICTIONARY` Values('pnf-name','2019-05-02 04:30:58.910000','string','{\"tags\":\"pnf-name\",\"name\":\"pnf-name\",\"property\":{\"description\":\"pnf-name\",\"type\":\"string\"},\"updated-by\":\"Rodrigo Ottero <rodrigo.ottero@est.tech>\",\"sources\":{\"input\":{\"type\":\"source-input\",\"properties\":{}}}}','pnf-name',NULL,'pnf-name','Rodrigo Ottero <rodrigo.ottero@est.tech>');

INSERT into `RESOURCE_DICTIONARY` Values('processor-db-source','2019-05-02 04:30:58.643000','string','{\"tags\":\"bundle-id, brindasanth@onap.com\",\"name\":\"processor-db-source\",\"property\":{\"description\":\"name of the \",\"type\":\"string\"},\"updated-by\":\"brindasanth@onap.com\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"query\":\"SELECT db-country, db-state FROM DEVICE_PROFILE WHERE profile_name = :profile_name\",\"input-key-mapping\":{\"profile_name\":\"profile_name\"},\"output-key-mapping\":{\"db-country\":\"country\",\"db-state\":\"state\"}}}}}','name of the ',NULL,'bundle-id, brindasanth@onap.com','brindasanth@onap.com');


UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"vsn_private_ip_0\",\"name\":\"vsn_private_ip_0\",\"property\":{\"description\":\"vsn_private_ip_0\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\",\"properties\":{}},\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/vsn_private_ip_0\",\"path\":\"/param/0/value\",\"expression-type\":\"JSON_POINTER\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"vsn_private_ip_0\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'vsn_private_ip_0';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = 
'{\"tags\":\"vpg_private_ip_0\",\"name\":\"vpg_private_ip_0\",\"property\":{\"description\":\"vpg_private_ip_0\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\",\"properties\":{}},\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/vpg_private_ip_0\",\"path\":\"/param/0/value\",\"expression-type\":\"JSON_POINTER\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"vpg_private_ip_0\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'vpg_private_ip_0';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"vnf_name\",\"name\":\"vnf_name\",\"property\":{\"description\":\"vnf_name\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"default\":{\"type\":\"source-default\",\"properties\":{}},\"input\":{\"type\":\"source-input\",\"properties\":{}},\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/vnf_name\",\"path\":\"/param/0/value\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"vnf_name\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'vnf_name';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"vnfc-model-version\",\"name\":\"vnfc-model-version\",\"property\":{\"description\":\"vnfc-model-version for  SRIOV VPE template\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select VFC_MODEL.version as vnfc_model_version from VFC_MODEL where customization_uuid=:vfccustomizationuuid\",\"input-key-mapping\":{\"vfccustomizationuuid\":\"vfccustomizationuuid\"},\"output-key-mapping\":{\"vnfc-model-version\":\"vnfc_model_version\"},\"key-dependencies\":[\"vfccustomizationuuid\"]}}}}'
WHERE name = 'vnfc-model-version';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"vnfc-model-invariant-uuid\",\"name\":\"vnfc-model-invariant-uuid\",\"property\":{\"description\":\"vnfc-model-invariant-uuid for SRIOV VPE template\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select VFC_MODEL.invariant_uuid as vfc_invariant_uuid from VFC_MODEL where customization_uuid=:vfccustomizationuuid\",\"input-key-mapping\":{\"vfccustomizationuuid\":\"vfccustomizationuuid\"},\"output-key-mapping\":{\"vnfc-model-invariant-uuid\":\"vfc_invariant_uuid\"},\"key-dependencies\":[\"vfccustomizationuuid\"]}}}}'
WHERE name = 'vnfc-model-invariant-uuid';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"vnf-name, tosca.datatypes.Root, data_type\",\"name\":\"vnf-name\",\"property\":{\"description\":\"vnf-name\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/vnf_name\",\"path\":\"/param/0/value\",\"expression-type\":\"JSON_POINTER\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"vnf-name\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'vnf-name';
	
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition ='{\"tags\":\"vm-type\",\"name\":\"vm-type\",\"property\":{\"description\":\"vm-type\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select VFC_MODEL.vm_type as vm_type from VFC_MODEL where customization_uuid=:vfccustomizationuuid\",\"input-key-mapping\":{\"vfccustomizationuuid\":\"vfccustomizationuuid\"},\"output-key-mapping\":{\"vm-type\":\"vm_type\"},\"key-dependencies\":[\"vfccustomizationuuid\"]}}}}'
WHERE name = 'vm-type';
	
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition ='{\"tags\":\"vfw_private_ip_1\",\"name\":\"vfw_private_ip_1\",\"property\":{\"description\":\"vfw_private_ip_1\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\",\"properties\":{}},\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/vfw_private_ip_1\",\"path\":\"/param/0/value\",\"expression-type\":\"JSON_POINTER\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"vfw_private_ip_1\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'vfw_private_ip_1';
	
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition ='{\"tags\":\"vfw_private_ip_0\",\"name\":\"vfw_private_ip_0\",\"property\":{\"description\":\"vfw_private_ip_0\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\",\"properties\":{}},\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/vfw_private_ip_0\",\"path\":\"/param/0/value\",\"expression-type\":\"JSON_POINTER\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"vfw_private_ip_0\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'vfw_private_ip_0';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"vfccustomizationuuid, tosca.datatypes.Root, data_type\",\"name\":\"vfccustomizationuuid\",\"property\":{\"description\":\"vfccustomizationuuid\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select sdnctl.VF_MODULE_TO_VFC_MAPPING.vfc_customization_uuid as vnf_customid from sdnctl.VF_MODULE_TO_VFC_MAPPING where vm_count = 1 and sdnctl.VF_MODULE_TO_VFC_MAPPING.vf_module_customization_uuid=:vfmodulecustomizationuuid\",\"input-key-mapping\":{\"vfmodulecustomizationuuid\":\"vf-module-model-customization-uuid\"},\"output-key-mapping\":{\"vfccustomizationuuid\":\"vnf_customid\"},\"key-dependencies\":[\"vf-module-model-customization-uuid\"]}}}}'
WHERE name = 'vfccustomizationuuid';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"vf-nf-code\",\"name\":\"vf-nf-code\",\"property\":{\"description\":\"vf-nf-code\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select sdnctl.VF_MODEL.nf_code as vf_nf_code from sdnctl.VF_MODEL where sdnctl.VF_MODEL.customization_uuid=:customizationid\",\"input-key-mapping\":{\"customizationid\":\"vnf-model-customization-uuid\"},\"output-key-mapping\":{\"vf-nf-code\":\"vf_nf_code\"},\"key-dependencies\":[\"vnf-model-customization-uuid\"]}}}}'
WHERE name = 'vf-nf-code';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"vf-naming-policy\",\"name\":\"vf-naming-policy\",\"property\":{\"description\":\"vf-naming-policy\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"default\":{\"type\":\"source-default\",\"properties\":{}},\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select sdnctl.VF_MODEL.naming_policy as vf_naming_policy from sdnctl.VF_MODEL where sdnctl.VF_MODEL.customization_uuid=:vnf_model_customization_uuid\",\"input-key-mapping\":{\"vnf_model_customization_uuid\":\"vnf-model-customization-uuid\"},\"output-key-mapping\":{\"vf-naming-policy\":\"vf_naming_policy\"},\"key-dependencies\":[\"vnf-model-customization-uuid\"]}}}}'
WHERE name = 'vf-naming-policy';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"vf-module-type\",\"name\":\"vf-module-type\",\"property\":{\"description\":\"vf-module-type\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select vf_module_type as vf_module_type from sdnctl.VF_MODULE_MODEL where customization_uuid=:customizationid\",\"input-key-mapping\":{\"customizationid\":\"vf-module-model-customization-uuid\"},\"output-key-mapping\":{\"vf-module-type\":\"vf_module_type\"},\"key-dependencies\":[\"vf-module-model-customization-uuid\"]}}}}'
WHERE name = 'vf-module-type';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"vf-module-label\",\"name\":\"vf-module-label\",\"property\":{\"description\":\"vf-module-label\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select sdnctl.VF_MODULE_MODEL.vf_module_label as vf_module_label from sdnctl.VF_MODULE_MODEL where sdnctl.VF_MODULE_MODEL.customization_uuid=:customizationid\",\"input-key-mapping\":{\"customizationid\":\"vf-module-model-customization-uuid\"},\"output-key-mapping\":{\"vf-module-label\":\"vf_module_label\"},\"key-dependencies\":[\"vf-module-model-customization-uuid\"]}}}}'
WHERE name = 'vf-module-label';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"unprotected_private_net_cidr\",\"name\":\"unprotected_private_net_cidr\",\"property\":{\"description\":\"unprotected_private_net_cidr\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select sdnctl.IPAM_IP_POOL.prefix as prefix from sdnctl.IPAM_IP_POOL where description = \\\"unprotected\\\"\",\"output-key-mapping\":{\"unprotected_private_net_cidr\":\"prefix\"}}}}}'
WHERE name = 'unprotected_private_net_cidr';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"unprotected-prefix-id\",\"name\":\"unprotected-prefix-id\",\"property\":{\"description\":\"unprotected-prefix-id\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select sdnctl.IPAM_IP_POOL.prefix_id as prefix_id from sdnctl.IPAM_IP_POOL where description = \\\"unprotected\\\"\",\"output-key-mapping\":{\"unprotected-prefix-id\":\"prefix_id\"}}}}}'
WHERE name = 'unprotected-prefix-id';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"service-instance-id, tosca.datatypes.Root, data_type\",\"name\":\"service-instance-id\",\"property\":{\"description\":\"To be provided\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\",\"properties\":{}},\"any-db\":{\"type\":\"source-processor-db\",\"properties\":{\"query\":\"SELECT artifact_name FROM BLUEPRINT_RUNTIME where artifact_version=\\\"1.0.0\\\"\",\"input-key-mapping\":{},\"output-key-mapping\":{\"service-instance-id\":\"artifact_name\"}}},\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"query\":\"SELECT artifact_name FROM BLUEPRINT_RUNTIME where artifact_version=\\\"1.0.0\\\"\",\"input-key-mapping\":{},\"output-key-mapping\":{\"service-instance-id\":\"artifact_name\"}}},\"capability\":{\"type\":\"source-capability\",\"properties\":{\"script-type\":\"jython\",\"script-class-reference\":\"SampleRAProcessor\",\"instance-dependencies\":[]}}}}'
WHERE name = 'service-instance-id';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"sec_group\",\"name\":\"sec_group\",\"property\":{\"description\":\"sec_group\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"default\":{\"type\":\"source-default\",\"properties\":{}},\"input\":{\"type\":\"source-input\",\"properties\":{}}}}'
WHERE name = 'sec_group';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"sample-mdsal-source\",\"name\":\"sample-mdsal-source\",\"property\":{\"description\":\"Sample sample-mdsal-source\",\"type\":\"string\"},\"updated-by\":\"brindasanth@onap.com\",\"sources\":{\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/L3VNF-API:services/service-list/$service-instance-id/service-data/vnf-topology-information/vnf-assignments/vnf-vms/$vm-type/vm-networks/$network-role/v4-assigned-ip-list/$v4-ip-type\",\"path\":\"/v4-assigned-ip-list/0/v4-ip-prefix\",\"input-key-mapping\":{},\"output-key-mapping\":{\"mdsal-source\":\"v4-ip-prefix\"},\"key-dependencies\":[]}}}'
WHERE name = 'sample-mdsal-source';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"sample-licenses\",\"name\":\"sample-licenses\",\"property\":{\"description\":\" Sample Data for licences\",\"required\":true,\"type\":\"list\",\"entry_schema\":{\"type\":\"dt-license-key\"}},\"updated-by\":\"brindasanth@onap.com\",\"sources\":{\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/L3VNF-API:services/service-list/\",\"path\":\"/licenses\",\"input-key-mapping\":{},\"output-key-mapping\":{\"licenses\":\"licenses\"},\"key-dependencies\":[]}}}}'
WHERE name = 'sample-licenses';

UPDATE `RESOURCE_DICTIONARY` 
SET definition ='{\"tags\":\"processor-db-source, brindasanth@onap.com\",\"name\":\"sample-db-source\",\"property\":{\"description\":\"name of the \",\"type\":\"string\"},\"updated-by\":\"brindasanth@onap.com\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"query\":\"SELECT db-country, db-state FROM DEVICE_PROFILE WHERE profile_name = :profile_name\",\"input-key-mapping\":{\"profile_name\":\"profile_name\"},\"output-key-mapping\":{\"db-country\":\"country\",\"db-state\":\"state\"}}}}}' 
WHERE name = 'sample-db-source';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"pub_key\",\"name\":\"pub_key\",\"property\":{\"description\":\"pub_key\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\"},\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/pub_key\",\"path\":\"/param/0/value\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"pub_key\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'pub_key';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"public_net_id\",\"name\":\"public_net_id\",\"property\":{\"description\":\"public_net_id\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"default\":{\"type\":\"source-default\",\"properties\":{}},\"input\":{\"type\":\"source-input\"}}}'
WHERE name = 'public_net_id';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"protected-prefix-id\",\"name\":\"protected-prefix-id\",\"property\":{\"description\":\"protected-prefix-id\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select sdnctl.IPAM_IP_POOL.prefix_id as prefix_id from sdnctl.IPAM_IP_POOL where description = \\\"protected\\\"\",\"output-key-mapping\":{\"protected-prefix-id\":\"prefix_id\"}}}}}'
WHERE name = 'protected-prefix-id';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"onap_private_subnet_id\",\"name\":\"onap_private_subnet_id\",\"property\":{\"description\":\"onap_private_subnet_id\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\"},\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/onap_private_subnet_id\",\"path\":\"/param/0/value\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"onap_private_subnet_id\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'onap_private_subnet_id';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"onap_private_net_id\",\"name\":\"onap_private_net_id\",\"property\":{\"description\":\"onap_private_net_id\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\"},\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/onap_private_net_id\",\"path\":\"/param/0/value\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"onap_private_net_id\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'onap_private_net_id';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"onap_private_net_cidr\",\"name\":\"onap_private_net_cidr\",\"property\":{\"description\":\"onap_private_net_cidr\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select sdnctl.IPAM_IP_POOL.prefix as prefix from sdnctl.IPAM_IP_POOL where description = \\\"private\\\"\",\"output-key-mapping\":{\"onap_private_net_cidr\":\"prefix\"}}}}}'
WHERE name = 'onap_private_net_cidr';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"nfc-naming-code\",\"name\":\"nfc-naming-code\",\"property\":{\"description\":\"nfc-naming-code\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select nfc_naming_code as nfc_naming_code from sdnctl.VFC_MODEL where customization_uuid=:vfccustomizationuuid\",\"input-key-mapping\":{\"vfccustomizationuuid\":\"vfccustomizationuuid\"},\"output-key-mapping\":{\"nfc-naming-code\":\"nfc_naming_code\"},\"key-dependencies\":[\"vfccustomizationuuid\"]}}}}'
WHERE name = 'nfc-naming-code';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"nf-role\",\"name\":\"nf-role\",\"property\":{\"description\":\"vnf/nf-role\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"default\":{\"type\":\"source-default\",\"properties\":{}},\"processor-db\":{\"type\":\"source-processor-db\",\"properties\":{\"type\":\"SQL\",\"query\":\"select sdnctl.VF_MODEL.nf_role as vf_model_role from sdnctl.VF_MODEL where sdnctl.VF_MODEL.customization_uuid=:vnfmodelcustomizationuuid\",\"input-key-mapping\":{\"vnfmodelcustomizationuuid\":\"vnf-model-customization-uuid\"},\"output-key-mapping\":{\"nf-role\":\"vf_model_role\"},\"key-dependencies\":[\"vnf-model-customization-uuid\"]}}}}'
WHERE name = 'nf-role';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"nexus_artifact_repo\",\"name\":\"nexus_artifact_repo\",\"property\":{\"description\":\"nexus_artifact_repo\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"default\":{\"type\":\"source-default\",\"properties\":{}},\"input\":{\"type\":\"source-input\",\"properties\":{}}}}'
WHERE name = 'nexus_artifact_repo';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"oam-local-ipv4-address\",\"name\":\"mdsal-source\",\"property\":{\"description\":\"based on service-instance-id,network-role,v4-ip-type and vm-type get the ipv4-gateway-prefix from the SDN-GC mdsal\",\"type\":\"string\"},\"updated-by\":\"brindasanth@onap.com\",\"sources\":{\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"endpoint-selector\":\"\",\"url-path\":\"config/L3VNF-API:services/service-list/$service-instance-id/service-data/vnf-topology-information/vnf-assignments/vnf-vms/$vm-type/vm-networks/$network-role/v4-assigned-ip-list/$v4-ip-type\",\"path\":\"/v4-assigned-ip-list/0/v4-ip-prefix\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"network-role\":\"network-role\",\"v4-ip-type\":\"v4-ip-type\",\"vm-type\":\"vm-type\"},\"output-key-mapping\":{\"oam-local-ipv4-address\":\"v4-ip-prefix\"},\"key-dependencies\":[\"service-instance-id\",\"network-role\",\"v4-ip-type\",\"vm-type\"]}}}}'
WHERE name = 'mdsal-source';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"key_name\",\"name\":\"key_name\",\"property\":{\"description\":\"key_name\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\"},\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/key_name\",\"path\":\"/param/0/value\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"key_name\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'key_name';
	
UPDATE `RESOURCE_DICTIONARY` 
SET definition = '{\"tags\":\"image_name\",\"name\":\"image_name\",\"property\":{\"description\":\"image_name\",\"type\":\"string\"},\"updated-by\":\"Singal, Kapil <ks220y@att.com>\",\"sources\":{\"input\":{\"type\":\"source-input\"},\"primary-config-data\":{\"type\":\"source-rest\",\"properties\":{\"type\":\"JSON\",\"url-path\":\"config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/image_name\",\"path\":\"/param/0/value\",\"input-key-mapping\":{\"service-instance-id\":\"service-instance-id\",\"vnf-id\":\"vnf-id\"},\"output-key-mapping\":{\"image_name\":\"value\"},\"key-dependencies\":[\"service-instance-id\",\"vnf-id\"]}}}}'
WHERE name = 'image_name';
	

