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

module.exports={
    "name": "Release sdnc1.0",
    "emailAddress": "dguser@onap.org",
    "uiPort": 3100,
    "mqttReconnectTime": 15000,
    "serialReconnectTime": 15000,
    "debugMaxLength": 1000,
    "htmlPath": "releases/sdnc1.0/html/",
    "xmlPath": "releases/sdnc1.0/xml/",
    "flowFile": "releases/sdnc1.0/flows/flows.json",
    "sharedDir": "releases/sdnc1.0/flows/shared",
    "userDir": "releases/sdnc1.0",
    "httpAuth": {
        "user": process.env.HTTP_USER,
        "pass": process.env.HTTP_PASSWORD
    },
    "dbHost": "{{.Values.config.dbServiceName}}.{{ include "common.namespace" . }}",
    "dbPort": "3306",
    "dbName": "{{.Values.config.db.dbName}}",
    "dbUser": process.env.DB_USER,
    "dbPassword": process.env.DB_PASSWORD,
    "gitLocalRepository": "",
    "restConfUrl": "http://localhost:8181/rests/operations/SLI-API:execute-graph",
    "restConfUser": process.env.REST_CONF_USER,
    "restConfPassword": process.env.REST_CONF_PASSWORD,
    "formatXML": "Y",
    "formatJSON": "Y",
    "httpRoot": "/",
    "disableEditor": false,
    "httpAdminRoot": "/",
    "httpAdminAuth": {
        "user": process.env.HTTP_ADMIN_USER,
        "pass": process.env.HTTP_ADMIN_PASSWORD
    },
    "httpNodeRoot": "/",
    "httpNodeAuth": {
        "user": process.env.HTTP_NODE_USER,
        "pass": process.env.HTTP_NODE_PASSWORD
    },
    "uiHost": "0.0.0.0",
    "version": "0.9.1",
    "performGitPull": "N"
}
