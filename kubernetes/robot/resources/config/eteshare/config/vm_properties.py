# File generated from /opt/config
#
GLOBAL_INJECTED_AAF_IP_ADDR = "{{.Release.Name}}-aaf.{{include "common.namespace" .}}"
GLOBAL_INJECTED_AAI1_IP_ADDR = "aai.{{include "common.namespace" .}}"
GLOBAL_INJECTED_AAI2_IP_ADDR = "N/A"
GLOBAL_INJECTED_APPC_IP_ADDR = "{{.Release.Name}}-appc.{{include "common.namespace" .}}"
GLOBAL_INJECTED_ARTIFACTS_VERSION = "{{.Values.demoArtifactsVersion}}"
GLOBAL_INJECTED_CLAMP_IP_ADDR = "{{.Release.Name}}-clamp.{{include "common.namespace" .}}"
GLOBAL_INJECTED_CLOUD_ENV = "openstack"
GLOBAL_INJECTED_DCAE_IP_ADDR = "{{.Release.Name}}-dcae-controller.{{include "common.namespace" .}}"
GLOBAL_INJECTED_DNS_IP_ADDR = "N/A"
GLOBAL_INJECTED_DOCKER_VERSION = "1.2-STAGING-latest"
GLOBAL_INJECTED_EXTERNAL_DNS = "N/A"
GLOBAL_INJECTED_GERRIT_BRANCH = "master"
GLOBAL_INJECTED_KEYSTONE = "{{ .Values.openStackKeyStoneUrl }}"
GLOBAL_INJECTED_MR_IP_ADDR = "message-router.{{include "common.namespace" .}}"
GLOBAL_INJECTED_MSO_IP_ADDR = "so.{{include "common.namespace" .}}"
GLOBAL_INJECTED_MUSIC_IP_ADDR = "music.{{include "common.namespace" .}}"
GLOBAL_INJECTED_NETWORK = "{{ .Values.openStackPrivateNetId }}"
GLOBAL_INJECTED_NEXUS_DOCKER_REPO = "nexus3.onap.org:10001"
GLOBAL_INJECTED_NEXUS_PASSWORD = "docker"
GLOBAL_INJECTED_NEXUS_REPO = "https://nexus.onap.org/content/sites/raw"
GLOBAL_INJECTED_NEXUS_USERNAME = "docker"
GLOBAL_INJECTED_OOF_IP_ADDR = "oof.{{include "common.namespace" .}}"
GLOBAL_INJECTED_OPENO_IP_ADDR = "msb-iag.{{include "common.namespace" .}}"
GLOBAL_INJECTED_OPENSTACK_PASSWORD = "{{ .Values.openStackPassword }}"
GLOBAL_INJECTED_OPENSTACK_TENANT_ID = "{{ .Values.openStackTenantId }}"
GLOBAL_INJECTED_OPENSTACK_USERNAME = "{{ .Values.openStackUserName }}"
GLOBAL_INJECTED_POLICY_IP_ADDR = "pdp.{{include "common.namespace" .}}"
GLOBAL_INJECTED_POLICY_HEALTHCHECK_IP_ADDR = "{{.Release.Name}}-drools.{{include "common.namespace" .}}"
GLOBAL_INJECTED_PORTAL_IP_ADDR = "{{.Release.Name}}-portal-app.{{include "common.namespace" .}}"
GLOBAL_INJECTED_PUBLIC_NET_ID = "{{ .Values.openStackPublicNetId }}"
GLOBAL_INJECTED_REGION = "{{ .Values.openStackRegion }}"
GLOBAL_INJECTED_REMOTE_REPO = "http://gerrit.onap.org/r/testsuite/properties.git"
GLOBAL_INJECTED_SCRIPT_VERSION = "{{ .Values.scriptVersion }}"
GLOBAL_INJECTED_SDC_BE_IP_ADDR = "{{.Release.Name}}-sdc-be.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SDC_FE_IP_ADDR = "{{.Release.Name}}-sdc-fe.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SDC_IP_ADDR = "N/A"
GLOBAL_INJECTED_SDNC_IP_ADDR = "{{.Release.Name}}-sdnc.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SDNC_PORTAL_IP_ADDR = "{{.Release.Name}}-sdnc-portal.{{include "common.namespace" .}}"
GLOBAL_INJECTED_SO_IP_ADDR = "so.{{include "common.namespace" .}}"
GLOBAL_INJECTED_UBUNTU_1404_IMAGE = "{{ .Values.ubuntu14Image }}"
GLOBAL_INJECTED_UBUNTU_1604_IMAGE = "{{ .Values.ubuntu16Image }}"
GLOBAL_INJECTED_VID_IP_ADDR = "{{.Release.Name}}-vid.{{include "common.namespace" .}}"
GLOBAL_INJECTED_VM_FLAVOR = "{{ .Values.openStackFlavourMedium }}"

GLOBAL_INJECTED_PROPERTIES = {
    "GLOBAL_INJECTED_AAF_IP_ADDR" : "{{.Release.Name}}-aaf.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_AAI1_IP_ADDR" : "aai.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_AAI2_IP_ADDR" : "N/A",
    "GLOBAL_INJECTED_APPC_IP_ADDR" : "{{.Release.Name}}-appc.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_ARTIFACTS_VERSION" : "{{.Values.demoArtifactsVersion}}",
    "GLOBAL_INJECTED_CLAMP_IP_ADDR" : "{{.Release.Name}}-clamp.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_CLOUD_ENV" : "openstack",
    "GLOBAL_INJECTED_DCAE_IP_ADDR" : "{{.Release.Name}}-dcae-controller.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_DNS_IP_ADDR" : "N/A",
    "GLOBAL_INJECTED_DOCKER_VERSION" : "1.2-STAGING-latest",
    "GLOBAL_INJECTED_EXTERNAL_DNS" : "N/A",
    "GLOBAL_INJECTED_GERRIT_BRANCH" : "master",
    "GLOBAL_INJECTED_KEYSTONE" : "{{ .Values.openStackKeyStoneUrl }}",
    "GLOBAL_INJECTED_MR_IP_ADDR" : "message-router.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_MSO_IP_ADDR" : "so.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_MUSIC_IP_ADDR" : "music.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_NETWORK" : "{{ .Values.openStackPrivateNetId }}",
    "GLOBAL_INJECTED_NEXUS_DOCKER_REPO" : "nexus3.onap.org:10001",
    "GLOBAL_INJECTED_NEXUS_PASSWORD" : "docker",
    "GLOBAL_INJECTED_NEXUS_REPO" : "https://nexus.onap.org/content/sites/raw",
    "GLOBAL_INJECTED_NEXUS_USERNAME" : "docker",
    "GLOBAL_INJECTED_OOF_IP_ADDR" : "oof.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_OPENO_IP_ADDR" : "msb-iag.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_OPENSTACK_PASSWORD" : "{{ .Values.openStackEncryptedPassword }}",
    "GLOBAL_INJECTED_OPENSTACK_TENANT_ID" : "{{ .Values.openStackTenantId }}",
    "GLOBAL_INJECTED_OPENSTACK_USERNAME" : "{{ .Values.openStackUserName }}",
    "GLOBAL_INJECTED_POLICY_IP_ADDR" : "pdp.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_POLICY_HEALTHCHECK_IP_ADDR" : "{{.Release.Name}}-drools.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_PORTAL_IP_ADDR" : "{{.Release.Name}}-portalapps.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_PUBLIC_NET_ID" : "{{ .Values.openStackPublicNetId }}",
    "GLOBAL_INJECTED_REGION" : "{{ .Values.openStackRegion }}",
    "GLOBAL_INJECTED_REMOTE_REPO" : "http://gerrit.onap.org/r/testsuite/properties.git",
    "GLOBAL_INJECTED_SDC_BE_IP_ADDR" : "{{.Release.Name}}-sdc-be.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SDC_FE_IP_ADDR" : "{{.Release.Name}}-sdc-fe.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SDC_IP_ADDR" : "N/A",
    "GLOBAL_INJECTED_SCRIPT_VERSION" : "{{ .Values.scriptVersion }}",
    "GLOBAL_INJECTED_SDNC_IP_ADDR" : "{{.Release.Name}}-sdnc.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SDNC_PORTAL_IP_ADDR" : "{{.Release.Name}}-sdnc-portal.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_SO_IP_ADDR" : "so.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_UBUNTU_1404_IMAGE" : "{{.Values.ubuntu14Image}}",
    "GLOBAL_INJECTED_UBUNTU_1604_IMAGE" : "{{.Values.ubuntu16Image}}",
    "GLOBAL_INJECTED_VID_IP_ADDR" : "{{.Release.Name}}-vid.{{include "common.namespace" .}}",
    "GLOBAL_INJECTED_VM_FLAVOR" : "{{ .Values.openStackFlavourMedium }}"
}