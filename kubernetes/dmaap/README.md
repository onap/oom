# Copyright © 2018  AT&T Intellectual Property.  All rights reserved.
# Modifications Copyright © 2018 Amdocs,Bell Canada
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
# limitations under the License.

# Helm Chart for ONAP DMaaP Applications

ONAP includes the following Kubernetes services:

1) message-router - a message bus for applications
2) dbc-api - an API to provision DMaaP resources

# Service Dependencies

message-router depends on AAF
dbc-api depends on AAF and Postgresql.
