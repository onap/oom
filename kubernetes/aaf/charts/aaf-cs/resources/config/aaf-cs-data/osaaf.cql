USE authz;

// Create 'org' root NS
INSERT INTO ns (name,description,parent,scope,type)
  VALUES('org','Root Namespace','.',1,1);

INSERT INTO role(ns, name, perms, description)
  VALUES('org','admin',{'org.access|*|*'},'Org Admins');

INSERT INTO role(ns, name, perms, description)
  VALUES('org','owner',{'org.access|*|read,approve'},'Org Owners');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org','access','*','read,approve',{'org.owner'},'Org Read Access');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org','access','*','*',{'org.admin'},'Org Write Access');

// Create Root pass
INSERT INTO cred (id,ns,type,cred,expires)
  VALUES ('initial@osaaf.org','org.osaaf',1,0x008c5926ca861023c1d2a36653fd88e2,'2099-12-31') using TTL 14400;

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('initial@osaaf.org','org.admin','2099-12-31','org','admin') using TTL 14400;


// Create org.osaaf
INSERT INTO ns (name,description,parent,scope,type)
  VALUES('org.osaaf','OSAAF Namespace','org',2,2);

INSERT INTO role(ns, name, perms,description)
  VALUES('org.osaaf','admin',{'org.osaaf.access|*|*'},'OSAAF Admins');

INSERT INTO perm(ns, type, instance, action, roles,description) 
  VALUES ('org.osaaf','access','*','*',{'org.osaaf.admin'},'OSAAF Write Access');

INSERT INTO role(ns, name, perms,description)
  VALUES('org.osaaf','owner',{'org.osaaf.access|*|read,approve'},'OSAAF Owners');

INSERT INTO perm(ns, type, instance, action, roles,description) 
  VALUES ('org.osaaf','access','*','read,appove',{'org.osaaf.owner'},'OSAAF Read Access');

// Create org.osaaf.aaf
INSERT INTO ns (name,description,parent,scope,type)
  VALUES('org.osaaf.aaf','Application Authorization Framework','org.osaaf',3,3);

INSERT INTO role(ns, name, perms, description)
  VALUES('org.osaaf.aaf','admin',{'org.osaaf.aaf.access|*|*'},'AAF Admins');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org.osaaf.aaf','access','*','*',{'org.osaaf.aaf.admin'},'AAF Write Access');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org.osaaf.aaf','access','*','read,approve',{'org.osaaf.aaf.owner'},'AAF Read Access');

INSERT INTO role(ns, name, perms, description)
  VALUES('org.osaaf.aaf','owner',{'org.osaaf.aaf.access|*|read,approve'},'AAF Owners');

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('initial@osaaf.org','org.osaaf.aaf.admin','2099-12-31','org.osaaf.aaf','admin') using TTL 14400;


// ONAP Specific Entities
// ONAP initial env Namespace
INSERT INTO ns (name,description,parent,scope,type)
  VALUES('org.onap','ONAP','org',2,2);

INSERT INTO ns (name,description,parent,scope,type)
  VALUES('org.onap.portal','ONAP Portal','org.onap.portal',3,3);

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org.onap.portal','access','*','read',{
    'org.onap.portal.owner','org.onap.portal.designer','org.onap.portal.tester','org.onap.portal.ops','org.onap.portal.governor'
  },'Portal Read Access');

INSERT INTO role(ns, name, perms, description)
  VALUES('org.onap.portal','owner',{'org.onap.portal.access|*|read'},'Portal Owner');

INSERT INTO perm(ns, type, instance, action, roles, description) 
  VALUES ('org.onap.portal','access','*','*',{'org.onap.portal.admin'},'Portal Write Access');

INSERT INTO role(ns, name, perms, description)
  VALUES('org.onap.portal','admin',{'org.onap.portal.access|*|*'},'Portal Admins');

// DEMO ID (OPS)
insert into cred (id,type,expires,cred,notes,ns,other) values('demo@people.osaaf.org',2,'2019-05-01',0xd993c5617486296f1b99d04de31633332b8ba1a550038e23860f9dbf0b2fcf95,'Initial ID','org.osaaf.people',53344);
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('demo@people.osaaf.org','org.onap.portal.admin','2018-10-31','org.onap.portal','admin');

// ADMIN
insert into cred (id,type,expires,cred,notes,ns,other) values('jh0003@people.osaaf.org',2,'2019-05-01',0xd993c5617486296f1b99d04de31633332b8ba1a550038e23860f9dbf0b2fcf95,'Initial ID','org.osaaf.people',53344);
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('jh0003@people.osaaf.org','org.onap.portal.admin','2018-10-31','org.onap.portal','admin');

// DESIGNER
INSERT INTO cred (id,type,expires,cred,notes,ns,other) values('cs0008@people.osaaf.org',2,'2019-05-01',0xd993c5617486296f1b99d04de31633332b8ba1a550038e23860f9dbf0b2fcf95,'Initial ID','org.osaaf.people',53344);
INSERT INTO role(ns, name, perms, description)
  VALUES('org.onap.portal','designer',{'org.onap.portal.access|*|read'},'Portal Designer');
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('cs0008@people.osaaf.org','org.onap.portal.designer','2018-10-31','org.onap.portal','designer');

// TESTER
INSERT INTO cred (id,type,expires,cred,notes,ns,other) values('jm0007@people.osaaf.org',2,'2019-05-01',0xd993c5617486296f1b99d04de31633332b8ba1a550038e23860f9dbf0b2fcf95,'Initial ID','org.osaaf.people',53344);
INSERT INTO role(ns, name, perms, description)
  VALUES('org.onap.portal','tester',{'org.onap.portal.access|*|read'},'Portal Tester');
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('jm0007@people.osaaf.org','org.onap.portal.tester','2018-10-31','org.onap.portal','tester');

// OPS
INSERT INTO cred (id,type,expires,cred,notes,ns,other) values('op0001@people.osaaf.org',2,'2019-05-01',0xd993c5617486296f1b99d04de31633332b8ba1a550038e23860f9dbf0b2fcf95,'Initial ID','org.osaaf.people',53344);
INSERT INTO role(ns, name, perms, description)
  VALUES('org.onap.portal','ops',{'org.onap.portal.access|*|read'},'Portal Operations');
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('op0001@people.osaaf.org','org.onap.portal.ops','2018-10-31','org.onap.portal','ops');

// GOVERNOR
INSERT INTO cred (id,type,expires,cred,notes,ns,other) values('gv0001@people.osaaf.org',2,'2019-05-01',0xd993c5617486296f1b99d04de31633332b8ba1a550038e23860f9dbf0b2fcf95,'Initial ID','org.osaaf.people',53344);
INSERT INTO role(ns, name, perms, description)
  VALUES('org.onap.portal','governor',{'org.onap.portal.access|*|read'},'Portal Governor');
INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('gv0001@people.osaaf.org','org.onap.portal.governor','2018-10-31','org.onap.portal','governor');

