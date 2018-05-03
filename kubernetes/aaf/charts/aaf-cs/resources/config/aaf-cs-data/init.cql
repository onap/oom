
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
CREATE TABLE ns (
  name			varchar,
  scope			int,  // deprecated 2.0.11
  description   	varchar,
  parent 		varchar,
  type			int,
  PRIMARY KEY (name)  
);
CREATE INDEX ns_parent on ns(parent);
  
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
  user 		text,
  type 		int,
  last 		timestamp,
  checksum 	int,
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
  os_user       text,
  ns	        text,
  notify        text,
  expires	timestamp,
  renewDays     int,
  sans		Set<text>,
  PRIMARY KEY (mechid,machine)
);
CREATE INDEX artifact_machine ON artifact(machine); 
CREATE INDEX artifact_ns ON artifact(ns); 

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
  last_notified timestamp,    // Timestamp for the last time approver was notified
  PRIMARY KEY(id)
 );
CREATE INDEX appr_approver_idx ON approval(approver);
CREATE INDEX appr_user_idx ON approval(user);
CREATE INDEX appr_ticket_idx ON approval(ticket);
CREATE INDEX appr_status_idx ON approval(status);

CREATE TABLE approved (
  id        timeuuid,         // unique Key
  user      varchar,          // the user who needs to be approved
  approver  varchar,          // user approving
  type      varchar,          // approver types i.e. Supervisor, Owner
  status    varchar,          // approval status. pending, approved, denied
  memo      varchar,          // Text for Approval to know what's going on
  operation varchar,          // List operation to perform
  PRIMARY KEY(id)
 );
CREATE INDEX approved_approver_idx ON approved(approver);
CREATE INDEX approved_user_idx ON approved(user);

CREATE TABLE delegate (
  user      varchar,
  delegate  varchar,
  expires   timestamp,
  PRIMARY KEY (user)  
);
CREATE INDEX delg_delg_idx ON delegate(delegate);

// OAuth Tokens
CREATE TABLE oauth_token (
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
CREATE INDEX oauth_token_user_idx ON oauth_token(user);

CREATE TABLE locate (
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

CREATE TABLE locate_ports (
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
CREATE TABLE run_lock (
  class text,
  host text,
  start timestamp,
  PRIMARY KEY ((class))
);
