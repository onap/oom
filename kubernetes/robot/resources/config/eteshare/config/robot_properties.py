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

GLOBAL_INJECTED_AAF_IP_ADDR = 'aaf-service.{{include "common.namespace" .}}'
GLOBAL_INJECTED_AAI_IP_ADDR = 'aai.{{include "common.namespace" .}}'
GLOBAL_INJECTED_APPC_IP_ADDR = 'appc.{{include "common.namespace" .}}'
GLOBAL_INJECTED_APPC_CDT_IP_ADDR = 'appc-cdt.{{include "common.namespace" .}}'
GLOBAL_INJECTED_ARTIFACTS_VERSION = '{{.Values.demoArtifactsVersion}}'
GLOBAL_INJECTED_ARTIFACTS_REPO_URL = "{{ .Values.demoArtifactsRepoUrl }}"
GLOBAL_INJECTED_CLAMP_IP_ADDR = 'clamp.{{include "common.namespace" .}}'
GLOBAL_INJECTED_CLI_IP_ADDR = 'cli.{{include "common.namespace" .}}'
GLOBAL_INJECTED_CLOUD_ENV = 'openstack'
GLOBAL_INJECTED_DCAE_COLLECTOR_IP = "{{ .Values.dcaeCollectorIp }}"
GLOBAL_INJECTED_DCAE_IP_ADDR = 'dcae-healthcheck.{{include "common.namespace" .}}'
GLOBAL_INJECTED_DCAE_VES_HOST = 'dcae-ves-collector.{{include "common.namespace" .}}'
GLOBAL_INJECTED_DMAAP_DR_PROV_IP_ADDR = 'dmaap-dr-prov.{{include "common.namespace" .}}'
GLOBAL_INJECTED_DMAAP_DR_NODE_IP_ADDR = 'dmaap-dr-node.{{include "common.namespace" .}}'
GLOBAL_INJECTED_DNS_IP_ADDR = 'N/A'
GLOBAL_INJECTED_DOCKER_VERSION = '1.2-STAGING-latest'
GLOBAL_INJECTED_EXTERNAL_DNS = 'N/A'
GLOBAL_INJECTED_LOG_ELASTICSEARCH_IP_ADDR = 'log-es.{{include "common.namespace" .}}'
GLOBAL_INJECTED_LOG_KIBANA_IP_ADDR = 'log-kibana.{{include "common.namespace" .}}'
GLOBAL_INJECTED_LOG_LOGSTASH_IP_ADDR = 'log-ls-http.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POMBA_AAI_CONTEXT_BUILDER_IP_ADDR = 'pomba-aaictxbuilder.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POMBA_SDC_CONTEXT_BUILDER_IP_ADDR = 'pomba-sdcctxbuilder.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POMBA_NETWORK_DISC_CONTEXT_BUILDER_IP_ADDR = 'pomba-networkdiscoveryctxbuilder.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POMBA_SERVICE_DECOMPOSITION_IP_ADDR = 'pomba-servicedecomposition.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POMBA_SDNC_CTX_BUILDER_IP_ADDR = 'pomba-sdncctxbuilder.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POMBA_NETWORKDISCOVERY_MICROSERVICE_IP_ADDR = 'pomba-networkdiscovery.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POMBA_VALIDATION_SERVICE_IP_ADDR = 'pomba-validation-service.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POMBA_KIBANA_IP_ADDR = 'pomba-kibana.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POMBA_ELASTIC_SEARCH_IP_ADDR = 'pomba-es.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POMBA_CONTEX_TAGGREGATOR_IP_ADDR = 'pomba-contextaggregator.{{include "common.namespace" .}}'
GLOBAL_INJECTED_KEYSTONE = '{{ .Values.openStackKeyStoneUrl }}'
GLOBAL_INJECTED_MR_IP_ADDR = 'message-router.{{include "common.namespace" .}}'
GLOBAL_INJECTED_BC_IP_ADDR = 'dmaap-bc.{{include "common.namespace" .}}'
GLOBAL_INJECTED_MUSIC_IP_ADDR = 'music.{{include "common.namespace" .}}'
GLOBAL_INJECTED_NBI_IP_ADDR = 'nbi.{{include "common.namespace" .}}'
GLOBAL_INJECTED_NETWORK = '{{ .Values.openStackPrivateNetId }}'
GLOBAL_INJECTED_NEXUS_DOCKER_REPO = 'nexus3.onap.org:10001'
GLOBAL_INJECTED_NEXUS_PASSWORD = 'docker'
GLOBAL_INJECTED_NEXUS_REPO ='https://nexus.onap.org/content/sites/raw'
GLOBAL_INJECTED_NEXUS_USERNAME = 'docker'
GLOBAL_INJECTED_OOF_IP_ADDR = 'N/A'
GLOBAL_INJECTED_OOF_HOMING_IP_ADDR = 'oof-has-api.{{include "common.namespace" .}}'
GLOBAL_INJECTED_OOF_SNIRO_IP_ADDR = 'oof-osdf.{{include "common.namespace" .}}'
GLOBAL_INJECTED_OOF_CMSO_IP_ADDR = 'oof-cmso.{{include "common.namespace" .}}'
GLOBAL_INJECTED_MSB_IP_ADDR = 'msb-iag.{{include "common.namespace" .}}'
GLOBAL_INJECTED_OPENSTACK_API_KEY = '{{ .Values.config.openStackEncryptedPasswordHere}}'
GLOBAL_INJECTED_OPENSTACK_TENANT_ID = '{{ .Values.openStackTenantId }}'
GLOBAL_INJECTED_OPENSTACK_USERNAME = '{{ .Values.openStackUserName }}'
GLOBAL_INJECTED_OPENSTACK_PROJECT_NAME = '{{ .Values.openStackProjectName }}'
GLOBAL_INJECTED_OPENSTACK_DOMAIN_ID = '{{ .Values.openStackDomainId }}'
GLOBAL_INJECTED_OPENSTACK_USER_DOMAIN = '{{ .Values.openStackUserDomain }}'
GLOBAL_INJECTED_OPENSTACK_KEYSTONE_API_VERSION = '{{ .Values.openStackKeystoneAPIVersion }}'
GLOBAL_INJECTED_REGION_THREE = '{{ .Values.openStackRegionRegionThree }}'
GLOBAL_INJECTED_KEYSTONE_REGION_THREE = '{{ .Values.openStackKeyStoneUrlRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_KEYSTONE_API_VERSION_REGION_THREE = '{{ .Values.openStackKeystoneAPIVersionRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_USERNAME_REGION_THREE = '{{ .Values.openStackUserNameRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_SO_ENCRYPTED_PASSWORD_REGION_THREE  = '{{ .Values.openSackMsoEncryptdPasswordRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_SO_ENCRYPTED_PASSWORD = '{{ .Values.config.openStackSoEncryptedPassword}}'
GLOBAL_INJECTED_OPENSTACK_TENANT_ID_REGION_THREE = '{{ .Values.openStackTenantIdRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_PROJECT_DOMAIN_REGION_THREE = '{{ .Values.openStackProjectNameRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_USER_DOMAIN_REGION_THREE = '{{ .Values.openStackDomainIdRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_OAM_NETWORK_CIDR_PREFIX = '{{ .Values.openStackOamNetworkCidrPrefix }}'
GLOBAL_INJECTED_OPENSTACK_PUBLIC_NETWORK = '{{ .Values.openStackPublicNetworkName }}'
GLOBAL_INJECTED_OPENSTACK_SECURITY_GROUP = '{{ .Values.openStackSecurityGroup }}'
GLOBAL_INJECTED_OPENSTACK_PRIVATE_SUBNET_ID = "{{ .Values.openStackPrivateSubnetId }}"
GLOBAL_INJECTED_OPENSTACK_PRIVATE_NET_CIDR = "{{ .Values.openStackPrivateNetCidr }}"
GLOBAL_INJECTED_POLICY_IP_ADDR = 'pdp.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POLICY_DROOLS_IP_ADDR = 'drools.{{include "common.namespace" .}}'
GLOBAL_INJECTED_PORTAL_IP_ADDR = 'portal-app.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POLICY_API_IP_ADDR = 'policy-api.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POLICY_PAP_IP_ADDR = 'policy-pap.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POLICY_DISTRIBUTION_IP_ADDR = 'policy-distribution.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POLICY_PDPX_IP_ADDR = 'policy-xacml-pdp.{{include "common.namespace" .}}'
GLOBAL_INJECTED_POLICY_APEX_PDP_IP_ADDR = 'policy-apex-pdp.{{include "common.namespace" .}}'
GLOBAL_INJECTED_PUBLIC_NET_ID = '{{ .Values.openStackPublicNetId }}'
GLOBAL_INJECTED_PRIVATE_KEY = "{{ .Files.Get .Values.vnfPrivateKey }}"
GLOBAL_INJECTED_PUBLIC_KEY = "{{ .Values.vnfPubKey }}"
GLOBAL_INJECTED_REGION = '{{ .Values.openStackRegion }}'
GLOBAL_INJECTED_SCRIPT_VERSION = '{{ .Values.scriptVersion }}'
GLOBAL_INJECTED_SDC_BE_IP_ADDR = 'sdc-be.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SDC_BE_ONBOARD_IP_ADDR = 'sdc-onboarding-be.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SDC_FE_IP_ADDR = 'sdc-fe.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SDC_DCAE_BE_IP_ADDR = 'sdc-dcae-be.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SDC_IP_ADDR = 'N/A'
GLOBAL_INJECTED_SDNC_IP_ADDR = 'sdnc.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SDNC_PORTAL_IP_ADDR = 'sdnc-portal.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SO_APIHAND_IP_ADDR = 'so.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SO_SDCHAND_IP_ADDR = 'so-sdc-controller.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SO_BPMN_IP_ADDR = 'so-bpmn-infra.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SO_CATDB_IP_ADDR = 'so-catalog-db-adapter.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SO_OPENSTACK_IP_ADDR = 'so-openstack-adapter.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SO_REQDB_IP_ADDR = 'so-request-db-adapter.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SO_SDNC_IP_ADDR = 'so-sdnc-adapter.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SO_VFC_IP_ADDR = 'so-vfc-adapter.{{include "common.namespace" .}}'
GLOBAL_INJECTED_SO_VNFM_IP_ADDR = 'so-vnfm-adapter.{{include "common.namespace" .}}'
GLOBAL_INJECTED_UBUNTU_1404_IMAGE = '{{ .Values.ubuntu14Image }}'
GLOBAL_INJECTED_UBUNTU_1604_IMAGE = '{{ .Values.ubuntu16Image }}'
GLOBAL_INJECTED_VM_IMAGE_NAME = '{{ .Values.ubuntu14Image }}'
GLOBAL_INJECTED_VID_IP_ADDR = 'vid.{{include "common.namespace" .}}'
GLOBAL_INJECTED_VM_FLAVOR = '{{ .Values.openStackFlavourMedium }}'
GLOBAL_INJECTED_VNFSDK_IP_ADDR = 'refrepo.{{include "common.namespace" .}}'
GLOBAL_INJECTED_CCSDK_CDS_BLUEPRINT_PROCESSOR_IP_ADDR = 'cds-blueprints-processor-http.{{include "common.namespace" .}}'

# aaf info - everything is from the private oam network (also called onap private network)
GLOBAL_AAF_SERVER = 'https://aaf-service.{{include "common.namespace" .}}:8100'
GLOBAL_AAF_USERNAME = '{{ .Values.aafUsername }}'
GLOBAL_AAF_PASSWORD = '{{ .Values.aafPassword }}'
GLOBAL_AAF_AUTHENTICATION = [GLOBAL_AAF_USERNAME, GLOBAL_AAF_PASSWORD]
# aai info - everything is from the private oam network (also called onap private network)
GLOBAL_AAI_SERVER_PROTOCOL = "https"
GLOBAL_AAI_SERVER_PORT = "8443"
GLOBAL_AAI_USERNAME = '{{ .Values.aaiUsername }}'
GLOBAL_AAI_PASSWORD = '{{ .Values.aaiPassword}}'
GLOBAL_AAI_AUTHENTICATION = [GLOBAL_AAI_USERNAME, GLOBAL_AAI_PASSWORD]
# appc info - everything is from the private oam network (also called onap private network)
GLOBAL_APPC_SERVER_PROTOCOL = "https"
GLOBAL_APPC_SERVER_PORT = "8443"
GLOBAL_APPC_USERNAME = '{{ .Values.appcUsername }}'
GLOBAL_APPC_PASSWORD = '{{ .Values.appcPassword }}'
GLOBAL_APPC_AUTHENTICATION = [GLOBAL_APPC_USERNAME, GLOBAL_APPC_PASSWORD]
GLOBAL_APPC_CDT_SERVER_PROTOCOL = "https"
GLOBAL_APPC_CDT_SERVER_PORT = "18080"
GLOBAL_APPC_CDT_USERNAME = "demo"
# sdc info - everything is from the private oam network (also called onap private network)
GLOBAL_SDC_SERVER_PROTOCOL = "https"
GLOBAL_SDC_FE_PORT = "9443"
GLOBAL_SDC_BE_PORT = "8443"
GLOBAL_SDC_BE_ONBOARD_PORT = "8445"
GLOBAL_SDC_DCAE_BE_PORT = "8444"
GLOBAL_SDC_USERNAME = "beep"
GLOBAL_SDC_PASSWORD = "boop"
GLOBAL_SDC_AUTHENTICATION = [GLOBAL_SDC_USERNAME, GLOBAL_SDC_PASSWORD]
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
GLOBAL_DCAE_USERNAME = '{{ .Values.dcaeUsername }}'
GLOBAL_DCAE_PASSWORD = '{{ .Values.dcaePassword}}'
GLOBAL_DCAE_AUTHENTICATION = [GLOBAL_DCAE_USERNAME, GLOBAL_DCAE_PASSWORD]
# dcae hv-ves info
GLOBAL_DCAE_HVVES_SERVER_NAME = 'dcae-hv-ves-collector.{{include "common.namespace" .}}'
GLOBAL_DCAE_HVVES_SERVER_PORT = "6061"
# data router info - everything is from the private oam network (also called onap private network)
GLOBAL_DMAAP_DR_PROV_SERVER_PROTOCOL = "http"
GLOBAL_DMAAP_DR_PROV_SERVER_PORT = "80"
GLOBAL_DMAAP_DR_NODE_SERVER_PROTOCOL = "http"
GLOBAL_DMAAP_DR_NODE_SERVER_PORT = "8080"
# dmaap message router info
GLOBAL_DMAAP_MESSAGE_ROUTER_SERVER_NAME = 'message-router.{{include "common.namespace" .}}'
GLOBAL_DMAAP_MESSAGE_ROUTER_SERVER_PORT = "3904"
# dmaap kafka info
GLOBAL_DMAAP_KAFKA_SERVER_NAME = 'message-router-kafka.{{include "common.namespace" .}}'
GLOBAL_DMAAP_KAFKA_SERVER_PORT = "9092"
GLOBAL_DMAAP_KAFKA_JAAS_USERNAME = '{{ .Values.kafkaJaasUsername }}'
GLOBAL_DMAAP_KAFKA_JAAS_PASSWORD = '{{ .Values.kafkaJaasPassword }}'
# DROOL server port and credentials
GLOBAL_DROOLS_SERVER_PORT = "9696"
GLOBAL_DROOLS_USERNAME = '{{ .Values.droolsUsername }}'
GLOBAL_DROOLS_PASSWORD = '{{ .Values.droolsPassword }}'
GLOBAL_DROOLS_AUTHENTICATION = [GLOBAL_DROOLS_USERNAME, GLOBAL_DROOLS_PASSWORD]
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
GLOBAL_MSB_SERVER_PROTOCOL = "https"
GLOBAL_MSB_SERVER_PORT = "443"
# message router info - everything is from the private oam network (also called onap private network)
GLOBAL_MR_SERVER_PROTOCOL = "http"
GLOBAL_MR_SERVER_PORT = "3904"
# bus controller info
GLOBAL_BC_SERVER_PROTOCOL = "https"
GLOBAL_BC_HTTPS_SERVER_PORT = "8443"
GLOBAL_BC_USERNAME = '{{ .Values.bcUsername }}'
GLOBAL_BC_PASSWORD = '{{ .Values.bcPassword }}'
# dcae inventory and deployment handler info
GLOBAL_INVENTORY_SERVER_NAME = 'inventory.{{include "common.namespace" .}}'
GLOBAL_INVENTORY_SERVER_PROTOCOL = "https"
GLOBAL_INVENTORY_SERVER_PORT = "8080"
GLOBAL_DEPLOYMENT_HANDLER_SERVER_NAME = 'deployment-handler.{{include "common.namespace" .}}'
GLOBAL_DEPLOYMENT_HANDLER_SERVER_PROTOCOL = "https"
GLOBAL_DEPLOYMENT_HANDLER_SERVER_PORT = "8443"
# SO containers - everything is from the private oam network (also called onap private network)
GLOBAL_SO_APIHAND_SERVER_PORT = "8080"
GLOBAL_SO_SDCHAND_SERVER_PORT = "8085"
GLOBAL_SO_BPMN_SERVER_PORT = "8081"
GLOBAL_SO_CATDB_SERVER_PORT = "8082"
GLOBAL_SO_OPENSTACK_SERVER_PORT = "8087"
GLOBAL_SO_REQDB_SERVER_PORT = "8083"
GLOBAL_SO_SDNC_SERVER_PORT =  "8086"
GLOBAL_SO_VFC_SERVER_PORT = "8084"
GLOBAL_SO_VNFM_SERVER_PORT = "9092"
GLOBAL_SO_USERNAME = '{{ .Values.soUsername }}'
GLOBAL_SO_CATDB_USERNAME = '{{ .Values.soCatdbUsername }}'
# robot uses SO_PASSWORD for both SO and CATDB
GLOBAL_SO_PASSWORD = '{{ .Values.soPassword }}'
GLOBAL_SO_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_APIHAND_IP_ADDR + ':' + GLOBAL_SO_APIHAND_SERVER_PORT
GLOBAL_SO_APIHAND_ENDPOINT = GLOBAL_SO_ENDPOINT
GLOBAL_SO_SDCHAND_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_SDCHAND_IP_ADDR + ':' + GLOBAL_SO_SDCHAND_SERVER_PORT
GLOBAL_SO_BPMN_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_BPMN_IP_ADDR + ':' + GLOBAL_SO_BPMN_SERVER_PORT
GLOBAL_SO_CATDB_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_CATDB_IP_ADDR + ':' + GLOBAL_SO_CATDB_SERVER_PORT
GLOBAL_SO_OPENSTACK_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_OPENSTACK_IP_ADDR + ':' + GLOBAL_SO_OPENSTACK_SERVER_PORT
GLOBAL_SO_REQDB_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_REQDB_IP_ADDR + ':' + GLOBAL_SO_REQDB_SERVER_PORT
GLOBAL_SO_SDNC_ENDPOINT =  'http://' + GLOBAL_INJECTED_SO_SDNC_IP_ADDR + ':' + GLOBAL_SO_SDNC_SERVER_PORT
GLOBAL_SO_VFC_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_VFC_IP_ADDR + ':' + GLOBAL_SO_VFC_SERVER_PORT
GLOBAL_SO_VNFM_ENDPOINT = 'https://' + GLOBAL_INJECTED_SO_VNFM_IP_ADDR + ':' + GLOBAL_SO_VNFM_SERVER_PORT
#GLOBAL_SO_VNFM_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_VNFM_IP_ADDR + ':' + GLOBAL_SO_VNFM_SERVER_PORT
# music info - everything is from the private oam network (also called onap private network)
GLOBAL_MUSIC_SERVER_PROTOCOL = "http"
GLOBAL_MUSIC_SERVER_PORT = "8080"
# oof global info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_SERVER_PROTOCOL = "https"
# oof-homing info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_HOMING_SERVER_PORT = "8091"
GLOBAL_OOF_HOMING_USERNAME="{{ .Values.oofHomingUsername }}"
GLOBAL_OOF_HOMING_PASSWORD="{{ .Values.oofHomingPassword }}"
# oof-sniro info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_SNIRO_SERVER_PORT = "8698"
#oof user
GLOBAL_OOF_OSDF_USERNAME="{{ .Values.oofUsername }}"
GLOBAL_OOF_OSDF_PASSWORD="{{ .Values.oofPassword }}"
#oof pci user
GLOBAL_OOF_PCI_USERNAME="{{ .Values.oofOsdfPciOptUsername }}"
GLOBAL_OOF_PCI_PASSWORD="{{ .Values.oofOsdfPciOptPassword }}"
# oof cmso global info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_CMSO_PROTOCOL = "https"
GLOBAL_OOF_CMSO_SERVER_PORT = "8080"
GLOBAL_OOF_CMSO_USERNAME = "{{ .Values.oofCmsoUsername }}"
GLOBAL_OOF_CMSO_PASSWORD = "{{ .Values.oofCmsoPassword }}"
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
GLOBAL_POLICY_AUTH = '{{ .Values.policyAuth}}'
GLOBAL_POLICY_CLIENTAUTH = '{{ .Values.policyClientAuth}}'
GLOBAL_POLICY_USERNAME = '{{ .Values.policyUsername }}'
GLOBAL_POLICY_PASSWORD = '{{ .Values.policyPassword }}'
GLOBAL_POLICY_HEALTHCHECK_USERNAME = '{{ .Values.policyComponentUsername }}'
GLOBAL_POLICY_HEALTHCHECK_PASSWORD = '{{ .Values.policyComponentPassword }}'
# portal info - everything is from the private oam network (also called onap private network)
GLOBAL_PORTAL_SERVER_PROTOCOL = "http"
GLOBAL_PORTAL_SERVER_PORT = "8989"
GLOBAL_PORTAL_USERNAME = '{{ .Values.portalUsername }}'
GLOBAL_PORTAL_PASSWORD = '{{ .Values.portalPassword }}'
# sdnc info - everything is from the private oam network (also called onap private network)
GLOBAL_SDNC_SERVER_PROTOCOL = "http"
GLOBAL_SDNC_REST_PORT = "8282"
GLOBAL_SDNC_ADMIN_PORT = "8843"
GLOBAL_SDNC_USERNAME = '{{ .Values.sdncUsername }}'
GLOBAL_SDNC_PASSWORD = '{{ .Values.sdncPassword }}'
GLOBAL_SDNC_AUTHENTICATION = [GLOBAL_SDNC_USERNAME, GLOBAL_SDNC_PASSWORD]
# sms (AAF)  info
GLOBAL_SMS_SERVER_PROTOCOL = "https"
GLOBAL_SMS_SERVER_NAME = 'aaf-sms.{{include "common.namespace" .}}'
GLOBAL_SMS_SERVER_PORT = "10443"
# vid info - everything is from the private oam network (also called onap private network)
GLOBAL_VID_SERVER_PROTOCOL = '{{ .Values.vidServerProtocol }}'
GLOBAL_VID_SERVER_PORT = '{{ .Values.vidServerPort }}'
GLOBAL_VID_USERNAME = '{{ .Values.vidUsername }}'
GLOBAL_VID_PASSWORD = '{{ .Values.vidPassword}}'
GLOBAL_VID_HEALTH_USERNAME = '{{ .Values.vidHealthUsername }}'
GLOBAL_VID_HEALTH_PASSWORD = '{{ .Values.vidHealthPassword }}'
# vnfsdk info - everything is from the private oam network (also called onap private network)
GLOBAL_VNFSDK_SERVER_PROTOCOL = "http"
GLOBAL_VNFSDK_SERVER_PORT = "8702"

GLOBAL_DCAE_VES_PROTOCOL = "http"
GLOBAL_DCAE_VES_SERVER_PORT = "8080"
#global selenium info
GLOBAL_PROXY_WARNING_TITLE=""
GLOBAL_PROXY_WARNING_CONTINUE_XPATH=""
# dns info
GLOBAL_DNS_TRAFFIC_DURATION = "600"
# location where heat templates and data are loaded from
GLOBAL_HEAT_TEMPLATES_FOLDER = "/var/opt/ONAP/demo/heat"
GLOBAL_PRELOAD_DATA_FOLDER = "/var/opt/ONAP/demo/preload-data"
# location where TOSCA artifacts are loaded from
GLOBAL_TOSCA_ONBOARDING_PACKAGES_FOLDER = "/var/opt/ONAP/demo/tosca"


# cds info - everything is from the private oam network (also called onap private network)
GLOBAL_CCSDK_CDS_SERVER_PROTOCOL = "http"
GLOBAL_CCSDK_CDS_HEALTH_SERVER_PORT = "8080"
GLOBAL_CCSDK_CDS_USERNAME = 'ccsdkapps'
GLOBAL_CCSDK_CDS_PASSWORD = 'ccsdkapps'
GLOBAL_CCSDK_CDS_AUTHENTICATION = [GLOBAL_CCSDK_CDS_USERNAME, GLOBAL_CCSDK_CDS_PASSWORD]

