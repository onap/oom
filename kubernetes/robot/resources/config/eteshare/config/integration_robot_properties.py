# Copyright (c) 2018 Amdocs, Bell Canada, and others
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

# aaf info - everything is from the private oam network (also called onap private network)
GLOBAL_AAF_SERVER = "https://aaf-service.{{include "common.namespace" .}}:8100"
GLOBAL_AAF_USERNAME = "{{ .Values.aafUsername }}"
GLOBAL_AAF_PASSWORD = "{{ .Values.aafPassword }}"
# aai info - everything is from the private oam network (also called onap private network)
GLOBAL_AAI_SERVER_PROTOCOL = "https"
GLOBAL_AAI_SERVER_PORT = "8443"
GLOBAL_AAI_USERNAME = "{{ .Values.aaiUsername }}"
GLOBAL_AAI_PASSWORD = "{{ .Values.aaiPassword}}"
# appc info - everything is from the private oam network (also called onap private network)
GLOBAL_APPC_SERVER_PROTOCOL = "http"
GLOBAL_APPC_SERVER_PORT = "8282"
GLOBAL_APPC_USERNAME = "{{ .Values.appcUsername }}"
GLOBAL_APPC_PASSWORD = "{{ .Values.appcPassword }}"
GLOBAL_APPC_CDT_SERVER_PROTOCOL = "http"
GLOBAL_APPC_CDT_SERVER_PORT = "18080"
GLOBAL_APPC_CDT_USERNAME = "demo"
# sdc info - everything is from the private oam network (also called onap private network)
GLOBAL_ASDC_SERVER_PROTOCOL = "http"
GLOBAL_ASDC_FE_PORT = "8181"
GLOBAL_ASDC_BE_PORT = "8080"
GLOBAL_ASDC_BE_ONBOARD_PORT = "8081"
GLOBAL_ASDC_BE_USERNAME = "beep"
GLOBAL_ASDC_BE_PASSWORD = "boop"
# clamp info - everything is from the private oam network (also called onap private network)
GLOBAL_CLAMP_SERVER_PROTOCOL = "https"
GLOBAL_CLAMP_SERVER_PORT = "8443"
# nbi info - everything is from the private oam network (also called onap private network)
GLOBAL_NBI_SERVER_PROTOCOL = "http"
GLOBAL_NBI_SERVER_PORT = "8080"
# cli info - everything is from the private oam network (also called onap private network)
GLOBAL_CLI_SERVER_PROTOCOL = "http"
GLOBAL_CLI_SERVER_PORT = "8080"
# dcae info - everything is from the private oam network (also called onap private network)
GLOBAL_DCAE_SERVER_PROTOCOL = "http"
GLOBAL_DCAE_HEALTH_SERVER_PORT = "80"
GLOBAL_DCAE_USERNAME = "{{ .Values.dcaeUsername }}"
GLOBAL_DCAE_PASSWORD = "{{ .Values.dcaePassword}}"
# data router info - everything is from the private oam network (also called onap private network)
GLOBAL_DMAAP_DR_PROV_SERVER_PROTOCOL = "http"
GLOBAL_DMAAP_DR_PROV_SERVER_PORT = "8080"
GLOBAL_DMAAP_DR_NODE_SERVER_PROTOCOL = "http"
GLOBAL_DMAAP_DR_NODE_SERVER_PORT = "8080"
# DROOL server port and credentials
GLOBAL_DROOLS_SERVER_PORT = "9696"
GLOBAL_DROOLS_USERNAME = "{{ .Values.droolsUsername }}"
GLOBAL_DROOLS_PASSWORD = "{{ .Values.droolsPassword }}"
# log server config - NOTE: no log server is run in HEAT; only on OOM
GLOBAL_LOG_SERVER_PROTOCOL = "http"
GLOBAL_LOG_ELASTICSEARCH_PORT = "9200"
GLOBAL_LOG_LOGSTASH_PORT = "9600"
GLOBAL_LOG_KIBANA_PORT = "5601"
# pomba info - NOTE: no pomba is run in HEAT; only on OOM
GLOBAL_POMBA_SERVER_PROTOCOL_HTTP = "http"
GLOBAL_POMBA_SERVER_PROTOCOL_HTTPS = "https"
GLOBAL_POMBA_AAICONTEXTBUILDER_PORT = "9530"
GLOBAL_POMBA_SDCCONTEXTBUILDER_PORT = "9530"
GLOBAL_POMBA_NETWORKDISCCONTEXTBUILDER_PORT = "9530"
GLOBAL_POMBA_SERVICEDECOMPOSITION_PORT = "9532"
GLOBAL_POMBA_SDNCCXTBUILDER_PORT = "9530"
GLOBAL_POMBA_NETWORKDISCOVERY_MICROSERVICE_PORT = "9531"
GLOBAL_POMBA_VALIDATIONSERVICE_PORT = "9529"
GLOBAL_POMBA_KIBANA_PORT = "5601"
GLOBAL_POMBA_ELASTICSEARCH_PORT = "9200"
GLOBAL_POMBA_CONTEXTAGGREGATOR_PORT = "9529"

# microservice bus info - everything is from the private oam network (also called onap private network)
GLOBAL_MSB_SERVER_PROTOCOL = "http"
GLOBAL_MSB_SERVER_PORT = "80"
# message router info - everything is from the private oam network (also called onap private network)
GLOBAL_MR_SERVER_PROTOCOL = "http"
GLOBAL_MR_SERVER_PORT = "3904"
# bus controller info
GLOBAL_BC_HTTPS_SERVER_PORT = "8443"
GLOBAL_BC_USERNAME = "{{ .Values.bcUsername }}"
GLOBAL_BC_PASSWORD = "{{ .Values.bcPassword }}"
# mso info - everything is from the private oam network (also called onap private network)
GLOBAL_MSO_SERVER_PROTOCOL = "http"
GLOBAL_MSO_SERVER_PORT = "8080"
# SO containers
GLOBAL_MSO_APIHAND_SERVER_PORT = "8080"
GLOBAL_MSO_ASDCHAND_SERVER_PORT = "8085"
GLOBAL_MSO_BPMN_SERVER_PORT = "8081"
GLOBAL_MSO_CATDB_SERVER_PORT = "8082"
GLOBAL_MSO_OPENSTACK_SERVER_PORT = "8087"
GLOBAL_MSO_REQDB_SERVER_PORT = "8083"
GLOBAL_MSO_SDNC_SERVER_PORT =  "8086"
GLOBAL_MSO_VFC_SERVER_PORT = "8084"
GLOBAL_MSO_VNFM_SERVER_PORT = "9092"
GLOBAL_MSO_USERNAME = "{{ .Values.soUsername }}"
GLOBAL_MSO_CATDB_USERNAME = "{{ .Values.soCatdbUsername }}"
GLOBAL_MSO_PASSWORD = "{{ .Values.soPassword }}"
# robot uses MSO_PASSWORD for both SO and CATDB
# music info - everything is from the private oam network (also called onap private network)
GLOBAL_MUSIC_SERVER_PROTOCOL = "http"
GLOBAL_MUSIC_SERVER_PORT = "8080"
# oof global info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_SERVER_PROTOCOL = "http"
# oof-homing info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_HOMING_SERVER_PORT = "8091"
# oof-sniro info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_SNIRO_SERVER_PORT = "8698"
# oof cmso global info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_CMSO_PROTOCOL = "http"
GLOBAL_OOF_CMSO_SERVER_PORT = "8080"
GLOBAL_OOF_CMSO_USERNAME = "none"
GLOBAL_OOF_CMSO_PASSWORD = "none"
# openstack info - info to select right info in environment
# packet generate vnf info - everything is from the private oam network (also called onap private network)
GLOBAL_PACKET_GENERATOR_PORT = "8183"
GLOBAL_PACKET_GENERATOR_USERNAME = "admin"
GLOBAL_PACKET_GENERATOR_PASSWORD = "admin"
GLOBAL_PGN_PORT = "2831"
# policy info - everything is from the private oam network (also called onap private network)
GLOBAL_POLICY_SERVER_PROTOCOL = "https"
GLOBAL_POLICY_SERVER_PORT = "8081"
GLOBAL_POLICY_HEALTHCHECK_PORT = "6969"
GLOBAL_POLICY_AUTH = "{{ .Values.policyAuth}}"
GLOBAL_POLICY_CLIENTAUTH = "{{ .Values.policyClientAuth}}"
GLOBAL_POLICY_USERNAME = "{{ .Values.policyUsername }}"
GLOBAL_POLICY_PASSWORD = "{{ .Values.policyPassword }}"
# portal info - everything is from the private oam network (also called onap private network)
GLOBAL_PORTAL_SERVER_PROTOCOL = "http"
GLOBAL_PORTAL_SERVER_PORT = "8989"
GLOBAL_PORTAL_USERNAME = "{{ .Values.portalUsername }}"
GLOBAL_PORTAL_PASSWORD = "{{ .Values.portalPassword }}"
# sdngc info - everything is from the private oam network (also called onap private network)
GLOBAL_SDNGC_SERVER_PROTOCOL = "http"
GLOBAL_SDNGC_REST_PORT = "8282"
GLOBAL_SDNGC_ADMIN_PORT = "8843"
GLOBAL_SDNGC_USERNAME = "{{ .Values.sdncUsername }}"
GLOBAL_SDNGC_PASSWORD = "{{ .Values.sdncPassword }}"
# sms (AAF)  info
GLOBAL_SMS_SERVER_PROTOCOL = "https"
GLOBAL_SMS_SERVER_NAME = "aaf-sms.{{include "common.namespace" .}}"
GLOBAL_SMS_SERVER_PORT = "10443"
# vid info - everything is from the private oam network (also called onap private network)
GLOBAL_VID_SERVER_PROTOCOL = "{{ .Values.vidServerProtocol }}"
GLOBAL_VID_SERVER_PORT = "{{ .Values.vidServerPort }}"
GLOBAL_VID_USERNAME = "{{ .Values.vidUsername }}"
GLOBAL_VID_PASSWORD = "{{ .Values.vidPassword}}"
GLOBAL_VID_HEALTH_USERNAME = "{{ .Values.vidHealthUsername }}"
GLOBAL_VID_HEALTH_PASSWORD = "{{ .Values.vidHealthPassword }}"
# vnfsdk info - everything is from the private oam network (also called onap private network)
GLOBAL_VNFSDK_SERVER_PROTOCOL = "http"
GLOBAL_VNFSDK_SERVER_PORT = "8702"
#global selenium info
GLOBAL_PROXY_WARNING_TITLE=""
GLOBAL_PROXY_WARNING_CONTINUE_XPATH=""
# dns info
GLOBAL_DNS_TRAFFIC_DURATION = "600"
# location where heat templates are loaded from
GLOBAL_HEAT_TEMPLATES_FOLDER = "/var/opt/ONAP/demo/heat"
