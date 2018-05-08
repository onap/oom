USE `mso_catalog`;

ALTER TABLE  `mso_catalog`.`service_to_allotted_resources`
  ADD INDEX `fk_service_to_allotted_resources__service_model_uuid_idx` (`SERVICE_MODEL_UUID` ASC),
  ADD INDEX `fk_service_to_allotted_resources__allotted_resource_customiz_idx` (`AR_MODEL_CUSTOMIZATION_UUID` ASC),
  ADD CONSTRAINT `fk_service_to_allotted_resources__service__service_name_ver_id`
    FOREIGN KEY (`SERVICE_MODEL_UUID`)
    REFERENCES `mso_catalog`.`service` (`SERVICE_NAME_VERSION_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_service_to_allotted_resources__allotted_resource_customizat1`
    FOREIGN KEY (`AR_MODEL_CUSTOMIZATION_UUID`)
    REFERENCES `mso_catalog`.`allotted_resource_customization` (`MODEL_CUSTOMIZATION_UUID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE `mso_catalog`.`service_to_networks`
  ADD INDEX `fk_service_to_networks__service_model_uuid_idx` (`SERVICE_MODEL_UUID` ASC),
  ADD INDEX `fk_service_to_networks__network_resource_customization1_idx` (`NETWORK_MODEL_CUSTOMIZATION_UUID` ASC),
  ADD CONSTRAINT `fk_service_to_networks__service__service_name_version_id`
    FOREIGN KEY (`SERVICE_MODEL_UUID`)
    REFERENCES `mso_catalog`.`service` (`SERVICE_NAME_VERSION_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_service_to_networks__network_resource_customization1`
    FOREIGN KEY (`NETWORK_MODEL_CUSTOMIZATION_UUID`)
    REFERENCES `mso_catalog`.`network_resource_customization` (`MODEL_CUSTOMIZATION_UUID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE `mso_catalog`.`vf_module`
  ADD INDEX `UK_model_customization_uuid__asdc_service_model_version` (`MODEL_CUSTOMIZATION_UUID` ASC, `ASDC_SERVICE_MODEL_VERSION` ASC);

ALTER TABLE `mso_catalog`.`vnf_resource`
  ADD UNIQUE INDEX `UK_model_customization_uuid__asdc_service_model_version` (`MODEL_CUSTOMIZATION_UUID` ASC, `ASDC_SERVICE_MODEL_VERSION` ASC);

ALTER TABLE `mso_catalog`.`network_resource_customization`
  ADD INDEX `fk_network_resource_customization__network_resource_id_idx` (`NETWORK_RESOURCE_ID` ASC),
  ADD  CONSTRAINT `fk_network_resource_customization__network_resource__id`
    FOREIGN KEY (`NETWORK_RESOURCE_ID`)
    REFERENCES `mso_catalog`.`network_resource` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;