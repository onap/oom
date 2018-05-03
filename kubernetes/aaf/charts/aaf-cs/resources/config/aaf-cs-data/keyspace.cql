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
