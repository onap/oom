/* # Copyright © 2018 Amdocs, Bell Canada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License. */

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
