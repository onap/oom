
// For Developer Machine single instance
// CREATE KEYSPACE authz
//  WITH REPLICATION = {'class' : 'SimpleStrategy','replication_factor':1};
// 
//
 
// Example of Network Topology, with Datacenter dc1 & dc2
// CREATE KEYSPACE authz WITH replication = { 'class': 'NetworkTopologyStrategy', 'dc1': '2', 'dc2': '2' };
// Out of the box Docker Cassandra comes with "datacenter1", one instance
CREATE KEYSPACE authz WITH replication = { 'class': 'NetworkTopologyStrategy', 'datacenter1': '1' };
// 



// Table Initialization
// First make sure the keyspace exists.

USE authz;

//
// CORE Table function
//

// Namespace - establish hierarchical authority to modify
// Permissions and Roles
// "scope" is flag to determine Policy.  Typical important scope
// is "company" (1)
CREATE TABLE IF NOT EXISTS ns (
  name			varchar,
  scope			int,  // deprecated 2.0.11
  description   	varchar,
  parent 		varchar,
  type			int,
  PRIMARY KEY (name)  
);
CREATE INDEX IF NOT EXISTS ns_parent on ns(parent);
  
CREATE TABLE IF NOT EXISTS ns_attrib (
  ns            varchar,
  key           varchar,
  value         varchar,
  PRIMARY KEY (ns,key)
);
create index ns_attrib_key on ns_attrib(key);

// Will be cached
CREATE TABLE IF NOT EXISTS role (
  ns	    varchar,
  name		varchar,
  perms		set<varchar>, // Use "Key" of "name|type|action"
  description varchar,
  PRIMARY KEY (ns,name)
);
CREATE INDEX IF NOT EXISTS role_name  ON role(name);
 
// Will be cached
CREATE TABLE IF NOT EXISTS perm (
  ns	    varchar,
  type 		varchar,
  instance	varchar,
  action	varchar,
  roles		set<varchar>, // Need to find Roles given Permissions
  description varchar,
  PRIMARY KEY (ns,type,instance,action)
);

// This table is user for Authorization
CREATE TABLE IF NOT EXISTS user_role (
    user		varchar,
    role		varchar, // deprecated: change to ns/rname after 2.0.11
    ns			varchar,
    rname		varchar,
    expires		timestamp,
    PRIMARY KEY(user,role)
  );
CREATE INDEX IF NOT EXISTS user_role_ns ON user_role(ns);
CREATE INDEX IF NOT EXISTS user_role_role ON user_role(role);

// This table is only for the case where return User Credential (MechID) Authentication
CREATE TABLE IF NOT EXISTS cred (
    id    varchar,
    type  int,
    expires timestamp,  
    ns    varchar,
    other int,
    notes varchar,
    cred  blob,
    prev  blob,
    PRIMARY KEY (id,type,expires)
  );
CREATE INDEX IF NOT EXISTS cred_ns ON cred(ns);

// Certificate Cross Table
//   coordinated with CRED type 2
CREATE TABLE IF NOT EXISTS cert (
    fingerprint blob,
    id    	varchar,
    x500	varchar,
    expires 	timestamp,  
    PRIMARY KEY (fingerprint)
  );
CREATE INDEX IF NOT EXISTS cert_id ON cert(id);
CREATE INDEX IF NOT EXISTS cert_x500 ON cert(x500);

CREATE TABLE IF NOT EXISTS notify (
  user 		text,
  type 		int,
  last 		timestamp,
  checksum 	int,
  PRIMARY KEY (user,type)
);

CREATE TABLE IF NOT EXISTS x509 (
  ca     text,
  serial blob,
  id     text,
  x500   text,
  x509   text,
  PRIMARY KEY (ca,serial)
);


CREATE INDEX IF NOT EXISTS x509_id   ON x509 (id);
CREATE INDEX IF NOT EXISTS x509_x500 ON x509 (x500);

// 
// Deployment Artifact (for Certman)
//
CREATE TABLE IF NOT EXISTS artifact (
  mechid        text,
  machine       text,
  type          Set<text>,
  sponsor       text,
  ca            text,
  dir           text,
  os_user       text,
  ns	        text,
  notify        text,
  expires	timestamp,
  renewDays     int,
  sans		Set<text>,
  PRIMARY KEY (mechid,machine)
);
CREATE INDEX IF NOT EXISTS artifact_machine ON artifact(machine); 
CREATE INDEX IF NOT EXISTS artifact_ns ON artifact(ns); 

//
// Non-Critical Table functions
//
// Table Info - for Caching
CREATE TABLE IF NOT EXISTS cache (
   name		varchar,
   seg		int, 		// cache Segment
   touched	timestamp,
   PRIMARY KEY(name,seg)
);

CREATE TABLE IF NOT EXISTS history (
  id			timeuuid,
  yr_mon		int,
  user			varchar,
  action 		varchar,
  target		varchar,   // user, user_role, 
  subject		varchar,   // field for searching main portion of target key
  memo			varchar,   //description of the action
  reconstruct 	blob,      //serialized form of the target
  // detail 	Map<varchar, varchar>,  // additional information
  PRIMARY KEY (id)
);
CREATE INDEX IF NOT EXISTS history_yr_mon ON history(yr_mon);
CREATE INDEX IF NOT EXISTS history_user ON history(user); 
CREATE INDEX IF NOT EXISTS history_subject ON history(subject); 

// 
// A place to hold objects to be created at a future time.
//
CREATE TABLE IF NOT EXISTS future (
  id        uuid,  		// uniquify
  target    varchar,   		// Target Table
  memo	    varchar,    	// Description
  start     timestamp, 		// When it should take effect
  expires   timestamp, 		// When not longer valid
  construct blob, 		// How to construct this object (like History)
  PRIMARY KEY(id)
);
CREATE INDEX IF NOT EXISTS future_idx ON future(target);
CREATE INDEX IF NOT EXISTS future_start_idx ON future(start);


CREATE TABLE IF NOT EXISTS approval (
  id	    timeuuid,	      // unique Key
  ticket    uuid,	      // Link to Future Record
  user 	    varchar,          // the user who needs to be approved
  approver  varchar, 	      // user approving
  type      varchar,          // approver types i.e. Supervisor, Owner
  status    varchar,          // approval status. pending, approved, denied
  memo      varchar,          // Text for Approval to know what's going on
  operation varchar,	      // List operation to perform
  last_notified timestamp,    // Timestamp for the last time approver was notified
  PRIMARY KEY(id)
 );
CREATE INDEX IF NOT EXISTS appr_approver_idx ON approval(approver);
CREATE INDEX IF NOT EXISTS appr_user_idx ON approval(user);
CREATE INDEX IF NOT EXISTS appr_ticket_idx ON approval(ticket);
CREATE INDEX IF NOT EXISTS appr_status_idx ON approval(status);

CREATE TABLE IF NOT EXISTS approved (
  id        timeuuid,         // unique Key
  user      varchar,          // the user who needs to be approved
  approver  varchar,          // user approving
  type      varchar,          // approver types i.e. Supervisor, Owner
  status    varchar,          // approval status. pending, approved, denied
  memo      varchar,          // Text for Approval to know what's going on
  operation varchar,          // List operation to perform
  PRIMARY KEY(id)
 );
CREATE INDEX IF NOT EXISTS approved_approver_idx ON approved(approver);
CREATE INDEX IF NOT EXISTS approved_user_idx ON approved(user);

CREATE TABLE IF NOT EXISTS delegate (
  user      varchar,
  delegate  varchar,
  expires   timestamp,
  PRIMARY KEY (user)  
);
CREATE INDEX IF NOT EXISTS delg_delg_idx ON delegate(delegate);

// OAuth Tokens
CREATE TABLE IF NOT EXISTS oauth_token (
  id            text,                   // Reference
  client_id     text,                   // Creating Client ID
  user          text,                   // User requesting
  active	boolean,		// Active or not
  type		int,			// Type of Token
  refresh       text,                   // Refresh Token
  expires       timestamp,              // Expiration time/Date (signed long)
  exp_sec	bigint,			// Seconds from Jan 1, 1970
  content       text,                   // Content of Token
  scopes        Set<text>,	 	// Scopes
  state		text,			// Context string (Optional)
  req_ip	text,			// Requesting IP (for logging purpose)
  PRIMARY KEY(id)
) with default_time_to_live = 21600;    // 6 hours
CREATE INDEX IF NOT EXISTS oauth_token_user_idx ON oauth_token(user);

CREATE TABLE IF NOT EXISTS locate (
  name		text,			// Component/Server name
  hostname	text,			// FQDN of Service/Component
  port		int,			// Port of Service
  major		int,			// Version, Major
  minor		int,			// Version, Minor
  patch		int,			// Version, Patch
  pkg		int,			// Version, Package (if available)
  latitude	float,			// Latitude
  longitude	float,			// Longitude
  protocol	text,			// Protocol (i.e. http https)
  subprotocol   set<text>,		// Accepted SubProtocols, ie. TLS1.1 for https
  port_key      uuid,			// Key into locate_ports
  PRIMARY KEY(name,hostname,port)
) with default_time_to_live = 1200;	// 20 mins

CREATE TABLE IF NOT EXISTS locate_ports (
  id		uuid,			// Id into locate
  port		int,			// SubPort
  name		text,			// Name of Other Port
  protocol	text,			// Protocol of Other (i.e. JMX, DEBUG)
  subprotocol   set<text>,		// Accepted sub protocols or versions
  PRIMARY KEY(id, port)
) with default_time_to_live = 1200;	// 20 mins; 

//
// Used by authz-batch processes to ensure only 1 runs at a time
//
CREATE TABLE IF NOT EXISTS run_lock (
  class text,
  host text,
  start timestamp,
  PRIMARY KEY ((class))
);


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



USE authz;

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('demo@people.osaaf.org','org.admin','2099-12-31','org','admin') ;

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('demo@people.osaaf.org','org.osaaf.aaf.admin','2099-12-31','org.osaaf.aaf','admin') ;


