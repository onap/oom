USE camundabpmn;

INSERT INTO `act_id_group` (`ID_`, `REV_`, `NAME_`, `TYPE_`) VALUES ('camunda-admin',1,'camunda BPM Administrators','SYSTEM');

INSERT INTO `act_id_user` (`ID_`, `REV_`, `FIRST_`, `LAST_`, `EMAIL_`, `PWD_`, `SALT_`, `PICTURE_ID_`) VALUES ('admin',1,'admin','user','camundaadmin@onap.org','{SHA-512}p9Y4lC0X70X5ihfqGTNz/NDuWRbAgtnlEfjbYLMHLp0tMl//B7ujc80MLcHWlJ+jIG14uWTI6AqQYp6PykCxZg==','2vEsAj7cap7XEidkrd4BVg==',NULL);

INSERT INTO `act_id_membership` (`USER_ID_`, `GROUP_ID_`) VALUES ('admin','camunda-admin');

INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68bc7a75-9cdc-11e7-a63d-0242ac120003',1,1,NULL,'admin',1,'admin',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68c13566-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,2,'camunda-admin',2);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68c4dee7-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,0,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68ca5d28-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,1,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68cd9179-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,2,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68d0ecda-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,3,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68d384eb-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,4,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68d5a7cc-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,5,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68d83fdd-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,6,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68dad7ee-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,7,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68dd48ef-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,8,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68e0a450-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,9,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68e31551-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,10,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68e5ad62-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,11,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68e908c3-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,12,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68eb52b4-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,13,'*',2147483647);
INSERT INTO `act_ru_authorization` (`ID_`, `REV_`, `TYPE_`, `GROUP_ID_`, `USER_ID_`, `RESOURCE_TYPE_`, `RESOURCE_ID_`, `PERMS_`) VALUES ('68edeac5-9cdc-11e7-a63d-0242ac120003',1,1,'camunda-admin',NULL,14,'*',2147483647);

