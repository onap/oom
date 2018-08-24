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

USE authz;

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('demo@people.osaaf.org','org.admin','2099-12-31','org','admin') ;

INSERT INTO user_role(user,role,expires,ns,rname)
  VALUES ('demo@people.osaaf.org','org.osaaf.aaf.admin','2099-12-31','org.osaaf.aaf','admin') ;

