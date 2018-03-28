/* Copyright © 2017 AT&T, Amdocs, Bell Canada
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*       http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

USE portal;
/*
Any updates required by OOM to the portaldb are made here.
1. split up SDC-FE and SDC-BE.  Originally both FE and BE point to the same IP
while the OOM K8s version has these service split up.
*/
UPDATE fn_app SET app_rest_endpoint = 'http://sdc.api.be.simpledemo.onap.org:8080/api/v2' where app_name = 'SDC';
UPDATE fn_app SET app_url = 'http://cli.api.simpledemo.onap.org:8080', app_type = 1 where app_name='CLI';
