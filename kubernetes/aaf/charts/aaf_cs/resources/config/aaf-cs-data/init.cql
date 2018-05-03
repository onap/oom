// For Developer Machine single instance
//
CREATE KEYSPACE authz
WITH REPLICATION = {'class' : 'SimpleStrategy','replication_factor':1};
// 
// From Ravi, 6-17-2014.  User for DEVL->TEST
//
// CREATE KEYSPACE authz WITH replication = { 'class': 'NetworkTopologyStrategy', 'HYWRCA02': '2', 'BRHMALDC': '2' };
// 
// PROD
// 
// CREATE KEYSPACE authz WITH replication = {'class': 'NetworkTopologyStrategy','ALPSGACT': '2','STLSMORC': '2','BRHMALDC': '2' };
//
//  create user authz with password '<AUTHZ PASSWORD>' superuser;
//  grant all on keyspace authz to authz;
//
// For TEST (aaf_test)
// CREATE KEYSPACE authz WITH replication = { 'class': 'NetworkTopologyStrategy', 'BRHMALDC': '1' };
//
// DEVL
// CREATE KEYSPACE authz WITH replication = {'class': 'NetworkTopologyStrategy','STLSMORC': '2' };
//
// TEST / PERF
// CREATE KEYSPACE authz WITH replication = {'class': 'NetworkTopologyStrategy','STLSMORC': '3','KGMTNC20': '3' };
//
// IST
// CREATE KEYSPACE authz WITH replication = {'class': 'NetworkTopologyStrategy','STLSMORC':'3',
// 'DLLSTXCF':'3','KGMTNC20':'3','SFLDMIBB':'3','HYWRCA02':'3' };
//
// with 6 localized with ccm
// CREATE KEYSPACE authz WITH replication = { 'class': 'NetworkTopologyStrategy', 'dc1': '2', 'dc2': '2' };
// 

USE authz;

//
// CORE Table function
//

// Namespace - establish hierarchical authority to modify
// Permissions and Roles
// "scope" is flag to determine Policy.  Typical important scope
// is "company" (1)
CREATE TABLE ns (
  name			varchar,
  scope			int,  // deprecated 2.0.11
  description   	varchar,
  parent 		varchar,
  type			int,
  PRIMARY KEY (name)  
);
CREATE INDEX ns_parent on ns(parent);
  

// Oct 2015, not performant.  Made Owner and Attrib first class Roles,
// April, 2015.  Originally, the plan was to utilize Cassandra 2.1.2, however, other team's preferences were to remain at current levels.
// Therefore, we are taking the separate table approach.  (coder Jeremiah Rohwedder)
// We had dropped this by making first class objects of Responsible (Owner) and Admin.  We need this again to mark namespaces
// as having certain tools, like SWM, etc.
CREATE TABLE ns_attrib (
  ns            varchar,
  key           varchar,
  value         varchar,
  PRIMARY KEY (ns,key)
);
create index ns_attrib_key on ns_attrib(key);

// Will be cached
CREATE TABLE role (
  ns	    varchar,
  name		varchar,
  perms		set<varchar>, // Use "Key" of "name|type|action"
  description varchar,
  PRIMARY KEY (ns,name)
);
CREATE INDEX role_name  ON role(name);
 
// Will be cached
CREATE TABLE perm (
  ns	    varchar,
  type 		varchar,
  instance	varchar,
  action	varchar,
  roles		set<varchar>, // Need to find Roles given Permissions
  description varchar,
  PRIMARY KEY (ns,type,instance,action)
);

// This table is user for Authorization
CREATE TABLE user_role (
    user		varchar,
    role		varchar, // deprecated: change to ns/rname after 2.0.11
    ns			varchar,
    rname		varchar,
    expires		timestamp,
    PRIMARY KEY(user,role)
  );
CREATE INDEX user_role_ns ON user_role(ns);
CREATE INDEX user_role_role ON user_role(role);

// This table is only for the case where return User Credential (MechID) Authentication
CREATE TABLE cred (
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
CREATE INDEX cred_ns ON cred(ns);

// Certificate Cross Table
//   coordinated with CRED type 2
CREATE TABLE cert (
    fingerprint blob,
    id    	varchar,
    x500	varchar,
    expires 	timestamp,  
    PRIMARY KEY (fingerprint)
  );
CREATE INDEX cert_id ON cert(id);
CREATE INDEX cert_x500 ON cert(x500);

CREATE TABLE notify (
  user text,
  type int,
  last timestamp,
  checksum int,
  PRIMARY KEY (user,type)
);

CREATE TABLE x509 (
  ca     text,
  serial blob,
  id     text,
  x500   text,
  x509   text,
  PRIMARY KEY (ca,serial)
);


CREATE INDEX x509_id   ON x509 (id);
CREATE INDEX x509_x500 ON x509 (x500);

// 
// Deployment Artifact (for Certman)
//
CREATE TABLE artifact (
  mechid        text,
  machine       text,
  type          Set<text>,
  sponsor       text,
  ca            text,
  dir           text,
  appName       text,
  os_user       text,
  notify        text,
  expires	timestamp,
  renewDays   int,
  PRIMARY KEY (mechid,machine)
);
CREATE INDEX artifact_machine ON artifact(machine); 

//
// Non-Critical Table functions
//
// Table Info - for Caching
CREATE TABLE cache (
   name		varchar,
   seg		int, 		// cache Segment
   touched	timestamp,
   PRIMARY KEY(name,seg)
);

CREATE TABLE history (
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
CREATE INDEX history_yr_mon ON history(yr_mon);
CREATE INDEX history_user ON history(user); 
CREATE INDEX history_subject ON history(subject); 

// 
// A place to hold objects to be created at a future time.
//
CREATE TABLE future (
  id        uuid,  		// uniquify
  target    varchar,   		// Target Table
  memo	    varchar,    	// Description
  start     timestamp, 		// When it should take effect
  expires   timestamp, 		// When not longer valid
  construct blob, 		// How to construct this object (like History)
  PRIMARY KEY(id)
);
CREATE INDEX future_idx ON future(target);
CREATE INDEX future_start_idx ON future(start);


CREATE TABLE approval (
  id	    timeuuid,	      // unique Key
  ticket    uuid,	      // Link to Future Record
  user 	    varchar,          // the user who needs to be approved
  approver  varchar, 	      // user approving
  type      varchar,          // approver types i.e. Supervisor, Owner
  status    varchar,          // approval status. pending, approved, denied
  memo      varchar,          // Text for Approval to know what's going on
  operation varchar,	      // List operation to perform
  PRIMARY KEY(id)
 );
CREATE INDEX appr_approver_idx ON approval(approver);
CREATE INDEX appr_user_idx ON approval(user);
CREATE INDEX appr_ticket_idx ON approval(ticket);
CREATE INDEX appr_status_idx ON approval(status);

CREATE TABLE delegate (
  user      varchar,
  delegate  varchar,
  expires   timestamp,
  PRIMARY KEY (user)  
);
CREATE INDEX delg_delg_idx ON delegate(delegate);

//
// Used by authz-batch processes to ensure only 1 runs at a time
//
CREATE TABLE run_lock (
  class text,
  host text,
  start timestamp,
  PRIMARY KEY ((class))
);
