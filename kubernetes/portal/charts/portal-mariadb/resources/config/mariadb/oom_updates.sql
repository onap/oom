/*
# Copyright © 2018 Amdocs, Bell Canada, AT&T
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

*/

USE portal;
/*
Any updates required by OOM to the portaldb are made here.
1. split up SDC-FE and SDC-BE.  Originally both FE and BE point to the same IP
while the OOM K8s version has these service split up.
*/
-- app_url is the FE, app_rest_endpoint is the BE
--portal-sdk => TODO: doesn't open a node port yet
update fn_app set app_url = 'http://{{.Values.config.portalSdkHostName}}:{{.Values.config.portalSdkPort}}/ONAPPORTALSDK/welcome.htm', app_rest_endpoint = 'http://portal-sdk:8080/ONAPPORTALSDK/api/v3' where app_name = 'xDemo App';
--dmaap-bc => the dmaap-bc doesn't open a node port..
update fn_app set app_url = 'http://{{.Values.config.dmaapBcHostName}}:{{.Values.config.dmaapBcPort}}/ECOMPDBCAPP/dbc#/dmaap', app_rest_endpoint = 'http://dmaap-bc:8989/ECOMPDBCAPP/api/v2' where app_name = 'DMaaP Bus Ctrl';
--sdc-be => 8443:30204, 8080:30205
--sdc-fe => 8181:30206, 9443:30207
update fn_app set app_url = 'http://{{.Values.config.sdcFeHostName}}:{{.Values.config.sdcFePort}}/sdc1/portal', app_rest_endpoint = 'http://sdc-be:8080/api/v3' where app_name = 'SDC';
--pap => 8443:30219
update fn_app set app_url = 'https://{{.Values.config.papHostName}}:{{.Values.config.papPort}}/onap/policy', app_rest_endpoint = 'https://pap:8443/onap/api/v3' where app_name = 'Policy';
--vid => 8080:30200
update fn_app set app_url = 'https://{{.Values.config.vidHostName}}:{{.Values.config.vidPort}}/vid/welcome.htm', app_rest_endpoint = 'https://vid:8443/vid/api/v3' where app_name = 'Virtual Infrastructure Deployment';
--sparky => TODO: sparky doesn't open a node port yet
update fn_app set app_url = 'http://{{.Values.config.aaiSparkyHostName}}:{{.Values.config.aaiSparkyPort}}/services/aai/webapp/index.html#/viewInspect', app_rest_endpoint = 'http://aai-sparky-be.{{.Release.Namespace}}:9517/api/v2' where app_name = 'A&AI UI';
--cli => 8080:30260
update fn_app set app_url = 'http://{{.Values.config.cliHostName}}:{{.Values.config.cliPort}}/', app_type = 1 where app_name = 'CLI';
--msb-iag => 80:30280
update fn_app set app_url = 'http://{{.Values.config.msbHostName}}:{{.Values.config.msbPort}}/iui/microservices/default.html' where app_name = 'MSB';


/*
Additionally, some more update statments; these should be refactored to another SQL file in future releases 
*/

-- portal
update fn_app set auth_central = 'Y' , auth_namespace = 'org.onap.portal' where app_id = 1;
-- portal-sdk
update fn_app set app_username='Default', app_password='2VxipM8Z3SETg32m3Gp0FvKS6zZ2uCbCw46WDyK6T5E=', ueb_key='ueb_key' where app_id = 2;
-- SDC
update fn_app set app_username='sdc', app_password='j85yNhyIs7zKYbR1VlwEfNhS6b7Om4l0Gx5O8931sCI=', ueb_key='ueb_key' where app_id = 4;
-- policy
update fn_app set app_username='Default', app_password='2VxipM8Z3SETg32m3Gp0FvKS6zZ2uCbCw46WDyK6T5E=', ueb_key='ueb_key_5', auth_central = 'Y' , auth_namespace = 'org.onap.policy' where app_id = 5;
-- vid
update fn_app set app_username='Default', app_password='2VxipM8Z3SETg32m3Gp0FvKS6zZ2uCbCw46WDyK6T5E=', ueb_key='2Re7Pvdkgw5aeAUD', auth_central = 'Y' , auth_namespace = 'org.onap.vid' where app_id = 6;
-- aai sparky
update fn_app set app_username='aaiui', app_password='4LK69amiIFtuzcl6Gsv97Tt7MLhzo03aoOx7dTvdjKQ=', ueb_key='ueb_key' where app_id = 7;



