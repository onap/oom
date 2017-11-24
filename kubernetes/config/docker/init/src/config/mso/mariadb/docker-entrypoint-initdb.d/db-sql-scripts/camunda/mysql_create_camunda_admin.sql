USE camundabpmn;

INSERT INTO `act_id_group` (`ID_`, `REV_`, `NAME_`, `TYPE_`) VALUES ('camunda-admin',1,'camunda BPM Administrators','SYSTEM');

INSERT INTO `act_id_user` (`ID_`, `REV_`, `FIRST_`, `LAST_`, `EMAIL_`, `PWD_`, `SALT_`, `PICTURE_ID_`) VALUES ('admin',1,'admin','user','camundaadmin@onap.org','{SHA-512}n5jUw7fvXM9sZBcrIkLiAOCqiPHutaqEkbg6IQVQdylVP1im8SczBJf4f2xL7cvWwIAZjkcSSQzgFTsdaJSEiA==','ftTn4gNgMcq07wdSD0lEJQ==',NULL);

INSERT INTO `act_id_membership` (`USER_ID_`, `GROUP_ID_`) VALUES ('admin','camunda-admin');

INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49b0e028-a3c6-11e7-b0ec-0242ac120003',1,1,NULL,'admin',1,'admin',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49b525e9-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,2,'camunda-admin',2);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49b8814a-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,0,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49baa42b-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,1,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49bd8a5c-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,2,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49bfd44d-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,3,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49c1f72e-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,4,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49c41a0f-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,5,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49c77570-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,6,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49ca5ba1-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,7,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49cca592-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,8,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49ceef83-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,9,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49d11264-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,10,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49d38365-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,11,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49d5a646-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,12,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49d83e57-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,13,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('49da3a28-a3c6-11e7-b0ec-0242ac120003',1,1,'camunda-admin',NULL,14,'*',2147483647);
