USE authz;

// Create Root pass
INSERT INTO cred (id,ns,type,cred,expires)
  VALUES ('dgl@openecomp.org','org.openecomp',1,0xab3831f27b39d7a039f9a92aa2bbfe51,'2020-12-31');

INSERT INTO cred (id,ns,type,cred,expires)
  VALUES ('m99751@dmaapBC.openecomp.org','org.openecomp.dmaapBC',1,0xab3831f27b39d7a039f9a92aa2bbfe51,'2020-12-31');

INSERT INTO cred (id,ns,type,cred,expires)
  VALUES ('m99501@dmaapBC.openecomp.org','org.openecomp.dmaapBC',1,0xab3831f27b39d7a039f9a92aa2bbfe51,'2020-12-31');


// Create 'com' root NS
INSERT INTO ns (name,scope,description,parent,type)
  VALUES('com',1,'Root Namespace',null,1);

INSERT INTO role(ns, name, perms, description)
  VALUES('com','admin',{'com.access|*|*'},'Com Admins');

INSERT INTO role(ns, name, perms, description)
  VALUES('com','owner',{'com.access|*|read'},'Com Owners');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('com','access','*','read',{'com.owner'},'Com Read Access');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('com','access','*','*',{'com.admin'},'Com Write Access');

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','com.owner','2020-12-31','com','owner');

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','com.admin','2020-12-31','com','admin');

// Create org root NS
INSERT INTO ns (name,scope,description,parent,type)
  VALUES('org',1,'Root Namespace Org',null,1);

INSERT INTO ns (name,scope,description,parent,type)
  VALUES('org.openecomp.dcae',3,'DCAE Namespace Org','org.openecomp',3);

INSERT INTO ns (name,scope,description,parent,type)
  VALUES('org.openecomp.dmaapBC',3,'DMaaP BC Namespace Org','org.openecomp',3);

INSERT INTO role(ns, name, perms, description)
  VALUES('org','admin',{'org.access|*|*'},'Com Admins');

INSERT INTO role(ns, name, perms, description)
  VALUES('org','owner',{'org.access|*|read'},'Com Owners');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org','access','*','read',{'org.owner'},'Com Read Access');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org','access','*','*',{'org.admin'},'Com Write Access');

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','org.owner','2020-12-31','org','owner');

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','org.admin','2020-12-31','org','admin');


// Create com.att

INSERT INTO ns (name,scope,description,parent,type)
  VALUES('com.att',2,'AT&T Namespace','com',2);

INSERT INTO role(ns, name, perms,description)
  VALUES('com.att','admin',{'com.att.access|*|*'},'AT&T Admins');

INSERT INTO role(ns, name, perms,description)
  VALUES('com.att','owner',{'com.att.access|*|read'},'AT&T Owners');

INSERT INTO perm(ns, type, instance, action, roles,description) 
  VALUES ('com.att','access','*','read',{'com.att.owner'},'AT&T Read Access');

INSERT INTO perm(ns, type, instance, action, roles,description) 
  VALUES ('com.att','access','*','*',{'com.att.admin'},'AT&T Write Access');

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','com.att.owner','2020-12-31','com.att','owner');

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','com.att.admin','2020-12-31','com.att','admin');

// Create com.att.aaf

INSERT INTO ns (name,scope,description,parent,type)
  VALUES('com.att.aaf',3,'Application Authorization Framework','com.att',3);

INSERT INTO role(ns, name, perms, description)
  VALUES('com.att.aaf','admin',{'com.att.aaf.access|*|*'},'AAF Admins');

INSERT INTO role(ns, name, perms, description)
  VALUES('com.att.aaf','owner',{'com.att.aaf.access|*|read'},'AAF Owners');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('com.att.aaf','access','*','read',{'com.att.aaf.owner'},'AAF Read Access');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('com.att.aaf','access','*','*',{'com.att.aaf.admin'},'AAF Write Access');

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','com.att.aaf.admin','2020-12-31','com.att.aaf','admin');
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','com.att.aaf.owner','2020-12-31','com.att.aaf','owner');
  

// Create org.openecomp
INSERT INTO ns (name,scope,description,parent,type)
  VALUES('org.openecomp',2,'Open EComp NS','com.att',2);

INSERT INTO role(ns, name, perms, description)
  VALUES('org.openecomp','admin',{'org.openecomp.access|*|*'},'OpenEcomp Admins');

INSERT INTO role(ns, name, perms, description)
  VALUES('org.openecomp','owner',{'org.openecomp.access|*|read'},'OpenEcomp Owners');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org.openecomp','access','*','read',{'org.openecomp.owner'},'OpenEcomp Read Access');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org.openecomp','access','*','*',{'org.openecomp.admin'},'OpenEcomp Write Access');

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','org.openecomp.admin','2020-12-31','org.openecomp','admin');

// Create org.openecomp.dmaapBC

INSERT INTO ns (name,scope,description,parent,type)
  VALUES('org.openecomp.dmaapBC',3,'Application Authorization Framework','org.openecomp',3);

//INSERT INTO role(ns, name, perms, description)
//  VALUES('org.openecomp.dmaapBC','admin',{'org.openecomp.dmaapBC.access|*|*'},'AAF Admins');

INSERT INTO role(ns, name, perms, description) 
VALUES('org.openecomp.dmaapBC','admin',{'org.openecomp.dmaapBC.access|*|*','org.openecomp.dmaapBC.topicFactory|:org.openecomp.dmaapBC.topic:org.openecomp.dmaapBC|create','org.openecomp.dmaapBC.mr.topic|:topic.org.openecomp.dmaapBC.newtopic|sub','org.openecomp.dmaapBC.mr.topic|:topic.org.openecomp.dmaapBC.newtopic|pub'},'AAF Admins');

//INSERT INTO role(ns, name, perms, description) 
//VALUES('org.openecomp.dmaapBC','admin',{'org.openecomp.dmaapBC.access|*|*','org.openecomp.dmaapBC.mr.topic|:topic.org.openecomp.dmaapBC.newtopic|sub'},'AAF Admins');

//INSERT INTO role(ns, name, perms, description) 
//VALUES('org.openecomp.dmaapBC','admin',{'org.openecomp.dmaapBC.access|*|*','org.openecomp.dmaapBC.mr.topic|:topic.org.openecomp.dmaapBC.newtopic|pub'},'AAF Admins');



INSERT INTO role(ns, name, perms, description)
  VALUES('org.openecomp.dmaapBC','owner',{'org.openecomp.dmaapBC.access|*|read'},'AAF Owners');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org.openecomp.dmaapBC','access','*','read',{'org.openecomp.dmaapBC.owner'},'AAF Read Access');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org.openecomp.dmaapBC','access','*','*',{'org.openecomp.dmaapBC.admin'},'AAF Write Access');

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','org.openecomp.dmaapBC.admin','2020-12-31','org.openecomp.dmaapBC','admin');
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('dgl@openecomp.org','org.openecomp.dmaapBC.owner','2020-12-31','org.openecomp.dmaapBC','owner');
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('m99751@dmaapBC.openecomp.org','org.openecomp.dmaapBC.admin','2020-12-31','org.openecomp.dmaapBC','admin');
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('m99751@dmaapBC.openecomp.org','org.openecomp.dmaapBC.owner','2020-12-31','org.openecomp.dmaapBC','owner');
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('m99501@dmaapBC.openecomp.org','org.openecomp.dmaapBC.admin','2020-12-31','org.openecomp.dmaapBC','admin');
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('m99501@dmaapBC.openecomp.org','org.openecomp.dmaapBC.owner','2020-12-31','org.openecomp.dmaapBC','owner');
