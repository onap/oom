USE camundabpmn;

INSERT INTO `act_id_user` VALUES ('admin',1,'admin','user','camundaadmin@openecomp.org','{SHA}Y7MVubSDgzJeaulJRLN2dFyNCyc=',NULL);

INSERT INTO `act_id_group` VALUES ('camunda-admin',1,'camunda BPM Administrators','SYSTEM');

INSERT INTO `act_id_membership` VALUES ('admin','camunda-admin');

INSERT INTO `act_ru_authorization` VALUES ('4ca68335-b7c5-11e6-b411-0242ac110003',1,1,NULL,'admin',1,'admin',2147483647),('4ca91b46-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,2,'camunda-admin',2),('4cab3e27-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,0,'*',2147483647),('4cadd638-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,1,'*',2147483647),('4caf0eb9-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,2,'*',2147483647),('4caff91a-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,3,'*',2147483647),('4cb10a8b-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,4,'*',2147483647),('4cb2430c-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,5,'*',2147483647),('4cb32d6d-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,6,'*',2147483647),('4cb43ede-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,7,'*',2147483647),('4cb5293f-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,8,'*',2147483647),('4cb5ec90-b7c5-11e6-b411-0242ac110003',1,1,'camunda-admin',NULL,9,'*',2147483647);
