# Copyright (c) 2018 Amdocs, Bell Canada
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

# File generated from /opt/config
#
GLOBAL_INJECTED_AAF_IP_ADDR = "aaf-service.{{include "common.namespace" .}}"
GLOBAL_INJECTED_AAI1_IP_ADDR = "aai.{{include "common.namespace" .}}"
GLOBAL_INJECTED_AAI2_IP_ADDR = "N/A"
GLOBAL_INJECTED_APPC_IP_ADDR = "appc.{{include "common.namespace" .}}"
GLOBAL_INJECTED_APPC_CDT_IP_ADDR = "appc-cdt.{{include "common.namespace" .}}"
GLOBAL_INJECTED_ARTIFACTS_VERSION = "{{.Values.demoArtifactsVersion}}"
GLOBAL_INJECTED_CLAMP_IP_ADDR = "clamp.{{include "common.namespace" .}}"
GLOBAL_INJECTED_CLI_IP_ADDR = "cli.{{include "common.namespace" .}}"
GLOBAL_INJECTED_CLOUD_ENV = "openstack"
GLOBAL_INJECTED_DCAE_IP_ADDR = "dcae-healthcheck.{{include "common.namespace" .}}"
GLOBAL_INJECTED_DMAAP_DR_PROV_IP_ADDR = "dmaap-dr-prov.{{include "common.namespace" .}}"
GLOBAL_INJECTED_DMAAP_DR_NODE_IP_ADDR = "dmaap-dr-node.{{include "common.namespace" .}}"
GLOBAL_INJECTED_DNS_IP_ADDR = "N/A"
GLOBAL_INJECTED_DOCKER_VERSION = "1.2-STAGING-latest"
GLOBAL_INJECTED_EXTERNAL_DNS = "N/A"
GLOBAL_INJECTED_LOG_ELASTICSEARCH_IP_ADDR = "log-es.{{include "common.namespace" .}}"
GLOBAL_INJECTED_LOG_KIBANA_IP_ADDR = "log-kibana.{{include "common.namespace" .}}"
GLOBAL_INJECTED_LOG_LOGSTASH_IP_ADDR = "log-ls-http.{{include "common.namespace" .}}"
GLOBAL_INJECTED_KEYSTONE = "{{ .Values.openStackKeyStoneUrl }}"
GLOBAL_INJECTED_MR_IP_ADDR = "message-router.{{include "common.namespace" .}}"
GLOBAL_INJECTED_MUSIC_IP_ADDR = "music.{{include "common.namespace" .}}"
GLOBAL_INJECTED_NBI_IP_ADDR = "nbi.{{include "common.namespace" .}}"
GLOBAL_INJECTED_NETWORK = "{{ .Values.openStackPrivateNetId }}"
GLOBAL_INJECTED_NEXUS_DOCKER_REPO = "nexus3.onap.org:10001"
GLOBAL_INJECTED_NEXUS_PASSWORD = "docker"
GLOBAL_INJECTED_NEXUS_REPO = "https://nexus.onap.org/content/sites/raw"
GLOBAL_INJECTED_NEXUS_USERNAME = "docker"
GLOBAL_INJECTED_OOF_IP_ADDR = "N/A"
GLOBAL_INJECTED_OOF_HOMING_IP_ADDR = "oof-has-api.{{include "common.namespace" .}}"
GLOBAL_INJECTED_OOF_SNIRO_IP_ADDR = "oof-osdf.{{include "common.namespace" .}}"
GLOBAL_INJECTED_MSB_IP_ADDR = "msb-iag.{{include "common.namespace" .}}"
GLOBAL_INJECTED_OPENSTACK_API_KEY = "{{ .Values.config.openStackEncryptedPasswordHere}}"
GLOBAL_INJECTED_OPENSTACK_PASSWORD = "{{ .Values.openStackPassword }}"
GLOBAL_INJECTED_OPENSTACK_TENANT_ID = "{{ .Values.openStackTenantId }}"
GLOBAL_INJECTED_OPENSTACK_USERNAME = "{{ .Values.openStackUserName }}"
GLOBAL_INJECTED_POLICY_IP_ADDR = "pdp.{{include "common.namespace" .}}"
GLOBAL_INJECTED_POLICY_HEALTHCHECK_IP_ADDR = "drools.{{include "common.namespace" .}}"
GLOBAL_INJECTED_PORTAL_IP_ADDR = "portal-app.{{include "common.namespace" .}}"
GLOBAL_INJECTED_PUBLIC_NET_ID = "{{ .Values.openStackPublicNetId }}"
GLOBAL_INJECTED_REGION = "{{ .Values.openStackRegion }}"
GLOBAL_INJECTED_SCRIPT_VERSION = "{{ .Values.scriptVersion }}"
GLOBAL_INJECTED_SDC_BE_IP_ADDR = "sdc-be.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SDC_BE_ONBOARD_IP_ADDR = "sdc-onboarding-be.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SDC_FE_IP_ADDR = "sdc-fe.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SDC_IP_ADDR = "N/A"
GLOBAL_INJECTED_SDNC_IP_ADDR = "sdnc.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SDNC_PORTAL_IP_ADDR = "sdnc-portal.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SO_APIHAND_IP_ADDR = "so.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SO_ASDCHAND_IP_ADDR = "so-sdc-controller.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SO_BPMN_IP_ADDR = "so-bpmn-infra.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SO_CATDB_IP_ADDR = "so-catalog-db-adapter.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SO_IP_ADDR = "so.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SO_OPENSTACK_IP_ADDR = "so-openstack-adapter.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SO_REQDB_IP_ADDR = "so-request-db-adapter.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SO_SDNC_IP_ADDR = "so-sdnc-adapter.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SO_VFC_IP_ADDR = "so-vfc-adapter.{{include "common.namespace" .}}"
GLOBAL_INJECTED_UBUNTU_1404_IMAGE = "{{ .Values.ubuntu14Image }}"
GLOBAL_INJECTED_UBUNTU_1604_IMAGE = "{{ .Values.ubuntu16Image }}"
GLOBAL_INJECTED_VM_IMAGE_NAME = "{{ .Values.ubuntu14Image }}"
GLOBAL_INJECTED_VID_IP_ADDR = "vid.{{include "common.namespace" .}}"
GLOBAL_INJECTED_VM_FLAVOR = "{{ .Values.openStackFlavourMedium }}"
GLOBAL_INJECTED_VNFSDK_IP_ADDR = "refrepo.{{include "common.namespace" .}}"

GLOBAL_INJECTED_PROPERTIES = {
    "GLOBAL_INJECTED_AAF_IP_ADDR" : "aaf-service.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_AAI1_IP_ADDR" : "aai.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_AAI2_IP_ADDR" : "N/A",
    "GLOBAL_INJECTED_APPC_IP_ADDR" : "appc.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_APPC_CDT_IP_ADDR" : "appc-cdt.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_ARTIFACTS_VERSION" : "{{.Values.demoArtifactsVersion}}",
    "GLOBAL_INJECTED_CLAMP_IP_ADDR" : "clamp.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_CLI_IP_ADDR" : "cli.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_CLOUD_ENV" : "openstack",
    "GLOBAL_INJECTED_DCAE_IP_ADDR" : "dcae-healthcheck.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_DMAAP_DR_PROV_IP_ADDR" : "dmaap-dr-prov.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_DMAAP_DR_NODE_IP_ADDR" : "dmaap-dr-node.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_DNS_IP_ADDR" : "N/A",
    "GLOBAL_INJECTED_DOCKER_VERSION" : "1.2-STAGING-latest",
    "GLOBAL_INJECTED_EXTERNAL_DNS" : "N/A",
    "GLOBAL_INJECTED_KEYSTONE" : "{{ .Values.openStackKeyStoneUrl }}",
    "GLOBAL_INJECTED_LOG_ELASTICSEARCH_IP_ADDR" : "log-es.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_LOG_KIBANA_IP_ADDR" : "log-kibana.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_LOG_LOGSTASH_IP_ADDR" : "log-ls.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_MR_IP_ADDR" : "message-router.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_MUSIC_IP_ADDR" : "music.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_NBI_IP_ADDR" : "nbi.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_NETWORK" : "{{ .Values.openStackPrivateNetId }}",
    "GLOBAL_INJECTED_NEXUS_DOCKER_REPO" : "nexus3.onap.org:10001",
    "GLOBAL_INJECTED_NEXUS_PASSWORD" : "docker",
    "GLOBAL_INJECTED_NEXUS_REPO" : "https://nexus.onap.org/content/sites/raw",
    "GLOBAL_INJECTED_NEXUS_USERNAME" : "docker",
    "GLOBAL_INJECTED_OOF_IP_ADDR" : "N/A",
    "GLOBAL_INJECTED_OOF_HOMING_IP_ADDR" : "oof-has-api.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_OOF_SNIRO_IP_ADDR" : "oof-osdf.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_MSB_IP_ADDR" : "msb-iag.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_OPENSTACK_API_KEY" : "{{ .Values.config.openStackEncryptedPasswordHere}}",
    "GLOBAL_INJECTED_OPENSTACK_PASSWORD" : "{{ .Values.openStackPassword }}",
    "GLOBAL_INJECTED_OPENSTACK_TENANT_ID" : "{{ .Values.openStackTenantId }}",
    "GLOBAL_INJECTED_OPENSTACK_USERNAME" : "{{ .Values.openStackUserName }}",
    "GLOBAL_INJECTED_POLICY_IP_ADDR" : "pdp.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_POLICY_HEALTHCHECK_IP_ADDR" : "drools.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_PORTAL_IP_ADDR" : "portal-app.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_PUBLIC_NET_ID" : "{{ .Values.openStackPublicNetId }}",
    "GLOBAL_INJECTED_REGION" : "{{ .Values.openStackRegion }}",
    "GLOBAL_INJECTED_SDC_BE_IP_ADDR" : "sdc-be.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SDC_BE_ONBOARD_IP_ADDR" : "sdc-onboarding-be.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SDC_FE_IP_ADDR" : "sdc-fe.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SDC_IP_ADDR" : "N/A",
    "GLOBAL_INJECTED_SCRIPT_VERSION" : "{{ .Values.scriptVersion }}",
    "GLOBAL_INJECTED_SDNC_IP_ADDR" : "sdnc.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SDNC_PORTAL_IP_ADDR" : "sdnc-portal.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SO_APIHAND_IP_ADDR" : "so.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SO_ASDCHAND_IP_ADDR" : "so-sdc-controller.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SO_BPMN_IP_ADDR" : "so-bpmn-infra.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SO_CATDB_IP_ADDR" : "so-catalog-db-adapter.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SO_IP_ADDR" : "so.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SO_OPENSTACK_IP_ADDR" : "so-openstack-adapter.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SO_REQDB_IP_ADDR" : "so-request-db-adapter.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SO_SDNC_IP_ADDR" : "so-sdnc-adapter.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SO_VFC_IP_ADDR" : "so-vfc-adapter.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_UBUNTU_1404_IMAGE" : "{{.Values.ubuntu14Image}}",
    "GLOBAL_INJECTED_UBUNTU_1604_IMAGE" : "{{.Values.ubuntu16Image}}",
    "GLOBAL_INJECTED_VM_IMAGE_NAME" : "{{ .Values.ubuntu14Image }}",
    "GLOBAL_INJECTED_VID_IP_ADDR" : "vid.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_VM_FLAVOR" : "{{ .Values.openStackFlavourMedium }}",
    "GLOBAL_INJECTED_VNFSDK_IP_ADDR" : "refrepo.{{include "common.namespace" .}}"
}
