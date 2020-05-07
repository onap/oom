

--
-- Table structure for table `ACCESS_LOG`
--

CREATE TABLE IF NOT EXISTS `ACCESS_LOG` (
  `access_log_seq` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `method` varchar(12) DEFAULT NULL,
  `version` varchar(12) DEFAULT NULL,
  `status` varchar(12) DEFAULT NULL,
  `url` varchar(256) DEFAULT NULL,
  `remote_address` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`access_log_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=1034 DEFAULT CHARSET=latin1;

--
-- Table structure for table `CUSTOMER`
--


CREATE TABLE IF NOT EXISTS `CUSTOMER` (
  `cust_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(256) DEFAULT NULL,
  `grua` varchar(4) NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cust_id`),
  UNIQUE KEY `IU1_CUSTOMER` (`customer_name`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=latin1;


--
-- Table structure for table `ADDRESS_PLAN_POLICIES`
--

CREATE TABLE IF NOT EXISTS `ADDRESS_PLAN_POLICIES` (
  `key_name` varchar(255) NOT NULL,
  `key_value_source_type` varchar(255) NOT NULL,
  `key_value_source` varchar(255) NOT NULL,
  PRIMARY KEY (`key_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `AGNOSTIC_NOTIFICATION_URL`
--

CREATE TABLE IF NOT EXISTS `AGNOSTIC_NOTIFICATION_URL` (
  `service_type` varchar(128) NOT NULL,
  `service_instance_id` varchar(128) NOT NULL,
  `request_id` varchar(128) NOT NULL,
  `svc_notification_url` varchar(256) NOT NULL,
  PRIMARY KEY (`service_type`,`service_instance_id`,`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `AGNOSTIC_TO_SVC_SPCFC_API`
--
CREATE TABLE IF NOT EXISTS `AGNOSTIC_TO_SVC_SPCFC_API` (
  `operation` varchar(128) NOT NULL,
  `service` varchar(128) NOT NULL,
  `service_specific_api` varchar(128) NOT NULL,
  `async_process` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`operation`,`service`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `AIC_AVAIL_ZONE_POOL`
--
CREATE TABLE IF NOT EXISTS `AIC_AVAIL_ZONE_POOL` (
  `aic_site_id` varchar(100) NOT NULL,
  `status` varchar(40) NOT NULL,
  `availability_zone` varchar(100) NOT NULL,
  `token` varchar(5) NOT NULL,
  `vnf_id` varchar(80) DEFAULT NULL,
  `service_type` varchar(100) NOT NULL,
  `vnf_type` varchar(20) DEFAULT NULL,
  `hypervisor` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`aic_site_id`,`availability_zone`,`token`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `AIC_HOSTNAME`
--
CREATE TABLE IF NOT EXISTS `AIC_HOSTNAME` (
  `hostname` varchar(20) NOT NULL,
  `cust_id` int(11) NOT NULL,
  `vendor_code` varchar(1) NOT NULL,
  `virtual_device_type` varchar(2) DEFAULT NULL,
  `device_sequence` varchar(3) NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`hostname`),
  UNIQUE KEY `hostname` (`hostname`),
  KEY `IN1_AIC_HOSTNAME` (`cust_id`),
  CONSTRAINT `AC1_HOSTNAME` FOREIGN KEY (`cust_id`) REFERENCES `CUSTOMER` (`cust_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `AIC_NETWORK`
--

CREATE TABLE IF NOT EXISTS `AIC_NETWORK` (
  `network_id` varchar(100) NOT NULL,
  `network_name` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `tenant_id` varchar(100) DEFAULT NULL,
  `switch_uuid` varchar(100) DEFAULT NULL,
  `portgroup_name` varchar(100) DEFAULT NULL,
  `portgroup_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`network_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `AIC_SITE`
--

CREATE TABLE IF NOT EXISTS `AIC_SITE` (
  `name` varchar(100) DEFAULT NULL,
  `aic_site_id` varchar(100) NOT NULL,
  `vcenter_url` varchar(200) DEFAULT NULL,
  `vcenter_username` varchar(40) DEFAULT NULL,
  `vcenter_passwd` varbinary(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `operational_status` varchar(20) DEFAULT NULL,
  `oam_gateway_addr` varchar(20) DEFAULT '',
  PRIMARY KEY (`aic_site_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `AIC_SWITCH`
--

CREATE TABLE IF NOT EXISTS `AIC_SWITCH` (
  `switch_name` varchar(100) DEFAULT NULL,
  `physical_network_name` varchar(100) NOT NULL,
  `aic_site_id` varchar(100) DEFAULT NULL,
  `uuid` varchar(100) DEFAULT NULL,
  `availability_zone` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`physical_network_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `AIC_ZONE_CLOUD_REGION_ID`
--

CREATE TABLE IF NOT EXISTS `AIC_ZONE_CLOUD_REGION_ID` (
  `zone_region_id` varchar(255) NOT NULL,
  `cilli_code` varchar(255) NOT NULL,
  `location_id` varchar(255) NOT NULL DEFAULT '',
  `city_state_country` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`zone_region_id`,`cilli_code`,`location_id`,`city_state_country`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `ALLOCATION_ITEM`
--

CREATE TABLE IF NOT EXISTS `ALLOCATION_ITEM` (
  `allocation_item_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `resource_id` bigint(20) NOT NULL,
  `application_id` varchar(50) NOT NULL,
  `resource_set_id` varchar(200) NOT NULL,
  `resource_union_id` varchar(200) NOT NULL,
  `resource_share_group_list` varchar(200) DEFAULT NULL,
  `lt_used` bigint(20) DEFAULT NULL,
  `ll_label` varchar(50) DEFAULT NULL,
  `rr_used` varchar(200) DEFAULT NULL,
  `allocation_time` datetime NOT NULL,
  PRIMARY KEY (`allocation_item_id`),
  UNIQUE KEY `allocation_item_id` (`allocation_item_id`),
  UNIQUE KEY `IX2_ALLOCATION_ITEM` (`resource_id`,`resource_set_id`),
  KEY `IX1_ALLOCATION_ITEM` (`resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5764 DEFAULT CHARSET=latin1;

--
-- Table structure for table `ALLOTTED_RESOURCE_MODEL`
--

CREATE TABLE IF NOT EXISTS `ALLOTTED_RESOURCE_MODEL` (
  `customization_uuid` varchar(255) NOT NULL,
  `model_yaml` longblob,
  `invariant_uuid` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `naming_policy` varchar(255) DEFAULT NULL,
  `ecomp_generated_naming` char(1) DEFAULT NULL,
  `depending_service` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `service_dependency` varchar(255) DEFAULT NULL,
  `allotted_resource_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customization_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `ALTS_CREDENTIALS`
--

CREATE TABLE IF NOT EXISTS `ALTS_CREDENTIALS` (
  `alts_username` varchar(255) NOT NULL,
  `alts_password` varbinary(255) NOT NULL,
  PRIMARY KEY (`alts_username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `ASDC_ARTIFACTS`
--

CREATE TABLE IF NOT EXISTS `ASDC_ARTIFACTS` (
  `asdc_artifacts_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_uuid` varchar(50) DEFAULT NULL,
  `distribution_id` varchar(50) DEFAULT NULL,
  `service_name` varchar(255) DEFAULT NULL,
  `service_description` varchar(255) DEFAULT NULL,
  `resource_uuid` varchar(255) DEFAULT NULL,
  `resource_instance_name` varchar(255) DEFAULT NULL,
  `resource_name` varchar(255) DEFAULT NULL,
  `resource_version` varchar(50) DEFAULT NULL,
  `resource_type` varchar(50) DEFAULT NULL,
  `artifact_uuid` varchar(50) DEFAULT NULL,
  `artifact_type` varchar(50) DEFAULT NULL,
  `artifact_version` varchar(25) DEFAULT NULL,
  `artifact_description` varchar(255) DEFAULT NULL,
  `internal_version` int(11) DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `artifact_name` varchar(255) DEFAULT NULL,
  `artifact_content` longtext,
  PRIMARY KEY (`asdc_artifacts_id`),
  UNIQUE KEY `asdc_artifacts_id` (`asdc_artifacts_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

--
-- Table structure for table `ASDC_REFERENCE`
--

CREATE TABLE IF NOT EXISTS `ASDC_REFERENCE` (
  `asdc_reference_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_type` varchar(50) DEFAULT NULL,
  `vnf_type` varchar(50) DEFAULT NULL,
  `vnfc_type` varchar(50) DEFAULT NULL,
  `file_category` varchar(50) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `artifact_type` varchar(50) DEFAULT NULL,
  `artifact_name` varchar(255) NOT NULL,
  PRIMARY KEY (`asdc_reference_id`),
  UNIQUE KEY `asdc_reference_id` (`asdc_reference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=latin1;


--
-- Table structure for table `BLOB_TEST`
--

CREATE TABLE IF NOT EXISTS `BLOB_TEST` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `odl` varchar(20) DEFAULT NULL,
  `communities` mediumblob,
  `status` enum('NEW','COMPLETE','FAILED') NOT NULL DEFAULT 'NEW',
  `retry_count` int(11) DEFAULT '-1',
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `CAPABILITY`
--

CREATE TABLE IF NOT EXISTS `CAPABILITY` (
  `capability_id` int(11) NOT NULL AUTO_INCREMENT,
  `capability_name` varchar(50) NOT NULL,
  `implementation_name` varchar(100) NOT NULL,
  `operation_name` varchar(50) NOT NULL,
  `operation_description` varchar(100) NOT NULL,
  `input_definition` longtext,
  `output_definition` longtext,
  `dependency_definition` longtext,
  `tags` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`capability_id`),
  UNIQUE KEY `capability_id` (`capability_name`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=latin1;

--
-- Table structure for table `CITY_CODE`
--

CREATE TABLE IF NOT EXISTS `CITY_CODE` (
  `city_code_id` int(11) NOT NULL AUTO_INCREMENT,
  `city_code` varchar(3) NOT NULL,
  `city` varchar(150) NOT NULL,
  `state` varchar(10) NOT NULL,
  `country_code` varchar(10) NOT NULL,
  PRIMARY KEY (`city_code_id`),
  KEY `IN1_CITY_CODE` (`city`,`state`,`country_code`)
) ENGINE=InnoDB AUTO_INCREMENT=37822 DEFAULT CHARSET=latin1;

--
-- Table structure for table `CLI_UPDATES`
--

CREATE TABLE IF NOT EXISTS `CLI_UPDATES` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('NEW','COMPLETE','FAILED') NOT NULL DEFAULT 'NEW',
  `create_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_processed_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `target_address` varchar(128) DEFAULT NULL,
  `cli_text` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `CONFIGFILES`
--

CREATE TABLE IF NOT EXISTS `CONFIGFILES` (
  `config_file_id` int(11) NOT NULL AUTO_INCREMENT,
  `external_version` varchar(50) DEFAULT NULL,
  `data_source` varchar(25) DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `service_instance_id` varchar(50) DEFAULT NULL,
  `vnf_type` varchar(50) DEFAULT NULL,
  `vnfc_type` varchar(50) DEFAULT NULL,
  `file_category` varchar(50) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_content` longtext,
  `action` varchar(50) DEFAULT NULL,
  `vnf_id` varchar(50) DEFAULT NULL,
  `vm_name` varchar(50) DEFAULT NULL,
  `vnf_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`config_file_id`),
  UNIQUE KEY `config_file_id` (`config_file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Table structure for table `CONFIGURE_ACTION_DG`
--


CREATE TABLE IF NOT EXISTS `CONFIGURE_ACTION_DG` (
  `configure_action_dg_id` int(11) NOT NULL AUTO_INCREMENT,
  `vnf_type` varchar(50) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `init_config_dg` varchar(50) DEFAULT NULL,
  `generate_config_dg` varchar(50) DEFAULT NULL,
  `download_config_dg` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`configure_action_dg_id`),
  UNIQUE KEY `configure_action_dg_id` (`configure_action_dg_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;


--
-- Table structure for table `CONFIG_CONTENT`
--

CREATE TABLE IF NOT EXISTS `CONFIG_CONTENT` (
  `config_content_id` int(11) NOT NULL AUTO_INCREMENT,
  `request_id` varchar(50) NOT NULL,
  `content_type` varchar(50) NOT NULL,
  `template_name` varchar(50) DEFAULT NULL,
  `originator_id` varchar(50) DEFAULT NULL,
  `service_description` varchar(100) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `service_type` varchar(50) DEFAULT NULL,
  `service_instance_id` varchar(50) DEFAULT NULL,
  `vnf_id` varchar(50) DEFAULT NULL,
  `vnf_name` varchar(50) DEFAULT NULL,
  `vm_name` varchar(50) DEFAULT NULL,
  `vnf_type` varchar(50) DEFAULT NULL,
  `vnfc_type` varchar(50) DEFAULT NULL,
  `host_ip_address` varchar(50) DEFAULT NULL,
  `config_indicator` varchar(25) DEFAULT NULL,
  `pending_delete` varchar(1) DEFAULT NULL,
  `content` longtext,
  PRIMARY KEY (`config_content_id`),
  UNIQUE KEY `config_content_id` (`creation_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `CONFIG_FILE_REFERENCE`
--

CREATE TABLE IF NOT EXISTS `CONFIG_FILE_REFERENCE` (
  `config_file_reference_id` int(11) NOT NULL AUTO_INCREMENT,
  `site_location` varchar(50) DEFAULT NULL,
  `vnf_type` varchar(50) DEFAULT NULL,
  `import_type` varchar(50) DEFAULT NULL,
  `file_type` varchar(50) DEFAULT NULL,
  `source_server_name` varchar(255) DEFAULT NULL,
  `source_file_path` varchar(255) DEFAULT NULL,
  `target_file_path` varchar(255) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`config_file_reference_id`),
  UNIQUE KEY `config_file_reference_id` (`config_file_reference_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `CONFIG_TRANSACTION_LOG`
--

CREATE TABLE IF NOT EXISTS `CONFIG_TRANSACTION_LOG` (
  `config_transaction_log_id` varchar(50) NOT NULL,
  `request_id` varchar(50) DEFAULT NULL,
  `message_type` varchar(100) DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `message` longtext,
  PRIMARY KEY (`config_transaction_log_id`),
  UNIQUE KEY `config_transaction_log_id` (`config_transaction_log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;


--
-- Table structure for table `COUNTRY_ASN_MAPPING`
--

CREATE TABLE IF NOT EXISTS `COUNTRY_ASN_MAPPING` (
  `asn` int(5) NOT NULL,
  `iso_2char` varchar(5) NOT NULL,
  `iso_3char` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




--
-- Table structure for table `CUSTOMER2CONNECTION_MAPPING`
--

CREATE TABLE `CUSTOMER2CONNECTION_MAPPING` (
  `customer2connection_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_instance_id` varchar(80) NOT NULL,
  `instance_type` varchar(20) NOT NULL,
  `originating_service_instance_id` varchar(80) DEFAULT NULL,
  `originating_service_type` varchar(20) DEFAULT NULL,
  `service_type` varchar(30) DEFAULT NULL,
  `connection_id` varchar(100) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`customer2connection_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Table structure for table `CUSTOMER2CONNECTION_MAPPING_NEW`
--

CREATE TABLE IF NOT EXISTS `CUSTOMER2CONNECTION_MAPPING_NEW` (
  `customer2connection_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_instance_id` varchar(80) NOT NULL,
  `instance_type` varchar(20) NOT NULL,
  `originating_service_instance_id` varchar(80) DEFAULT NULL,
  `originating_service_type` varchar(20) DEFAULT NULL,
  `service_type` varchar(30) DEFAULT NULL,
  `connection_id` varchar(100) NOT NULL,
  `status` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`customer2connection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `DATA_OBJECT_MAPPING`
--

CREATE TABLE IF NOT EXISTS `DATA_OBJECT_MAPPING` (
  `serial_key` int(11) NOT NULL AUTO_INCREMENT,
  `data_object_key` varchar(100) NOT NULL,
  `data_object_type` varchar(50) NOT NULL,
  `service_type` varchar(50) NOT NULL,
  `data_object_key2` varchar(100) NOT NULL,
  `data_object_key2_type` varchar(50) NOT NULL,
  `data_object_key3` varchar(100) DEFAULT NULL,
  `data_object_key3_type` varchar(50) DEFAULT NULL,
  `service` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`serial_key`),
  KEY `IX1_DATA_OBJECT_MAPPING` (`data_object_key`,`data_object_type`,`service_type`),
  KEY `IX2_DATA_OBJECT_MAPPING` (`service_type`,`data_object_key2`,`data_object_key2_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3211 DEFAULT CHARSET=latin1;

--
-- Table structure for table `DEVICE2CONNECTION_MAPPING`
--

CREATE TABLE IF NOT EXISTS `DEVICE2CONNECTION_MAPPING` (
  `vnf_host_name` varchar(100) NOT NULL,
  `e2e_vpn_key` varchar(30) NOT NULL,
  `service_type` varchar(30) NOT NULL,
  `connection_id` varchar(100) NOT NULL,
  PRIMARY KEY (`vnf_host_name`,`e2e_vpn_key`,`service_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `DEVICE2IPADDRESS_CONSUMPTION`
--

CREATE TABLE IF NOT EXISTS `DEVICE2IPADDRESS_CONSUMPTION` (
  `serial_key` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` varchar(100) NOT NULL,
  `device_type` varchar(30) NOT NULL,
  `ip_version` varchar(10) NOT NULL,
  `consumption_key` varchar(100) NOT NULL,
  `logical_interface_service_id` varchar(100) NOT NULL,
  `address_type` varchar(30) NOT NULL,
  `ip_consumed` varchar(50) NOT NULL,
  `vnf_type` varchar(30) NOT NULL,
  `secondary_key` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`serial_key`),
  KEY `IX1_DEVICEIPADDRESS_CONSUMPTION` (`device_id`,`device_type`,`ip_version`)
) ENGINE=InnoDB AUTO_INCREMENT=1357 DEFAULT CHARSET=latin1;

--
-- Table structure for table `DEVICE2IPADDRESS_MAPPING`
--

CREATE TABLE IF NOT EXISTS `DEVICE2IPADDRESS_MAPPING` (
  `serial_key` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` varchar(100) NOT NULL,
  `device_type` varchar(30) NOT NULL,
  `secondary_key` varchar(100) NOT NULL,
  `secondary_key_type` varchar(30) NOT NULL,
  `address` varchar(50) NOT NULL,
  `address_type` varchar(30) NOT NULL,
  `ip_version` varchar(10) NOT NULL,
  `length` int(11) NOT NULL,
  `status` varchar(30) NOT NULL,
  PRIMARY KEY (`serial_key`),
  KEY `IX1_DEVICE2IPADDRESS_MAPPING` (`device_id`,`device_type`,`secondary_key`,`secondary_key_type`,`address`,`address_type`)
) ENGINE=InnoDB AUTO_INCREMENT=4734 DEFAULT CHARSET=latin1;

--
-- Table structure for table `DEVICE_AUTHENTICATION`
--

CREATE TABLE IF NOT EXISTS `DEVICE_AUTHENTICATION` (
  `device_authentication_id` int(11) NOT NULL AUTO_INCREMENT,
  `vnf_type` varchar(50) DEFAULT NULL,
  `user_name` varchar(50) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `protocol` varchar(100) DEFAULT NULL,
  `port_number` int(11) DEFAULT NULL,
  PRIMARY KEY (`device_authentication_id`),
  UNIQUE KEY `device_authentication_id` (`device_authentication_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Table structure for table `DEVICE_INTERFACE_LOG`
--

CREATE TABLE IF NOT EXISTS `DEVICE_INTERFACE_LOG` (
  `device_interface_log_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_instance_id` varchar(50) DEFAULT NULL,
  `request_id` varchar(50) DEFAULT NULL,
  `creation_date` datetime NOT NULL,
  `log` longtext,
  PRIMARY KEY (`device_interface_log_id`),
  UNIQUE KEY `device_interface_log_id` (`device_interface_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `DEVICE_INTERFACE_PROTOCOL`
--

CREATE TABLE IF NOT EXISTS `DEVICE_INTERFACE_PROTOCOL` (
  `device_interface_protocol_id` int(11) NOT NULL AUTO_INCREMENT,
  `vnf_type` varchar(50) DEFAULT NULL,
  `protocol` varchar(50) DEFAULT NULL,
  `module` varchar(50) DEFAULT NULL,
  `dg_rpc` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`device_interface_protocol_id`),
  UNIQUE KEY `device_interface_protocol_id` (`device_interface_protocol_id`),
  UNIQUE KEY `vnf_type` (`vnf_type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Table structure for table `DOWNLOAD_CONFIG_TEMPLATE`
--

CREATE TABLE IF NOT EXISTS `DOWNLOAD_CONFIG_TEMPLATE` (
  `download_config_template_id` int(11) NOT NULL AUTO_INCREMENT,
  `vnf_type` varchar(50) NOT NULL,
  `protocol` varchar(50) NOT NULL,
  `template` longtext,
  PRIMARY KEY (`download_config_template_id`),
  UNIQUE KEY `download_config_template_id` (`download_config_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `DOWNLOAD_DG_REFERENCE`
--

CREATE TABLE IF NOT EXISTS `DOWNLOAD_DG_REFERENCE` (
  `download_dg_reference_id` int(11) NOT NULL AUTO_INCREMENT,
  `protocol` varchar(50) NOT NULL,
  `download_config_dg` varchar(50) NOT NULL,
  PRIMARY KEY (`download_dg_reference_id`),
  UNIQUE KEY `download_dg_reference_id` (`download_dg_reference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Table structure for table `EIPAM_CLIENT_KEY_INDEX`
--

CREATE TABLE IF NOT EXISTS `EIPAM_CLIENT_KEY_INDEX` (
  `vnf_name_prefix` varchar(100) NOT NULL,
  `index_number` int(11) NOT NULL,
  PRIMARY KEY (`vnf_name_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `EIPAM_IP_ASSIGNMENTS`
--

CREATE TABLE IF NOT EXISTS `EIPAM_IP_ASSIGNMENTS` (
  `plan_name` varchar(40) NOT NULL,
  `client_key` varchar(100) NOT NULL,
  `service_type` varchar(40) NOT NULL,
  `ip_address` varchar(40) DEFAULT NULL,
  `prefix_length` int(2) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `service_instance_id` varchar(80) DEFAULT NULL,
  `last_modified_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `prev_status` varchar(20) DEFAULT NULL,
  `info` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`plan_name`,`client_key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `EIPAM_IP_POOLS`
--

CREATE TABLE IF NOT EXISTS `EIPAM_IP_POOLS` (
  `pool_id` int(11) NOT NULL AUTO_INCREMENT,
  `key_name` varchar(50) NOT NULL,
  `key_value` varchar(255) NOT NULL,
  `level` int(2) NOT NULL,
  `plan_name` varchar(50) NOT NULL,
  `address_family` varchar(10) NOT NULL,
  `parent_pool` varchar(255) NOT NULL,
  `service_instance_id` varchar(255) DEFAULT NULL,
  `network_id` varchar(255) DEFAULT NULL,
  `created_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_failure` varchar(20) DEFAULT NULL,
  `delete_request_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=339 DEFAULT CHARSET=latin1 COMMENT='This table will capture the pools being created by SDN-C in EIPAM_IP_POOLS. There is no data migration for existing vPE pool data.';

--
-- Table structure for table `EIPAM_IP_SUBNETS`
--

CREATE TABLE IF NOT EXISTS `EIPAM_IP_SUBNETS` (
  `entity_id` int(6) NOT NULL,
  `service_type` varchar(40) NOT NULL,
  `plan_name` varchar(50) NOT NULL,
  `address_family` varchar(10) NOT NULL,
  `ip_address` varchar(40) NOT NULL,
  `prefix_length` int(3) NOT NULL,
  `status` varchar(20) NOT NULL,
  `last_modified_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `network_id` varchar(255) DEFAULT NULL,
  `pool_id` int(11) DEFAULT NULL,
  `dealloc_failure` varchar(20) DEFAULT NULL,
  `dealloc_request_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_id`),
  KEY `FK_EIPAM_IP_SUBNETS_EIPAM_IP_POOLS` (`pool_id`),
  CONSTRAINT `EIPAM_IP_SUBNETS_ibfk_1` FOREIGN KEY (`pool_id`) REFERENCES `EIPAM_IP_POOLS` (`pool_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_EIPAM_IP_SUBNETS_EIPAM_IP_POOLS` FOREIGN KEY (`pool_id`) REFERENCES `EIPAM_IP_POOLS` (`pool_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `EIPAM_IP_SUBNET_KEYS`
--

CREATE TABLE IF NOT EXISTS `EIPAM_IP_SUBNET_KEYS` (
  `entity_id` int(6) NOT NULL,
  `key_name` varchar(50) NOT NULL,
  `key_value` varchar(255) NOT NULL,
  `level` int(2) NOT NULL,
  PRIMARY KEY (`entity_id`,`key_name`,`key_value`,`level`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `EIPAM_REQUEST_KEY`
--

CREATE TABLE IF NOT EXISTS `EIPAM_REQUEST_KEY` (
  `key_name_1` varchar(50) NOT NULL,
  `address_family` varchar(4) NOT NULL,
  `serial_key` int(2) NOT NULL AUTO_INCREMENT,
  `plan_name` varchar(50) NOT NULL,
  `request_length` int(2) NOT NULL,
  `pools_length` int(2) NOT NULL,
  `plan_length` int(2) NOT NULL,
  `key_name_0` varchar(50) NOT NULL,
  `key_name_type_0` varchar(255) NOT NULL,
  `key_name_type_1` varchar(255) NOT NULL,
  `prefix_length` int(2) NOT NULL,
  `group_flag` char(1) NOT NULL,
  `address_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`key_name_1`,`address_family`),
  UNIQUE KEY `IX1_EIPAM_REQUEST_KEY` (`serial_key`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

--
-- Table structure for table `EXTERNAL_DATA`
--

CREATE TABLE IF NOT EXISTS `EXTERNAL_DATA` (
  `external_data_id` int(11) NOT NULL AUTO_INCREMENT,
  `request_id` int(11) DEFAULT NULL,
  `param_name` varchar(30) NOT NULL,
  `param_value` varchar(50) NOT NULL,
  PRIMARY KEY (`external_data_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `FLOW_UPDATES`
--

CREATE TABLE IF NOT EXISTS `FLOW_UPDATES` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('NEW','COMPLETE','FAILED') NOT NULL DEFAULT 'NEW',
  `create_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_processed_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `odl` varchar(128) DEFAULT NULL,
  `address_family` enum('IPV4','IPV6') DEFAULT NULL,
  `destination_prefix` varchar(50) DEFAULT NULL,
  `communities` varchar(6000) DEFAULT NULL,
  `route_key` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB AUTO_INCREMENT=276 DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_L3_NETWORK`
--

CREATE TABLE IF NOT EXISTS `GENERIC_L3_NETWORK` (
  `network_id` varchar(80) NOT NULL,
  `network_name` varchar(80) DEFAULT NULL,
  `network_type` varchar(80) DEFAULT NULL,
  `network_role` varchar(80) DEFAULT NULL,
  `network_technology` varchar(80) DEFAULT NULL,
  `neutron_network_id` varchar(80) DEFAULT NULL,
  `is_bound_to_vpn` tinyint(1) DEFAULT NULL,
  `orchestration_status` varchar(20) DEFAULT NULL,
  `heat_stack_id` varchar(80) DEFAULT NULL,
  `mso_catalog_key` varchar(80) DEFAULT NULL,
  `service_id` varchar(80) NOT NULL,
  `tenant_id` varchar(80) NOT NULL,
  `physical_location_id` varchar(20) DEFAULT NULL,
  `network_role_instance` varchar(80) NOT NULL,
  PRIMARY KEY (`network_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_L3_NETWORK_SUBNET`
--

CREATE TABLE IF NOT EXISTS `GENERIC_L3_NETWORK_SUBNET` (
  `network_id` varchar(80) NOT NULL,
  `subnet_id` varchar(80) NOT NULL,
  `neutron_subnet_id` varchar(80) DEFAULT NULL,
  `gateway_address` varchar(45) NOT NULL,
  `network_start_address` varchar(45) NOT NULL,
  `cidr_mask` varchar(20) NOT NULL,
  `ip_version` char(1) NOT NULL,
  `orchestration_status` varchar(64) NOT NULL,
  `dhcp_enabled` tinyint(1) NOT NULL,
  `dhcp_start` varchar(45) DEFAULT NULL,
  `dhcp_end` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`network_id`,`subnet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_L3_NETWORK_VPN_BINDING`
--

CREATE TABLE IF NOT EXISTS `GENERIC_L3_NETWORK_VPN_BINDING` (
  `network_id` varchar(80) NOT NULL,
  `vpn_id` varchar(80) NOT NULL,
  PRIMARY KEY (`network_id`,`vpn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_RESOURCE_NAME`
--

CREATE TABLE IF NOT EXISTS `GENERIC_RESOURCE_NAME` (
  `type` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(255) NULL,
  `name_index` int(11) NULL,
  `context_id` varchar(255) NULL,
  PRIMARY KEY (`type`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_VNF`
--

CREATE TABLE IF NOT EXISTS `GENERIC_VNF` (
  `vnf_id` varchar(80) NOT NULL,
  `vnf_name` varchar(80) NOT NULL,
  `vnf_type` varchar(200) NOT NULL,
  `vnf_name2` varchar(80) DEFAULT NULL,
  `service_id` varchar(80) NOT NULL,
  `equipment_role` varchar(80) NOT NULL,
  `orchestration_status` varchar(20) DEFAULT NULL,
  `prov_status` varchar(20) DEFAULT NULL,
  `heat_stack_id` varchar(80) DEFAULT NULL,
  `mso_catalog_key` varchar(80) DEFAULT NULL,
  `regional_resource_zone` varchar(80) DEFAULT NULL,
  `operational_state` varchar(80) DEFAULT NULL,
  `license_key` varchar(80) DEFAULT NULL,
  `ipv4_oam_address` varchar(20) DEFAULT NULL,
  `ipv4_loopback0_address` varchar(20) DEFAULT NULL,
  `nm_lan_v6_address` varchar(40) DEFAULT NULL,
  `management_v6_address` varchar(40) DEFAULT NULL,
  `management_option` varchar(45) DEFAULT NULL,
  `vcpu` varchar(45) DEFAULT NULL,
  `vmemory` varchar(45) DEFAULT NULL,
  `vdisk` varchar(45) DEFAULT NULL,
  `vcpu_units` varchar(45) DEFAULT NULL,
  `vmemory_units` varchar(45) DEFAULT NULL,
  `vdisk_units` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`vnf_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_VNF_L3_NETWORK`
--

CREATE TABLE IF NOT EXISTS `GENERIC_VNF_L3_NETWORK` (
  `vnf_id` varchar(80) NOT NULL,
  `network_id` varchar(80) NOT NULL,
  PRIMARY KEY (`vnf_id`,`network_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_VNF_LICENSE_MANAGEMENT`
--

CREATE TABLE IF NOT EXISTS `GENERIC_VNF_LICENSE_MANAGEMENT` (
  `vnf_id` varchar(80) NOT NULL,
  `att_uuid` varchar(80) NOT NULL,
  PRIMARY KEY (`vnf_id`,`att_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_VNF_LINTERFACE`
--

CREATE TABLE IF NOT EXISTS `GENERIC_VNF_LINTERFACE` (
  `vnf_id` varchar(80) NOT NULL,
  `interface_name` varchar(255) NOT NULL,
  `interface_role` varchar(45) DEFAULT NULL,
  `v6_wan_link_ip` varchar(45) DEFAULT NULL,
  `selflink` varchar(128) DEFAULT NULL,
  `interface_id` varchar(45) DEFAULT NULL,
  `macaddr` varchar(64) DEFAULT NULL,
  `network_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`vnf_id`,`interface_name`),
  KEY `FK_GENERIC_VNF_LINTERFACE_GENERIC_VNF_IDX` (`vnf_id`),
  CONSTRAINT `FK_GENERIC_VNF_LINTERFACE_GENERIC_VNF` FOREIGN KEY (`vnf_id`) REFERENCES `GENERIC_VNF` (`vnf_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_VNF_PSERVER`
--

CREATE TABLE IF NOT EXISTS `GENERIC_VNF_PSERVER` (
  `vnf_id` varchar(64) NOT NULL,
  `hostname` varchar(255) NOT NULL,
  PRIMARY KEY (`vnf_id`,`hostname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_VNF_SERVICE_INSTANCE`
--

CREATE TABLE IF NOT EXISTS `GENERIC_VNF_SERVICE_INSTANCE` (
  `vnf_id` varchar(64) NOT NULL,
  `service_instance_id` varchar(255) NOT NULL,
  `relationship_key` varchar(64) NOT NULL,
  `relationship_value` varchar(64) DEFAULT NULL,
  `global_customer_id` varchar(255) DEFAULT NULL,
  `service_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`vnf_id`,`service_instance_id`,`relationship_key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_VNF_VNF_IMAGE`
--

CREATE TABLE IF NOT EXISTS `GENERIC_VNF_VNF_IMAGE` (
  `vnf_id` varchar(64) NOT NULL,
  `att_uuid` varchar(255) NOT NULL,
  PRIMARY KEY (`vnf_id`,`att_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_VNF_VSERVER`
--

CREATE TABLE IF NOT EXISTS `GENERIC_VNF_VSERVER` (
  `vnf_id` varchar(80) NOT NULL,
  `vserver_id` varchar(128) NOT NULL,
  `tenant_id` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`vnf_id`,`vserver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GENERIC_VPN_BINDING`
--

CREATE TABLE IF NOT EXISTS `GENERIC_VPN_BINDING` (
  `vpn_id` varchar(80) NOT NULL,
  `vpn_name` varchar(80) NOT NULL,
  `global_route_target` varchar(80) NOT NULL,
  PRIMARY KEY (`vpn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `GET_CONFIG_TEMPLATE`
--

CREATE TABLE IF NOT EXISTS `GET_CONFIG_TEMPLATE` (
  `get_config_template_id` int(11) NOT NULL AUTO_INCREMENT,
  `vnf_type` varchar(50) NOT NULL,
  `device_interface_protocol_id` int(11) NOT NULL,
  `xml_processing` varchar(1) DEFAULT NULL,
  `xml_protocol` varchar(30) DEFAULT NULL,
  `template` longtext,
  PRIMARY KEY (`get_config_template_id`),
  UNIQUE KEY `get_config_template_id` (`get_config_template_id`),
  KEY `get_config_template_ibfk_1` (`device_interface_protocol_id`),
  CONSTRAINT `get_config_template_ibfk_1` FOREIGN KEY (`device_interface_protocol_id`) REFERENCES `DEVICE_INTERFACE_PROTOCOL` (`device_interface_protocol_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `LOCATION`
--

CREATE TABLE IF NOT EXISTS `LOCATION` (
  `loc_id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(150) NOT NULL,
  `city_code_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`loc_id`),
  KEY `IN1_LOCATION_IDX` (`city_code_id`),
  CONSTRAINT `FK1_LOCATION` FOREIGN KEY (`city_code_id`) REFERENCES `CITY_CODE` (`city_code_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=327 DEFAULT CHARSET=latin1;

--
-- Table structure for table `HOSTNAME`
--

CREATE TABLE IF NOT EXISTS `HOSTNAME` (
  `hostname` varchar(21) NOT NULL,
  `parent_hostname` varchar(21) DEFAULT NULL,
  `cust_id` int(11) NOT NULL,
  `loc_id` int(11) NOT NULL,
  `site_sequence` varchar(2) NOT NULL,
  `server_sequence` varchar(2) NOT NULL,
  `activation_code` varchar(11) DEFAULT NULL,
  `vnf_sequence` varchar(2) DEFAULT NULL,
  `vendor_code` varchar(1) NOT NULL,
  `virtual_device_type` varchar(2) DEFAULT NULL,
  `device_sequence` varchar(3) DEFAULT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`hostname`),
  KEY `IN1_HOSTNAME` (`cust_id`),
  KEY `IN2_HOSTNAME` (`loc_id`),
  KEY `IN3_HOSTNAME` (`vendor_code`),
  KEY `IN4_HOSTNAME` (`parent_hostname`),
  CONSTRAINT `FK1_HOSTNAME` FOREIGN KEY (`cust_id`) REFERENCES `CUSTOMER` (`cust_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK2_HOSTNAME` FOREIGN KEY (`loc_id`) REFERENCES `LOCATION` (`loc_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK4_HOSTNAME` FOREIGN KEY (`parent_hostname`) REFERENCES `HOSTNAME` (`hostname`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `IPV4_ADDRESS_POOL`
--

CREATE TABLE IF NOT EXISTS `IPV4_ADDRESS_POOL` (
  `aic_site_id` varchar(100) NOT NULL,
  `universe` varchar(40) NOT NULL,
  `status` varchar(40) NOT NULL,
  `ipv4_addr` varchar(20) NOT NULL,
  PRIMARY KEY (`ipv4_addr`,`universe`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `LINK_MASTER`
--

CREATE TABLE IF NOT EXISTS `LINK_MASTER` (
  `link_interface_ip` varchar(20) NOT NULL,
  `source_crs_name` varchar(20) NOT NULL,
  `destination_crs_name` varchar(20) NOT NULL,
  `max_reserved_bw` int(11) DEFAULT NULL,
  `default_cost` int(11) DEFAULT NULL,
  `bundle_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`link_interface_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `LINTERFACE_VLAN`
--

CREATE TABLE IF NOT EXISTS `LINTERFACE_VLAN` (
  `vnf_id` varchar(80) NOT NULL,
  `interface_name` varchar(255) NOT NULL,
  `vlan_interface` varchar(255) NOT NULL,
  `vlan_id_inner` varchar(64) DEFAULT NULL,
  `vlan_id_outer` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`vnf_id`,`interface_name`,`vlan_interface`),
  KEY `FK_LINTERFACE_VLAN_GENERIC_VNF_LINTERFACE_IDX` (`vnf_id`,`interface_name`),
  CONSTRAINT `FK_LINTERFACE_VLAN_GENERIC_VNF_LINTERFACE` FOREIGN KEY (`vnf_id`, `interface_name`) REFERENCES `GENERIC_VNF_LINTERFACE` (`vnf_id`, `interface_name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `MAX_PORT_SPEED`
--

CREATE TABLE IF NOT EXISTS `MAX_PORT_SPEED` (
  `max_port_speed_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `image_file_name` varchar(50) NOT NULL,
  `end_point_position` varchar(50) NOT NULL,
  `interface_name` varchar(100) NOT NULL,
  `max_speed` bigint(20) NOT NULL,
  `unit` varchar(10) NOT NULL,
  PRIMARY KEY (`max_port_speed_id`),
  UNIQUE KEY `max_port_speed_id` (`max_port_speed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `MAX_SERVER_SPEED`
--

CREATE TABLE IF NOT EXISTS `MAX_SERVER_SPEED` (
  `max_server_speed_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `server_model` varchar(50) NOT NULL,
  `evc_count` smallint(6) NOT NULL,
  `max_speed` bigint(20) NOT NULL,
  `unit` varchar(10) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`max_server_speed_id`),
  UNIQUE KEY `max_server_speed_id` (`max_server_speed_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Table structure for table `NAMING_POLICY_VM_NAME_INDEX`
--

CREATE TABLE IF NOT EXISTS `NAMING_POLICY_VM_NAME_INDEX` (
  `vm_name_prefix` varchar(255) NOT NULL,
  `index_number` int(11) NOT NULL,
  PRIMARY KEY (`vm_name_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NAMING_POLICY_VNFC_NAME_INDEX`
--

CREATE TABLE IF NOT EXISTS `NAMING_POLICY_VNFC_NAME_INDEX` (
  `vnfc_name_prefix` varchar(255) NOT NULL,
  `index_number` int(11) NOT NULL,
  PRIMARY KEY (`vnfc_name_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NBNC_ASSIGN_VPN_OVERRIDE`
--

CREATE TABLE IF NOT EXISTS `NBNC_ASSIGN_VPN_OVERRIDE` (
  `vpn_id` varchar(12) NOT NULL DEFAULT '',
  `vpn_rt` varchar(16) NOT NULL DEFAULT '',
  `service_type` varchar(16) NOT NULL DEFAULT '',
  `be_location` varchar(16) NOT NULL DEFAULT '',
  `be_type` varchar(32) NOT NULL DEFAULT '',
  `be_id` varchar(32) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`vpn_id`,`vpn_rt`,`service_type`,`be_location`,`be_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NBNC_BORDER_ELEMENT`
--

CREATE TABLE IF NOT EXISTS `NBNC_BORDER_ELEMENT` (
  `be_id` varchar(32) NOT NULL,
  `be_type` varchar(16) NOT NULL,
  `be_name` varchar(32) DEFAULT NULL,
  `be_host_vnf_id` varchar(32) DEFAULT NULL,
  `service_type` varchar(16) DEFAULT NULL,
  `tangibility` varchar(16) DEFAULT NULL,
  `usage_order` smallint(6) DEFAULT NULL,
  `vlan_start` smallint(6) DEFAULT NULL,
  `vlan_end` smallint(6) DEFAULT NULL,
  `ipv4_subnet` varchar(18) DEFAULT NULL,
  `ipv6_subnet` varchar(68) DEFAULT NULL,
  `network_ip` varchar(48) DEFAULT NULL,
  `be_location` varchar(16) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `updated_timestamp` timestamp NULL DEFAULT NULL,
  `log_link_model_uuid` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`be_id`,`be_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NBNC_IPE`
--

CREATE TABLE IF NOT EXISTS `NBNC_IPE` (
  `ipe_name` varchar(32) NOT NULL,
  `ipe_location` varchar(16) DEFAULT NULL,
  `ipe_ip_address` varchar(16) DEFAULT NULL,
  `ipe_id` varchar(8) DEFAULT NULL,
  `service_type_array` varchar(512) DEFAULT NULL,
  `ipe_status` varchar(32) DEFAULT NULL,
  `updated_timestamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ipe_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NBNC_IPE_PORT`
--

CREATE TABLE IF NOT EXISTS `NBNC_IPE_PORT` (
  `port_id` varchar(16) NOT NULL,
  `ipe_name` varchar(32) NOT NULL,
  `be_id` varchar(32) NOT NULL,
  `be_type` varchar(16) NOT NULL,
  `port_type` varchar(16) DEFAULT NULL,
  `ae_name` varchar(16) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `updated_timestamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`port_id`,`ipe_name`,`be_id`,`be_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NBNC_MAPPING_SBG_BGF`
--

CREATE TABLE IF NOT EXISTS `NBNC_MAPPING_SBG_BGF` (
  `asbg_vlan` smallint(6) NOT NULL,
  `bgf_vlan` smallint(6) NOT NULL,
  PRIMARY KEY (`asbg_vlan`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NBNC_SERVICE`
--

CREATE TABLE IF NOT EXISTS `NBNC_SERVICE` (
  `service_type` varchar(16) NOT NULL,
  `service_model_uuid` varchar(64) NOT NULL,
  `description` varchar(128) DEFAULT NULL,
  `created_timestamp` timestamp NULL DEFAULT NULL,
  `updated_timestamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`service_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NBNC_SERVICE_VLAN`
--

CREATE TABLE IF NOT EXISTS `NBNC_SERVICE_VLAN` (
  `be_id` varchar(32) NOT NULL,
  `vlan` smallint(6) NOT NULL,
  `service_type` varchar(16) DEFAULT NULL,
  `be_type` varchar(16) DEFAULT NULL,
  `be_name` varchar(32) DEFAULT NULL,
  `be_host_vnf_id` varchar(32) DEFAULT NULL,
  `be_location` varchar(16) DEFAULT NULL,
  `be_usage_order` smallint(6) DEFAULT NULL,
  `vlan_usage_order` smallint(6) DEFAULT NULL,
  `status` varchar(16) DEFAULT 'AVAILABLE',
  `request_id` varchar(64) DEFAULT NULL,
  `service_instance_id` varchar(64) DEFAULT NULL,
  `vni_id` varchar(16) DEFAULT NULL,
  `customer_id` varchar(16) DEFAULT NULL,
  `ipe1_router_name` varchar(32) DEFAULT NULL,
  `ipe1_port_id` varchar(16) DEFAULT NULL,
  `ipe1_ae_name` varchar(16) DEFAULT NULL,
  `ipe2_router_name` varchar(32) DEFAULT NULL,
  `ipe2_port_id` varchar(16) DEFAULT NULL,
  `ipe2_ae_name` varchar(16) DEFAULT NULL,
  `available_timestamp` timestamp NULL DEFAULT NULL,
  `allocated_timestamp` timestamp NULL DEFAULT NULL,
  `disabled_timestamp` timestamp NULL DEFAULT NULL,
  `enabled_timestamp` timestamp NULL DEFAULT NULL,
  `vpn_id` varchar(12) DEFAULT NULL,
  `vpn_rt` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`be_id`,`vlan`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NCS_EXPECTED_ASYNC_REQUESTS`
--

CREATE TABLE IF NOT EXISTS `NCS_EXPECTED_ASYNC_REQUESTS` (
  `ncs_request_id` varchar(255) NOT NULL,
  `mso_gp_request_id` varchar(255) NOT NULL,
  `service_instance_id` varchar(255) NOT NULL,
  `sdn_module_name` varchar(255) NOT NULL,
  `sdn_rpc_name` varchar(255) NOT NULL,
  `sdn_service_action` varchar(255) DEFAULT NULL,
  `ncs_rpc` varchar(255) NOT NULL,
  `ncs_sub_action` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'inProgress',
  `creation_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ncs_request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NETWORK_INSTANCE_NAME_INDEX`
--

CREATE TABLE IF NOT EXISTS `NETWORK_INSTANCE_NAME_INDEX` (
  `network_instance_name_prefix` varchar(255) NOT NULL,
  `index_number` int(11) NOT NULL,
  PRIMARY KEY (`network_instance_name_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `SERVICE_MODEL`
--

CREATE TABLE IF NOT EXISTS `SERVICE_MODEL` (
  `service_uuid` varchar(255) NOT NULL,
  `model_yaml` longblob,
  `invariant_uuid` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `ecomp_naming` char(1) DEFAULT NULL,
  `service_instance_name_prefix` varchar(255) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `naming_policy` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`service_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `NETWORK_MODEL`
--

CREATE TABLE IF NOT EXISTS `NETWORK_MODEL` (
  `customization_uuid` varchar(255) NOT NULL,
  `service_uuid` varchar(255) NOT NULL,
  `model_yaml` longblob,
  `invariant_uuid` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `network_type` varchar(255) DEFAULT NULL,
  `network_role` varchar(255) DEFAULT NULL,
  `network_technology` varchar(255) DEFAULT NULL,
  `trunk_network_indicator` char(1) DEFAULT NULL,
  `network_scope` varchar(255) DEFAULT NULL,
  `naming_policy` varchar(255) DEFAULT NULL,
  `ecomp_generated_naming` char(1) DEFAULT NULL,
  `is_shared_network` char(1) DEFAULT NULL,
  `is_external_network` char(1) DEFAULT NULL,
  `is_provider_network` char(1) DEFAULT NULL,
  `physical_network_name` varchar(255) DEFAULT NULL,
  `is_bound_to_vpn` char(1) DEFAULT NULL,
  `vpn_binding` varchar(255) DEFAULT NULL,
  `use_ipv4` char(1) DEFAULT NULL,
  `ipv4_dhcp_enabled` char(1) DEFAULT NULL,
  `ipv4_ip_version` char(1) DEFAULT NULL,
  `ipv4_cidr_mask` varchar(255) DEFAULT NULL,
  `eipam_v4_address_plan` varchar(255) DEFAULT NULL,
  `use_ipv6` char(1) DEFAULT NULL,
  `ipv6_dhcp_enabled` char(1) DEFAULT NULL,
  `ipv6_ip_version` char(1) DEFAULT NULL,
  `ipv6_cidr_mask` varchar(255) DEFAULT NULL,
  `eipam_v6_address_plan` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customization_uuid`),
  KEY `FK_NETWORK_MODEL` (`service_uuid`),
  CONSTRAINT `FK_NETWORK_MODEL` FOREIGN KEY (`service_uuid`) REFERENCES `SERVICE_MODEL` (`service_uuid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NETWORK_PROFILE`
--

CREATE TABLE IF NOT EXISTS `NETWORK_PROFILE` (
  `network_type` varchar(100) NOT NULL,
  `technology` varchar(100) NOT NULL,
  PRIMARY KEY (`network_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NETWORK_ROLE_VPN_BINDING`
--

CREATE TABLE IF NOT EXISTS `NETWORK_ROLE_VPN_BINDING` (
  `network_role` varchar(80) NOT NULL,
  `vpn_id` varchar(80) NOT NULL,
  PRIMARY KEY (`network_role`,`vpn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `NODE_TYPES`
--

CREATE TABLE IF NOT EXISTS `NODE_TYPES` (
  `nodetype` varchar(80) NOT NULL,
  PRIMARY KEY (`nodetype`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `OBJECT_GROUPING`
--

CREATE TABLE IF NOT EXISTS `OBJECT_GROUPING` (
  `group_id` varchar(128) NOT NULL,
  `group_type` varchar(128) NOT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `OBJECT_GROUP_MEMBER_TRACKING`
--

CREATE TABLE IF NOT EXISTS `OBJECT_GROUP_MEMBER_TRACKING` (
  `group_id` varchar(128) NOT NULL,
  `key_id` varchar(128) NOT NULL,
  `key_type` varchar(128) NOT NULL,
  PRIMARY KEY (`group_id`,`key_id`,`key_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `PARAMETERS`
--

CREATE TABLE IF NOT EXISTS `PARAMETERS` (
  `name` varchar(100) NOT NULL,
  `value` varchar(128) NOT NULL,
  `category` varchar(24) DEFAULT NULL,
  `memo` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `PE_INV`
--

CREATE TABLE IF NOT EXISTS `PE_INV` (
  `EQUIP_ID` int(11) DEFAULT NULL,
  `EQUIP_TYPE` varchar(20) DEFAULT NULL,
  `PTNII_EQUIP_NAME` varchar(20) DEFAULT NULL,
  `IP_ADDR` varchar(15) DEFAULT NULL,
  `ROUTER_PROV_STATUS` varchar(50) DEFAULT NULL,
  `REGION` varchar(16) DEFAULT NULL,
  `COUNTRY_ABBR` varchar(50) DEFAULT NULL,
  `EQUIP_NAME_CODE` varchar(50) DEFAULT NULL,
  `AS_NUMBER` varchar(5) DEFAULT NULL,
  `LOOPBACK1` varchar(15) DEFAULT NULL,
  `LOOPBACK2` varchar(15) DEFAULT NULL,
  `LOOPBACK3` varchar(15) DEFAULT NULL,
  `LOOPBACK40` varchar(15) DEFAULT NULL,
  `LOOPBACK65535` varchar(15) DEFAULT NULL,
  `INMS_LIST` varchar(20) DEFAULT NULL,
  `ENCRYPTED_ACCESS_FLAG` varchar(50) DEFAULT NULL,
  `SW_NAME` varchar(100) DEFAULT NULL,
  `NMIPADDR` varchar(15) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT NULL,
  `MOD_DATE` datetime DEFAULT NULL,
  `FCN_CODE` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `PHYSICAL_LINK`
--

CREATE TABLE IF NOT EXISTS `PHYSICAL_LINK` (
  `link_name` varchar(255) NOT NULL,
  `speed_value` varchar(64) DEFAULT NULL,
  `speed_units` varchar(64) DEFAULT NULL,
  `circuit_id` varchar(255) NOT NULL,
  `dual_mode` varchar(64) NOT NULL,
  PRIMARY KEY (`link_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `PHYSICAL_LINK_PINTERFACE`
--

CREATE TABLE IF NOT EXISTS `PHYSICAL_LINK_PINTERFACE` (
  `link_name` varchar(255) NOT NULL,
  `hostname` varchar(255) NOT NULL,
  `port_name_ft` varchar(255) NOT NULL,
  PRIMARY KEY (`link_name`,`hostname`,`port_name_ft`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `PINTERFACE`
--

CREATE TABLE IF NOT EXISTS `PINTERFACE` (
  `hostname` varchar(255) NOT NULL,
  `port_name_ft` varchar(255) NOT NULL,
  `interface_name` varchar(255) DEFAULT '',
  `physical_speed` varchar(255) DEFAULT '',
  `physical_units` varchar(255) DEFAULT '',
  `port_description` varchar(255) DEFAULT '',
  PRIMARY KEY (`hostname`,`port_name_ft`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `POLICY_UPDATE_NOTIFICATION`
--

CREATE TABLE IF NOT EXISTS `POLICY_UPDATE_NOTIFICATION` (
  `policy_name` varchar(255) NOT NULL,
  `version_id` varchar(255) NOT NULL,
  `update_type` varchar(255) NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`policy_name`,`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `PORTAL_USERS`
--

CREATE TABLE IF NOT EXISTS `PORTAL_USERS` (
  `email` varchar(64) NOT NULL,
  `password` varbinary(255) NOT NULL,
  `privilege` char(1) NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `PREPARE_FILE_RELATIONSHIP`
--

CREATE TABLE IF NOT EXISTS `PREPARE_FILE_RELATIONSHIP` (
  `prepare_file_relationship_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_instance_id` varchar(50) DEFAULT NULL,
  `request_id` varchar(255) DEFAULT NULL,
  `config_file_id` int(11) DEFAULT NULL,
  `asdc_artifacts_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`prepare_file_relationship_id`),
  UNIQUE KEY `prepare_file_relationship_id` (`prepare_file_relationship_id`),
  KEY `ie_prepare_file_relationship` (`config_file_id`),
  KEY `ie2_prepare_file_relationship` (`asdc_artifacts_id`),
  CONSTRAINT `prepare_file_relationship_ibfk_2` FOREIGN KEY (`asdc_artifacts_id`) REFERENCES `ASDC_ARTIFACTS` (`asdc_artifacts_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `prepare_file_replationship_ibfk_1` FOREIGN KEY (`config_file_id`) REFERENCES `CONFIGFILES` (`config_file_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `PRE_LOAD_VNF_DATA`
--

CREATE TABLE IF NOT EXISTS `PRE_LOAD_VNF_DATA` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `svc_request_id` varchar(100) DEFAULT '',
  `svc_action` varchar(40) DEFAULT '',
  `status` varchar(10) NOT NULL DEFAULT 'pending',
  `filename` varchar(100) NOT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `preload_data` longblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=295 DEFAULT CHARSET=latin1;

--
-- Table structure for table `PRE_LOAD_VNF_NETWORK_DATA`
--

CREATE TABLE IF NOT EXISTS `PRE_LOAD_VNF_NETWORK_DATA` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `svc_request_id` varchar(100) DEFAULT '',
  `svc_action` varchar(40) DEFAULT '',
  `status` varchar(10) NOT NULL DEFAULT 'pending',
  `filename` varchar(100) NOT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `preload_data` longblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=278 DEFAULT CHARSET=latin1;

--
-- Table structure for table `PSERVER`
--

CREATE TABLE IF NOT EXISTS `PSERVER` (
  `hostname` varchar(255) NOT NULL,
  `ptnii_equip_name` varchar(255) DEFAULT '',
  `number_of_cpus` varchar(255) DEFAULT '',
  `disk_in_gigabytes` varchar(255) DEFAULT '',
  `ram_in_megabytes` varchar(255) DEFAULT '',
  `equip_type` varchar(255) DEFAULT '',
  `equip_vendor` varchar(255) DEFAULT '',
  `equip_model` varchar(255) DEFAULT '',
  `fqdn` varchar(255) DEFAULT '',
  `pserver_selflink` varchar(255) DEFAULT '',
  `ipv4_oam_address` varchar(40) DEFAULT NULL,
  `serial_number` varchar(255) DEFAULT '',
  `pserver_id` varchar(255) DEFAULT '',
  `internet_topology` varchar(40) DEFAULT '',
  `aic_site_id` varchar(100) DEFAULT '',
  `in_maint` varchar(5) DEFAULT '',
  `pserver_name2` varchar(255) DEFAULT '',
  `purpose` varchar(255) DEFAULT '',
  PRIMARY KEY (`hostname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `RANGE_RULE`
--

CREATE TABLE IF NOT EXISTS `RANGE_RULE` (
  `range_rule_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `range_name` varchar(50) NOT NULL,
  `service_model` varchar(50) NOT NULL,
  `end_point_position` varchar(50) NOT NULL,
  `equipment_level` varchar(50) NOT NULL,
  `min_value` int(11) NOT NULL,
  `max_value` int(11) NOT NULL,
  PRIMARY KEY (`range_rule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

--
-- Table structure for table `REQUEST_DETAILS`
--

CREATE TABLE IF NOT EXISTS `REQUEST_DETAILS` (
  `request_id` varchar(255) NOT NULL,
  `controller_id` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `service_rate` varchar(255) DEFAULT NULL,
  `service_instance_id` varchar(255) DEFAULT NULL,
  `service_type` varchar(255) DEFAULT NULL,
  `global_customer_id` varchar(255) DEFAULT NULL,
  `notification_url` varchar(255) DEFAULT NULL,
  `domain_requests` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `REQUEST_PROGRESS`
--

CREATE TABLE IF NOT EXISTS `REQUEST_PROGRESS` (
  `request_id` int(11) NOT NULL AUTO_INCREMENT,
  `request_type` varchar(20) DEFAULT NULL,
  `service_instance_id` varchar(80) NOT NULL,
  `request_instance_type` varchar(20) NOT NULL,
  `originating_service_instance_id` varchar(80) DEFAULT NULL,
  `originating_service_type` varchar(20) DEFAULT NULL,
  `overall_status` varchar(20) DEFAULT NULL,
  `status_date` varchar(80) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`request_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Table structure for table `REQUEST_PROGRESS_STATE`
--

CREATE TABLE IF NOT EXISTS `REQUEST_PROGRESS_STATE` (
  `request_progress_state_id` int(11) NOT NULL AUTO_INCREMENT,
  `request_id` int(11) DEFAULT NULL,
  `service_instance_id` varchar(80) NOT NULL,
  `request_instance_type` varchar(20) NOT NULL,
  `progress_state` varchar(30) DEFAULT NULL,
  `transaction_status` varchar(20) DEFAULT NULL,
  `status_date` varchar(80) DEFAULT NULL,
  `response_code` varchar(20) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`request_progress_state_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Table structure for table `RESOURCE`
--

CREATE TABLE IF NOT EXISTS `RESOURCE` (
  `resource_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` varchar(100) NOT NULL,
  `resource_name` varchar(50) NOT NULL,
  `resource_type` enum('Limit','Label','Range') NOT NULL,
  `lt_used` bigint(20) DEFAULT NULL,
  `ll_label` varchar(50) DEFAULT NULL,
  `ll_reference_count` smallint(6) DEFAULT NULL,
  `rr_used` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`resource_id`),
  UNIQUE KEY `resource_id` (`resource_id`),
  UNIQUE KEY `IX1_RESOURCE` (`asset_id`,`resource_name`)
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=latin1;

--
-- Table structure for table `RESOURCE_LOAD`
--

CREATE TABLE IF NOT EXISTS `RESOURCE_LOAD` (
  `resource_load_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `resource_id` bigint(20) NOT NULL,
  `application_id` varchar(20) NOT NULL,
  `resource_load_time` datetime NOT NULL,
  `resource_expiration_time` datetime DEFAULT NULL,
  PRIMARY KEY (`resource_load_id`),
  UNIQUE KEY `resource_load_id` (`resource_load_id`),
  UNIQUE KEY `IX2_RESOURCE_LOAD` (`resource_id`,`application_id`),
  KEY `IX1_RESOURCE_LOAD` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `RESOURCE_LOCK`
--

CREATE TABLE IF NOT EXISTS `RESOURCE_LOCK` (
  `resource_lock_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `resource_name` varchar(256) DEFAULT NULL,
  `lock_holder` varchar(100) NOT NULL,
  `lock_count` smallint(6) NOT NULL,
  `lock_time` datetime NOT NULL,
  `expiration_time` datetime NOT NULL,
  PRIMARY KEY (`resource_lock_id`),
  UNIQUE KEY `resource_lock_id` (`resource_lock_id`),
  UNIQUE KEY `IX1_RESOURCE_LOCK` (`resource_name`)
) ENGINE=InnoDB AUTO_INCREMENT=29681 DEFAULT CHARSET=latin1;

--
-- Table structure for table `RESOURCE_RULE`
--

CREATE TABLE IF NOT EXISTS `RESOURCE_RULE` (
  `resource_rule_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `resource_name` varchar(50) NOT NULL,
  `service_model` varchar(50) NOT NULL,
  `end_point_position` varchar(50) NOT NULL,
  `service_expression` varchar(2000) NOT NULL,
  `equipment_level` varchar(50) NOT NULL,
  `equipment_expression` varchar(2000) NOT NULL,
  `allocation_expression` varchar(2000) NOT NULL,
  `soft_limit_expression` varchar(2000) NOT NULL,
  `hard_limit_expression` varchar(2000) NOT NULL,
  PRIMARY KEY (`resource_rule_id`),
  UNIQUE KEY `resource_rule_id` (`resource_rule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

--
-- Table structure for table `RESOURCE_THRESHOLD`
--

CREATE TABLE IF NOT EXISTS `RESOURCE_THRESHOLD` (
  `resource_threshold_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `resource_rule_id` bigint(20) NOT NULL,
  `threshold_expression` varchar(2000) NOT NULL,
  `threshold_message` varchar(2000) NOT NULL,
  PRIMARY KEY (`resource_threshold_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Table structure for table `ROUTER_MASTER`
--

CREATE TABLE IF NOT EXISTS `ROUTER_MASTER` (
  `crs_name` varchar(20) NOT NULL,
  `loopback_ip` varchar(20) NOT NULL,
  PRIMARY KEY (`crs_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `ROUTING_CHARACTERISTIC_MAPPING`
--

CREATE TABLE IF NOT EXISTS `ROUTING_CHARACTERISTIC_MAPPING` (
  `network_role` varchar(255) NOT NULL,
  `vrf_name` varchar(255) NOT NULL,
  `routing_characteristic` varchar(255) NOT NULL,
  PRIMARY KEY (`network_role`,`vrf_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `SERVICE_HOMING`
--

CREATE TABLE IF NOT EXISTS `SERVICE_HOMING` (
  `service_type` varchar(100) NOT NULL,
  `lata` int(3) NOT NULL,
  `hubbing_city_type` varchar(40) NOT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `primary_aic_site_name` varchar(100) NOT NULL,
  `secondary_aic_site_name` varchar(100) DEFAULT NULL,
  `tertiary_aic_site_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`service_type`,`lata`,`hubbing_city_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `SERVICE_HOMING_BACKUP`
--

CREATE TABLE IF NOT EXISTS `SERVICE_HOMING_BACKUP` (
  `service_type` varchar(100) NOT NULL,
  `lata` int(3) NOT NULL,
  `hubbing_city_type` varchar(40) NOT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `primary_aic_site_name` varchar(100) NOT NULL,
  `secondary_aic_site_name` varchar(100) DEFAULT NULL,
  `tertiary_aic_site_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`service_type`,`lata`,`hubbing_city_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `SERVICE_INSTANCE_NAME_INDEX`
--

CREATE TABLE IF NOT EXISTS `SERVICE_INSTANCE_NAME_INDEX` (
  `service_instance_name_prefix` varchar(255) NOT NULL,
  `index_number` int(11) NOT NULL,
  PRIMARY KEY (`service_instance_name_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `SERVICE_MANAGER_CREDENTIALS`
--

CREATE TABLE IF NOT EXISTS `SERVICE_MANAGER_CREDENTIALS` (
  `service_manager_username` varchar(255) NOT NULL,
  `service_manager_password` varbinary(255) NOT NULL,
  PRIMARY KEY (`service_manager_username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `SERVICE_PROXY`
--

CREATE TABLE IF NOT EXISTS `SERVICE_PROXY` (
  `port_mirror_service_uuid` varchar(255) NOT NULL,
  `service_proxy_name` varchar(255) NOT NULL,
  `source_service_uuid` varchar(255) NOT NULL,
  `resources_vendor` varchar(255) DEFAULT NULL,
  `resource_vendor_release` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `subcategory` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `role` varchar(255) NOT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `customization_uuid` varchar(255) DEFAULT NULL,
  `invariant_uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`port_mirror_service_uuid`,`service_proxy_name`),
  KEY `FK_SERVICE_PROXY_SOURCE_TO_SERVICE_MODE` (`source_service_uuid`),
  CONSTRAINT `FK_SERVICE_PROXY_MIRROR_TO_SERVICE_MODE` FOREIGN KEY (`port_mirror_service_uuid`) REFERENCES `SERVICE_MODEL` (`service_uuid`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `SERVICE_RESOURCE`
--

CREATE TABLE IF NOT EXISTS `SERVICE_RESOURCE` (
  `service_resource_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `service_instance_id` varchar(80) NOT NULL,
  `service_status` enum('Active','Pending') NOT NULL,
  `service_change_number` smallint(6) NOT NULL,
  `resource_set_id` varchar(100) NOT NULL,
  `resource_union_id` varchar(100) NOT NULL,
  PRIMARY KEY (`service_instance_id`,`service_change_number`),
  UNIQUE KEY `service_resource_id` (`service_resource_id`),
  KEY `IX1_SERVICE_RESOURCE` (`service_instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=955 DEFAULT CHARSET=latin1;

--
-- Table structure for table `SERVICE_TYPE_MAPPING`
--

CREATE TABLE IF NOT EXISTS `SERVICE_TYPE_MAPPING` (
  `sdnc_service_type` varchar(128) NOT NULL,
  `ncs_service_type` varchar(128) NOT NULL,
  PRIMARY KEY (`sdnc_service_type`,`ncs_service_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `SUBNETPOOL_MAPPING`
--

CREATE TABLE IF NOT EXISTS `SUBNETPOOL_MAPPING` (
  `aic_cloud_region` varchar(16) NOT NULL,
  `ntc` varchar(32) NOT NULL,
  `lcp` varchar(32) NOT NULL,
  `aic_region_id` varchar(255) NOT NULL,
  PRIMARY KEY (`aic_cloud_region`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `SUPPORTED_SEQUENCE_NUMBER`
--

CREATE TABLE IF NOT EXISTS `SUPPORTED_SEQUENCE_NUMBER` (
  `resource_sequence_number` varchar(10) NOT NULL,
  `resource_type` varchar(10) NOT NULL,
  PRIMARY KEY (`resource_sequence_number`,`resource_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `SVC_LOGIC`
--

CREATE TABLE IF NOT EXISTS `SVC_LOGIC` (
  `module` varchar(80) NOT NULL,
  `rpc` varchar(80) NOT NULL,
  `version` varchar(40) NOT NULL,
  `mode` varchar(5) NOT NULL,
  `active` varchar(1) NOT NULL,
  `graph` longblob,
  `modified_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `md5sum` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`module`,`rpc`,`version`,`mode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `TABLE_CLEANUP_CONFIGURATION`
--

CREATE TABLE IF NOT EXISTS `TABLE_CLEANUP_CONFIGURATION` (
  `table_name` varchar(255) NOT NULL COMMENT 'The name of the table the cleanup will be performed on',
  `days_old` int(11) NOT NULL COMMENT 'Records older than the current date minus DAYS_OLD will be deleted',
  `date_column` varchar(255) NOT NULL COMMENT 'The name of the column containing the date to be checked',
  `commit_interval` int(11) NOT NULL DEFAULT '2500' COMMENT 'The maximum number of rows a commit may contain',
  `query_clause` varchar(1000) DEFAULT NULL COMMENT 'An optional additional query clause to further restrict deletion criteria',
  `child_table_name` varchar(255) DEFAULT NULL,
  `child_table_pk` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`table_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='This table will be used by the table clean-up script, tableCleanup.sh, to drive what tables should be purged and what the purge criteria are.';

--
-- Table structure for table `TASK_TEMPLATE`
--

CREATE TABLE IF NOT EXISTS `TASK_TEMPLATE` (
  `task_template_id` int(11) NOT NULL AUTO_INCREMENT,
  `request_type` varchar(20) DEFAULT NULL,
  `task_name` varchar(30) NOT NULL,
  `task_category` varchar(50) NOT NULL,
  `ecomp_task` varchar(50) NOT NULL,
  `initial_load` varchar(1) NOT NULL,
  `service` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`task_template_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

--
-- Table structure for table `TENANT`
--

CREATE TABLE IF NOT EXISTS `TENANT` (
  `tenant_id` varchar(255) NOT NULL,
  `tenant_name` varchar(255) NOT NULL,
  `service_instance_id` varchar(255) NOT NULL,
  PRIMARY KEY (`tenant_id`,`tenant_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `TESTTBL`
--

CREATE TABLE IF NOT EXISTS `TESTTBL` (
  `pk` varchar(25) NOT NULL,
  `col1` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `THRESHOLD_NOTIFICATION`
--

CREATE TABLE IF NOT EXISTS `THRESHOLD_NOTIFICATION` (
  `resource_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `threshold_expression` varchar(2000) DEFAULT NULL,
  `threshold_message` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `TMP_AIC_AVAIL_ZONE_POOL`
--

CREATE TABLE IF NOT EXISTS `TMP_AIC_AVAIL_ZONE_POOL` (
  `aic_site_id` varchar(100) NOT NULL,
  `status` varchar(40) NOT NULL,
  `availability_zone` varchar(100) NOT NULL,
  `token` int(4) NOT NULL,
  `vnf_id` varchar(80) DEFAULT NULL,
  `service_type` varchar(100) NOT NULL,
  `vnf_type` varchar(20) DEFAULT NULL,
  `hypervisor` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`aic_site_id`,`availability_zone`,`token`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `TOPOLOGY_PARAMETER`
--

CREATE TABLE IF NOT EXISTS `TOPOLOGY_PARAMETER` (
  `parameter_id` int(11) NOT NULL,
  `parameter_name` varchar(20) NOT NULL,
  `parameter_set` int(11) NOT NULL,
  `create_update_time` datetime NOT NULL,
  `create_update_user` varchar(40) NOT NULL,
  PRIMARY KEY (`parameter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `TOPOLOGY_PARAMETER_ENTRIES`
--

CREATE TABLE IF NOT EXISTS `TOPOLOGY_PARAMETER_ENTRIES` (
  `parameter_entry_id` int(11) NOT NULL,
  `parameter_name` varchar(255) NOT NULL,
  `parameter_value` varchar(64) NOT NULL,
  `create_update_time` datetime NOT NULL,
  `create_update_user` varchar(40) NOT NULL,
  PRIMARY KEY (`parameter_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `TOPOLOGY_PARAMETER_TO_ENTRIES`
--

CREATE TABLE IF NOT EXISTS `TOPOLOGY_PARAMETER_TO_ENTRIES` (
  `parameter_id` int(11) DEFAULT NULL,
  `parameter_entry_id` int(11) DEFAULT NULL,
  `entry_order` int(11) DEFAULT NULL,
  `create_update_time` datetime DEFAULT NULL,
  `create_update_user` varchar(40) NOT NULL,
  KEY `FK1_TOPOLOGY_PARAMETER_TO_ENTRIES` (`parameter_id`),
  KEY `FK2_TOPOLOGY_PARAMETER_TO_ENTRIES` (`parameter_entry_id`),
  CONSTRAINT `FK1_TOPOLOGY_PARAMETER_TO_ENTRIES` FOREIGN KEY (`parameter_id`) REFERENCES `TOPOLOGY_PARAMETER` (`parameter_id`),
  CONSTRAINT `FK2_TOPOLOGY_PARAMETER_TO_ENTRIES` FOREIGN KEY (`parameter_entry_id`) REFERENCES `TOPOLOGY_PARAMETER_ENTRIES` (`parameter_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `TOPOLOGY_LOGICAL_RELATION_TO_PINTERFACE`
--

CREATE TABLE IF NOT EXISTS `TOPOLOGY_LOGICAL_RELATION_TO_PINTERFACE` (
  `interface_name` varchar(255) NOT NULL,
  `interface_id` varchar(255) NOT NULL,
  `pnf_name` varchar(255) NOT NULL,
  `pnf_id` varchar(255) NOT NULL,
  `controller_id` varchar(255) DEFAULT NULL,
  `rate` varchar(255) DEFAULT NULL,
  `clli` varchar(255) DEFAULT NULL,
  `connection_point` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`interface_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `TRANSACTION_LOG`
--

CREATE TABLE IF NOT EXISTS `TRANSACTION_LOG` (
  `serial_key` int(10) NOT NULL AUTO_INCREMENT,
  `log_time` varchar(40) NOT NULL,
  `request_id` varchar(80) DEFAULT NULL,
  `svc_request_id` varchar(80) DEFAULT NULL,
  `x_ecomp_request_id` varchar(80) DEFAULT NULL,
  `graph_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`serial_key`)
) ENGINE=InnoDB AUTO_INCREMENT=249 DEFAULT CHARSET=latin1;


--
-- Table structure for table `UPLOAD_CONFIG`
--

CREATE TABLE IF NOT EXISTS `UPLOAD_CONFIG` (
  `upload_config_id` int(11) NOT NULL AUTO_INCREMENT,
  `request_id` varchar(50) DEFAULT NULL,
  `originator_id` varchar(50) DEFAULT NULL,
  `service_description` varchar(100) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `upload_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `vnf_id` varchar(50) DEFAULT NULL,
  `vnf_name` varchar(50) DEFAULT NULL,
  `vm_name` varchar(50) DEFAULT NULL,
  `vnf_type` varchar(50) DEFAULT NULL,
  `vnfc_type` varchar(50) DEFAULT NULL,
  `host_ip_address` varchar(50) DEFAULT NULL,
  `config_indicator` varchar(25) DEFAULT NULL,
  `pending_delete` varchar(1) DEFAULT NULL,
  `content` longtext,
  PRIMARY KEY (`upload_config_id`),
  UNIQUE KEY `upload_config_id` (`upload_config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Table structure for table `USED_SEQUENCE_NUMBER`
--

CREATE TABLE IF NOT EXISTS `USED_SEQUENCE_NUMBER` (
  `resource_sequence_number` varchar(10) NOT NULL,
  `resource_type` varchar(10) NOT NULL,
  `zone_region_id` varchar(50) NOT NULL,
  PRIMARY KEY (`resource_sequence_number`,`resource_type`,`zone_region_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `USER_TRACE`
--

CREATE TABLE IF NOT EXISTS `USER_TRACE` (
  `user_trace_seq` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `identity` varchar(12) DEFAULT NULL,
  `action` varchar(128) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`user_trace_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=392 DEFAULT CHARSET=latin1;

--
-- Table structure for table `VENDOR_CODE`
--

CREATE TABLE IF NOT EXISTS `VENDOR_CODE` (
  `vendor_code` varchar(1) NOT NULL,
  `vendor` varchar(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`vendor_code`,`vendor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VFC_MODEL`
--

CREATE TABLE IF NOT EXISTS `VFC_MODEL` (
  `customization_uuid` varchar(255) NOT NULL,
  `model_yaml` longblob,
  `invariant_uuid` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `naming_policy` varchar(255) DEFAULT NULL,
  `ecomp_generated_naming` char(1) DEFAULT NULL,
  `nfc_function` varchar(255) DEFAULT NULL,
  `nfc_naming_code` varchar(255) DEFAULT NULL,
  `vm_type` varchar(255) DEFAULT NULL,
  `vm_type_tag` varchar(255) DEFAULT NULL,
  `vm_image_name` varchar(255) DEFAULT NULL,
  `vm_flavor_name` varchar(255) DEFAULT NULL,
  `high_availability` varchar(255) DEFAULT NULL,
  `nfc_naming` varchar(255) DEFAULT NULL,
  `min_instances` int(11) DEFAULT NULL,
  `max_instances` int(11) DEFAULT NULL,
  PRIMARY KEY (`customization_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VFC_TO_NETWORK_ROLE_MAPPING`
--

CREATE TABLE IF NOT EXISTS `VFC_TO_NETWORK_ROLE_MAPPING` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `vfc_customization_uuid` varchar(255) NOT NULL,
  `network_role` varchar(255) NOT NULL,
  `vm_type` varchar(255) DEFAULT NULL,
  `network_role_tag` varchar(255) DEFAULT NULL,
  `ipv4_count` int(11) NOT NULL,
  `ipv6_count` int(11) NOT NULL,
  `ipv4_use_dhcp` char(1) DEFAULT NULL,
  `ipv6_use_dhcp` char(1) DEFAULT NULL,
  `ipv4_ip_version` char(1) DEFAULT NULL,
  `ipv6_ip_version` char(1) DEFAULT NULL,
  `extcp_subnetpool_id` varchar(512) DEFAULT NULL,
  `ipv4_floating_count` int(11) DEFAULT NULL,
  `ipv6_floating_count` int(11) DEFAULT NULL,
  `ipv4_address_plan_name` varchar(512) DEFAULT NULL,
  `ipv6_address_plan_name` varchar(512) DEFAULT NULL,
  `ipv4_vrf_name` varchar(512) DEFAULT NULL,
  `ipv6_vrf_name` varchar(512) DEFAULT NULL,
  `subnet_role` varchar(255) DEFAULT NULL,
  `subinterface_indicator` char(1) DEFAULT NULL,
  PRIMARY KEY (`seq`),
  KEY `IX1_VFC_TO_NETWORK_ROLE_MAPPING` (`vfc_customization_uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=1791 DEFAULT CHARSET=latin1;

--
-- Table structure for table `VF_MODEL`
--

CREATE TABLE IF NOT EXISTS `VF_MODEL` (
  `customization_uuid` varchar(255) NOT NULL,
  `model_yaml` longblob,
  `invariant_uuid` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `naming_policy` varchar(255) DEFAULT NULL,
  `ecomp_generated_naming` char(1) DEFAULT NULL,
  `avail_zone_max_count` int(11) DEFAULT NULL,
  `nf_function` varchar(255) DEFAULT NULL,
  `nf_code` varchar(255) DEFAULT NULL,
  `nf_type` varchar(255) DEFAULT NULL,
  `nf_role` varchar(255) DEFAULT NULL,
  `vendor` varchar(255) DEFAULT NULL,
  `vendor_version` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customization_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VF_MODULE_MODEL`
--

CREATE TABLE IF NOT EXISTS `VF_MODULE_MODEL` (
  `customization_uuid` varchar(255) NOT NULL,
  `model_yaml` longblob,
  `invariant_uuid` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `vf_module_type` varchar(255) DEFAULT NULL,
  `availability_zone_count` int(11) DEFAULT NULL,
  `ecomp_generated_vm_assignments` char(1) DEFAULT NULL,
  PRIMARY KEY (`customization_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VF_MODULE_TO_VFC_MAPPING`
--

CREATE TABLE IF NOT EXISTS `VF_MODULE_TO_VFC_MAPPING` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `vf_module_customization_uuid` varchar(255) NOT NULL,
  `vfc_customization_uuid` varchar(255) NOT NULL,
  `vm_type` varchar(255) NOT NULL,
  `vm_count` int(11) NOT NULL,
  PRIMARY KEY (`seq`),
  KEY `IX1_VF_MODULE_TO_VFC_MAPPING` (`vf_module_customization_uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=1591 DEFAULT CHARSET=latin1;

--
-- Table structure for table `VF_TO_NETWORK_ROLE_MAPPING`
--

CREATE TABLE IF NOT EXISTS `VF_TO_NETWORK_ROLE_MAPPING` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `vf_customization_uuid` varchar(255) NOT NULL,
  `network_role` varchar(255) NOT NULL,
  PRIMARY KEY (`seq`),
  KEY `IX1_VF_TO_NETWORK_ROLE_MAPPING` (`vf_customization_uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=348 DEFAULT CHARSET=latin1;

--
-- Table structure for table `VIPR_CONFIGURATION`
--

CREATE TABLE IF NOT EXISTS `VIPR_CONFIGURATION` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(255) DEFAULT NULL,
  `vnf_id` varchar(255) DEFAULT NULL,
  `vnf_name` varchar(255) DEFAULT NULL,
  `ecomp_service_instance_id` varchar(255) DEFAULT NULL,
  `vm_name` varchar(255) DEFAULT NULL,
  `cloud_region_id` varchar(255) DEFAULT NULL,
  `cloud_owner` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1;

--
-- Table structure for table `VIPR_SZ_MANAGER_KEY`
--

CREATE TABLE IF NOT EXISTS `VIPR_SZ_MANAGER_KEY` (
  `vipr_sz_manager_ip_addr` varchar(40) NOT NULL,
  `vipr_sz_manager_state` varchar(10) DEFAULT NULL,
  `vipr_sz_manager_api_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`vipr_sz_manager_ip_addr`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VLAN_ID_POOL`
--

CREATE TABLE IF NOT EXISTS `VLAN_ID_POOL` (
  `aic_site_id` varchar(100) NOT NULL,
  `purpose` varchar(40) NOT NULL,
  `status` varchar(40) NOT NULL,
  `vlan_id` int(4) NOT NULL,
  `svc_instance_id` varchar(80) DEFAULT NULL,
  `availability_zone` varchar(100) DEFAULT NULL,
  `vplspe_name` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`vlan_id`,`aic_site_id`,`purpose`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VLAN_L3INTERFACE_IPV4_ADDRESS`
--

CREATE TABLE IF NOT EXISTS `VLAN_L3INTERFACE_IPV4_ADDRESS` (
  `vnf_id` varchar(80) NOT NULL,
  `interface_name` varchar(255) NOT NULL,
  `vlan_interface` varchar(255) NOT NULL,
  `l3_interface_ipv4_address` varchar(64) NOT NULL,
  `l3_interface_ipv4_prefix_length` varchar(45) DEFAULT NULL,
  `vlan_id_inner` varchar(45) DEFAULT NULL,
  `vlan_id_outer` varchar(45) DEFAULT NULL,
  `is_floating` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`vnf_id`,`interface_name`,`vlan_interface`,`l3_interface_ipv4_address`),
  KEY `FK_VLAN_L3INTERFACE_IPV4_ADDRESS_LINTERFACE_VLAN_IDX` (`vnf_id`,`interface_name`),
  CONSTRAINT `FK_VLAN_L3INTERFACE_IPV4_ADDRESS_LINTERFACE_VLAN` FOREIGN KEY (`vnf_id`, `interface_name`, `vlan_interface`) REFERENCES `LINTERFACE_VLAN` (`vnf_id`, `interface_name`, `vlan_interface`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VLAN_L3INTERFACE_IPV6_ADDRESS`
--

CREATE TABLE IF NOT EXISTS `VLAN_L3INTERFACE_IPV6_ADDRESS` (
  `vnf_id` varchar(80) NOT NULL,
  `interface_name` varchar(255) NOT NULL,
  `vlan_interface` varchar(255) NOT NULL,
  `l3_interface_ipv6_address` varchar(64) NOT NULL,
  `l3_interface_ipv6_prefix_length` varchar(45) DEFAULT NULL,
  `vlan_id_inner` varchar(45) DEFAULT NULL,
  `vlan_id_outer` varchar(45) DEFAULT NULL,
  `is_floating` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`vnf_id`,`interface_name`,`vlan_interface`,`l3_interface_ipv6_address`),
  KEY `FK_VLAN_L3INTERFACE_IPV6_ADDRESS_LINTERFACE_VLAN_IDX` (`vnf_id`,`interface_name`,`vlan_interface`),
  CONSTRAINT `FK_VLAN_L3INTERFACE_IPV6_ADDRESS_LINTERFACE_VLAN` FOREIGN KEY (`vnf_id`, `interface_name`, `vlan_interface`) REFERENCES `LINTERFACE_VLAN` (`vnf_id`, `interface_name`, `vlan_interface`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VLAN_PLAN_ID`
--

CREATE TABLE IF NOT EXISTS `VLAN_PLAN_ID` (
  `plan_type` varchar(40) NOT NULL,
  `purpose` varchar(40) NOT NULL,
  `vlan_plan_id_count` int(4) NOT NULL,
  PRIMARY KEY (`vlan_plan_id_count`,`plan_type`,`purpose`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VLAN_POOL`
--

CREATE TABLE IF NOT EXISTS `VLAN_POOL` (
  `aic_site_id` varchar(100) NOT NULL,
  `availability_zone` varchar(100) NOT NULL,
  `vlan_plan_id` varchar(100) NOT NULL,
  `plan_type` varchar(40) NOT NULL,
  `purpose` varchar(40) NOT NULL,
  `vlan_id` int(4) NOT NULL,
  `status` varchar(40) NOT NULL,
  `reserved_id` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`aic_site_id`,`availability_zone`,`vlan_plan_id`,`plan_type`,`purpose`,`vlan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VLAN_RANGES`
--

CREATE TABLE IF NOT EXISTS `VLAN_RANGES` (
  `vlan_plan_id` varchar(100) NOT NULL,
  `plan_type` varchar(40) NOT NULL,
  `purpose` varchar(40) NOT NULL,
  `range_start` int(4) NOT NULL,
  `range_end` int(4) NOT NULL,
  `generated` char(1) DEFAULT NULL,
  PRIMARY KEY (`vlan_plan_id`,`plan_type`,`purpose`,`range_start`,`range_end`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VM_NAME_INDEX`
--

CREATE TABLE IF NOT EXISTS `VM_NAME_INDEX` (
  `vm_name_prefix` varchar(255) NOT NULL,
  `index_number` int(11) NOT NULL,
  PRIMARY KEY (`vm_name_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VM_NETWORKS`
--

CREATE TABLE IF NOT EXISTS `VM_NETWORKS` (
  `vnf_type` varchar(200) NOT NULL,
  `vm_type` varchar(45) NOT NULL,
  `network_role` varchar(45) NOT NULL,
  `assign_ips` tinyint(1) NOT NULL,
  `assign_macs` tinyint(1) NOT NULL,
  `assign_floating_ip` tinyint(1) NOT NULL,
  `ip_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`vnf_type`,`vm_type`,`network_role`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VM_PROFILE`
--

CREATE TABLE IF NOT EXISTS `VM_PROFILE` (
  `vnf_type` varchar(200) NOT NULL,
  `vm_type` varchar(45) NOT NULL,
  `vm_count` int(11) NOT NULL,
  PRIMARY KEY (`vnf_type`,`vm_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNF`
--

CREATE TABLE IF NOT EXISTS `VNF` (
  `vnf_id` varchar(80) NOT NULL,
  `vnf_name` varchar(80) NOT NULL,
  `vnf_type` varchar(10) NOT NULL,
  `orchestration_status` varchar(20) DEFAULT NULL,
  `heat_stack_id` varchar(80) DEFAULT NULL,
  `mso_catalog_key` varchar(80) DEFAULT NULL,
  `availability_zone` varchar(80) DEFAULT NULL,
  `aic_site_id` varchar(80) DEFAULT NULL,
  `oam_ipv4_address` varchar(20) DEFAULT NULL,
  `vnf_name2` varchar(80) DEFAULT NULL,
  `vpe_id` varchar(80) NOT NULL,
  `ipv4_loopback0_address` varchar(80) DEFAULT NULL,
  `license_key` varchar(256) DEFAULT NULL,
  `entitlement_resource_uuid` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`vnf_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNFC_DG_MAPPING`
--

CREATE TABLE IF NOT EXISTS `VNFC_DG_MAPPING` (
  `vnfc_dg_mapping_id` int(11) NOT NULL AUTO_INCREMENT,
  `action` varchar(50) DEFAULT NULL,
  `api_version` varchar(10) DEFAULT NULL,
  `vnf_type` varchar(50) DEFAULT NULL,
  `vnfc_type` varchar(50) DEFAULT NULL,
  `dg_name` varchar(50) NOT NULL,
  `dg_version` varchar(50) DEFAULT NULL,
  `dg_module` varchar(50) NOT NULL,
  PRIMARY KEY (`vnfc_dg_mapping_id`),
  UNIQUE KEY `input_constraint` (`action`,`api_version`,`vnf_type`,`vnfc_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNFC_REFERENCE`
--

CREATE TABLE IF NOT EXISTS `VNFC_REFERENCE` (
  `vnfc_reference_id` int(11) NOT NULL AUTO_INCREMENT,
  `action` varchar(50) NOT NULL,
  `vnf_type` varchar(50) NOT NULL,
  `vm_instance` int(11) NOT NULL,
  `vnfc_instance` int(11) NOT NULL,
  `vnfc_type` varchar(50) NOT NULL,
  `vnfc_function_code` varchar(50) NOT NULL,
  `ipaddress_v4_oam_vip` varchar(50) DEFAULT NULL,
  `group_notation_type` varchar(50) DEFAULT NULL,
  `group_notation_value` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`vnfc_reference_id`),
  UNIQUE KEY `vnfc_reference_id` (`vnfc_reference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNF_IMAGE`
--

CREATE TABLE IF NOT EXISTS `VNF_IMAGE` (
  `application_vendor` varchar(255) NOT NULL,
  `application_version` varchar(255) NOT NULL,
  `att_uuid` varchar(255) NOT NULL,
  `application` varchar(255) DEFAULT NULL,
  `selflink` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`application_vendor`,`application_version`,`att_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNF_MODEL_LICENSES`
--

CREATE TABLE IF NOT EXISTS `VNF_MODEL_LICENSES` (
  `att_part_number` varchar(255) NOT NULL,
  `license_assignment_group` varchar(255) NOT NULL,
  `license_required` tinyint(1) DEFAULT NULL,
  `entitlement_assignment_group` varchar(255) DEFAULT NULL,
  `entitlement_required` tinyint(1) DEFAULT '0',
  `feature_group_uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`att_part_number`,`license_assignment_group`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNF_MODEL_LICENSE_FEATURES`
--

CREATE TABLE IF NOT EXISTS `VNF_MODEL_LICENSE_FEATURES` (
  `att_part_number` varchar(255) NOT NULL,
  `license_assignment_group` varchar(255) NOT NULL,
  `feature` varchar(255) NOT NULL,
  PRIMARY KEY (`att_part_number`,`license_assignment_group`,`feature`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNF_NAME_INDEX`
--

CREATE TABLE IF NOT EXISTS `VNF_NAME_INDEX` (
  `vnf_name_prefix` varchar(255) NOT NULL,
  `index_number` int(11) NOT NULL,
  PRIMARY KEY (`vnf_name_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNF_NETWORKS`
--

CREATE TABLE IF NOT EXISTS `VNF_NETWORKS` (
  `vnf_type` varchar(200) NOT NULL,
  `network_role` varchar(45) NOT NULL,
  PRIMARY KEY (`vnf_type`,`network_role`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNF_NETWORK_CONNECTION`
--

CREATE TABLE IF NOT EXISTS `VNF_NETWORK_CONNECTION` (
  `connection_uuid` varchar(80) NOT NULL,
  `vnf_id` varchar(80) NOT NULL,
  `connection_id` varchar(80) DEFAULT NULL,
  `connection_type` varchar(20) DEFAULT NULL,
  `neutron_network_id` varchar(80) DEFAULT NULL,
  `neutron_network_name` varchar(80) DEFAULT NULL,
  `orchestration_status` varchar(20) DEFAULT NULL,
  `switch_id` varchar(40) DEFAULT NULL,
  `heat_stack_id` varchar(80) DEFAULT NULL,
  `mso_catalog_key` varchar(80) DEFAULT NULL,
  `provider_network` varchar(80) DEFAULT NULL,
  `port_group_id` varchar(80) DEFAULT NULL,
  `port_group_name` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`connection_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNF_NETWORK_CONNECTION_VLAN`
--

CREATE TABLE IF NOT EXISTS `VNF_NETWORK_CONNECTION_VLAN` (
  `vlan_uuid` varchar(80) NOT NULL,
  `vlan_id` int(4) NOT NULL,
  `vlan_type` varchar(5) NOT NULL,
  `connection_uuid` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`vlan_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNF_PROFILE`
--

CREATE TABLE IF NOT EXISTS `VNF_PROFILE` (
  `vnf_type` varchar(200) NOT NULL,
  `availability_zone_count` int(11) NOT NULL,
  `equipment_role` varchar(80) NOT NULL,
  PRIMARY KEY (`vnf_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VNF_SERVICE_TO_NETWORK_ROLE_FILTER`
--

CREATE TABLE IF NOT EXISTS `VNF_SERVICE_TO_NETWORK_ROLE_FILTER` (
  `vnf_service_type` varchar(60) NOT NULL,
  `network_role_filter` varchar(60) NOT NULL,
  PRIMARY KEY (`vnf_service_type`,`network_role_filter`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VPE_LOCK`
--

CREATE TABLE IF NOT EXISTS `VPE_LOCK` (
  `vpe_name` varchar(20) NOT NULL,
  `vpn_lock` varchar(20) NOT NULL,
  PRIMARY KEY (`vpe_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VPE_MAC_ADDRESS_POOL`
--

CREATE TABLE IF NOT EXISTS `VPE_MAC_ADDRESS_POOL` (
  `id` int(11) NOT NULL,
  `mac_address` varchar(50) NOT NULL,
  `sw_name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VPE_MAC_ADDRESS_TO_HOSTNAME_MAPPING`
--

CREATE TABLE IF NOT EXISTS `VPE_MAC_ADDRESS_TO_HOSTNAME_MAPPING` (
  `id` int(11) NOT NULL,
  `hostname` varchar(50) NOT NULL,
  `assigned_user` varchar(25) NOT NULL,
  `assigned_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VPE_POOL`
--

CREATE TABLE IF NOT EXISTS `VPE_POOL` (
  `vpe_name` varchar(20) NOT NULL,
  `ipv4_oam_address` varchar(20) NOT NULL,
  `loopback0_ipv4_address` varchar(20) NOT NULL,
  `provisioning_status` varchar(10) NOT NULL,
  `aic_site_id` varchar(100) NOT NULL,
  `availability_zone` varchar(100) NOT NULL,
  `vlan_id_outer` varchar(20) NOT NULL,
  `vendor` varchar(20) NOT NULL,
  `physical_intf_name` varchar(40) NOT NULL,
  `physical_intf_speed` varchar(20) NOT NULL,
  `physical_intf_units` varchar(20) NOT NULL,
  `vpe_uuid` varchar(80) DEFAULT NULL,
  `vpe_id` varchar(80) NOT NULL,
  `image_filename` varchar(100) DEFAULT NULL,
  `as_number` varchar(20) NOT NULL,
  `loopback5000` varchar(16) DEFAULT NULL,
  `loopback10` varchar(16) DEFAULT NULL,
  `aic_version` varchar(50) DEFAULT NULL,
  `vpe_capacity` int(11) NOT NULL,
  PRIMARY KEY (`aic_site_id`,`vpe_name`,`availability_zone`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VPLSPE_POOL`
--

CREATE TABLE IF NOT EXISTS `VPLSPE_POOL` (
  `vplspe_name` varchar(20) NOT NULL,
  `aic_site_id` varchar(100) NOT NULL,
  `availability_zone` varchar(100) NOT NULL,
  `physical_intf_name` varchar(40) NOT NULL,
  `physical_intf_speed` varchar(20) NOT NULL,
  `physical_intf_units` varchar(20) NOT NULL,
  `loopback0_ipv4_address` varchar(20) NOT NULL,
  `vlan_id_outer` varchar(20) NOT NULL,
  `vplspe_uuid` varchar(80) DEFAULT NULL,
  `image_filename` varchar(100) DEFAULT NULL,
  `provisioning_status` varchar(10) DEFAULT NULL,
  `vendor` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`vplspe_name`,`aic_site_id`,`availability_zone`,`physical_intf_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VPN_BINDINGS`
--

CREATE TABLE IF NOT EXISTS `VPN_BINDINGS` (
  `network_customization_uuid` varchar(255) NOT NULL,
  `binding_uuid` varchar(255) NOT NULL,
  PRIMARY KEY (`network_customization_uuid`,`binding_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VRR_FUNCTION_CODE_VMTYPE_MAPPING`
--

CREATE TABLE IF NOT EXISTS `VRR_FUNCTION_CODE_VMTYPE_MAPPING` (
  `ptnii_function_code` varchar(128) NOT NULL,
  `vm_type` varchar(128) NOT NULL,
  PRIMARY KEY (`ptnii_function_code`,`vm_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VSERVER`
--

CREATE TABLE IF NOT EXISTS `VSERVER` (
  `tenant_id` varchar(40) NOT NULL,
  `vserver_id` varchar(40) NOT NULL,
  `aic_site_id` varchar(100) NOT NULL,
  `vendor` varchar(20) NOT NULL,
  `image_name` varchar(100) NOT NULL,
  `vnf_type` varchar(10) NOT NULL,
  `vnf_id` varchar(80) NOT NULL,
  PRIMARY KEY (`tenant_id`,`vserver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VSERVER2`
--

CREATE TABLE IF NOT EXISTS `VSERVER2` (
  `tenant_id` varchar(255) NOT NULL,
  `vserver_id` varchar(128) NOT NULL,
  `vserver_name` varchar(255) NOT NULL,
  `vserver_name2` varchar(255) DEFAULT NULL,
  `prov_status` varchar(20) DEFAULT NULL,
  `selflink` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`tenant_id`,`vserver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VSERVER_PSERVER`
--

CREATE TABLE IF NOT EXISTS `VSERVER_PSERVER` (
  `vserver_id` varchar(128) NOT NULL,
  `pserver_hostname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`vserver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `VVIG_VM_INSTANCE_TO_CLOUD_REGION_MAPPING`
--

CREATE TABLE IF NOT EXISTS `VVIG_VM_INSTANCE_TO_CLOUD_REGION_MAPPING` (
  `key_id` varchar(128) NOT NULL,
  `cloud_region` varchar(128) NOT NULL,
  `key_type` varchar(128) NOT NULL,
  PRIMARY KEY (`key_id`,`cloud_region`,`key_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `WAN_COMBO_ALLOWABLE`
--

CREATE TABLE IF NOT EXISTS `WAN_COMBO_ALLOWABLE` (
  `combo_sequence` int(11) NOT NULL AUTO_INCREMENT,
  `topology` varchar(16) DEFAULT 'unknown',
  `internet_topology` varchar(20) DEFAULT NULL,
  `wan1` varchar(40) DEFAULT NULL,
  `wan2` varchar(40) DEFAULT NULL,
  `new_start_release_flexware` varchar(16) DEFAULT 'unknown',
  `is_active_flexware` varchar(1) DEFAULT 'N',
  `new_start_release_dhv` varchar(16) DEFAULT 'unknown',
  `is_active_dhv` varchar(1) DEFAULT 'N',
  `ucpe_type` varchar(32) DEFAULT 'stand-alone',
  `description` varchar(128) NOT NULL,
  PRIMARY KEY (`combo_sequence`),
  UNIQUE KEY `IX1_WAN_COMBO_ALLOWABLE` (`internet_topology`,`wan1`,`wan2`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `DHCP_MAP` (
  `mac_addr` varchar(128) NOT NULL,
  `ip_addr` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`mac_addr`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `RESOURCE_GROUP_TO_TARGET_NODE_MAPPING` (
  `group_uuid` varchar(255) NOT NULL,
  `parent_uuid` varchar(255) NOT NULL,
  `target_node_uuid` varchar(255) NOT NULL,
  `target_type` varchar(255) NULL,
  `table_name` varchar(255) NULL,
  PRIMARY KEY (`group_uuid`, `parent_uuid`, `target_node_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE IF NOT EXISTS `ATTRIBUTE_VALUE_PAIR` (
  `resource_uuid` varchar(255) NOT NULL,
  `attribute_name` varchar(255) NOT NULL,
  `resource_type` varchar(255) NOT NULL,
  `attribute_value` varchar(255) DEFAULT NULL,
  `resource_customization_uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`resource_uuid`,`attribute_name`,`resource_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `COMPLEX_RESOURCE` (
  `uuid` varchar(255) NOT NULL,
  `model_yaml` longblob,
  `invariant_uuid` varchar(255) NOT NULL,
  `customization_uuid` varchar(255) NOT NULL,
  `version` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`uuid`,`customization_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `NODE_CAPABILITY` (
  `capability_id` int(11) NOT NULL AUTO_INCREMENT,
  `capability_provider_uuid` varchar(255) NOT NULL,
  `capability_provider_customization_uuid` varchar(255) NOT NULL,
  `capability_name` varchar(255) DEFAULT NULL,
  `capability_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`capability_id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `NODE_REQUIREMENT` (
  `requirement_id` int(11) NOT NULL AUTO_INCREMENT,
  `capability_id` int(11) DEFAULT NULL,
  `capability_provider_uuid` varchar(255) DEFAULT NULL,
  `capability_provider_customization_uuid` varchar(255) DEFAULT NULL,
  `capability_consumer_uuid` varchar(255) NOT NULL,
  `capability_consumer_customization_uuid` varchar(255) NOT NULL,
  `requirement_name` varchar(255) NOT NULL,
  PRIMARY KEY (`requirement_id`),
  KEY `NODE_REQUIREMENT_TO_NODE_CAPABILITY` (`capability_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `RELATED_NETWORK_ROLE` (
  `network_model_customization_uuid` varchar(255) NOT NULL,
  `related_network_role` varchar(255) NOT NULL,
  PRIMARY KEY (`network_model_customization_uuid`,`related_network_role`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `RESOURCE_GROUP` (
  `resource_uuid` varchar(255) NOT NULL,
  `group_uuid` varchar(255) NOT NULL,
  `group_customization_uuid` varchar(255) DEFAULT NULL,
  `group_invariant_uuid` varchar(255) NOT NULL,
  `group_name` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `group_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`resource_uuid`,`group_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `RESOURCE_POLICY` (
  `resource_uuid` varchar(255) NOT NULL,
  `policy_uuid` varchar(255) NOT NULL,
  `policy_customization_uuid` varchar(255) DEFAULT NULL,
  `policy_invariant_uuid` varchar(255) NOT NULL,
  `policy_name` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `policy_type` varchar(255) DEFAULT NULL,
  `property_type` varchar(255) DEFAULT NULL,
  `property_source` varchar(255) DEFAULT NULL,
  `property_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`resource_uuid`,`policy_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `RESOURCE_POLICY_TO_TARGET_NODE_MAPPING` (
  `policy_uuid` varchar(255) NOT NULL,
  `parent_uuid` varchar(255) NOT NULL,
  `target_node_uuid` varchar(255) NOT NULL,
  `target_type` varchar(255) DEFAULT NULL,
  `target_node_customization_uuid` varchar(255) DEFAULT NULL,
  `policy_customization_uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`policy_uuid`,`parent_uuid`,`target_node_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `SERVICE_MODEL_TO_COMPLEX_RESOURCE_MAPPING` (
  `service_uuid` varchar(255) NOT NULL,
  `complex_resource_uuid` varchar(255) NOT NULL,
  `complex_resource_customization_uuid` varchar(255) NOT NULL,
  PRIMARY KEY (`service_uuid`,`complex_resource_uuid`,`complex_resource_customization_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `VFC_RELATED_NETWORK_ROLE` (
  `vfc_customization_uuid` varchar(255) NOT NULL,
  `vm_type` varchar(255) NOT NULL,
  `network_role` varchar(255) NOT NULL,
  `related_network_role` varchar(255) NOT NULL,
  PRIMARY KEY (`vfc_customization_uuid`,`vm_type`,`network_role`,`related_network_role`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `VNF_RELATED_NETWORK_ROLE` (
  `vnf_customization_uuid` varchar(255) NOT NULL,
  `network_role` varchar(255) NOT NULL,
  `related_network_role` varchar(255) NOT NULL,
  PRIMARY KEY (`vnf_customization_uuid`,`network_role`,`related_network_role`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

