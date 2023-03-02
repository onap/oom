# Copyright (c) 2018 Amdocs, Bell Canada, and others
# Modifications Copyright (c) 2020 AT&T Intellectual Property
# Modifications Copyright (c) 2020 NOKIA Intellectual Property
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

GLOBAL_INJECTED_AAF_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "aaf-service") }}'
GLOBAL_INJECTED_AAI_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "aai") }}'
GLOBAL_INJECTED_ARTIFACTS_VERSION = '{{.Values.demoArtifactsVersion}}'
GLOBAL_INJECTED_ARTIFACTS_REPO_URL = "{{ .Values.demoArtifactsRepoUrl }}"
GLOBAL_INJECTED_CLAMP_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "policy-gui") }}'
GLOBAL_INJECTED_CLI_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "cli") }}'
GLOBAL_INJECTED_CLOUD_ENV = 'openstack'
GLOBAL_INJECTED_DCAE_COLLECTOR_IP = "{{ .Values.dcaeCollectorIp }}"
GLOBAL_INJECTED_DCAE_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dcae-healthcheck") }}'
GLOBAL_INJECTED_DCAE_MS_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dcae-ms-healthcheck") }}'
GLOBAL_INJECTED_DCAE_VES_HOST = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dcae-ves-collector") }}'
GLOBAL_INJECTED_DNS_IP_ADDR = 'N/A'
GLOBAL_INJECTED_DOCKER_VERSION = '1.2-STAGING-latest'
GLOBAL_INJECTED_EXTERNAL_DNS = 'N/A'
GLOBAL_INJECTED_HOLMES_ENGINE_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "holmes-engine-mgmt") }}'
GLOBAL_INJECTED_HOLMES_RULE_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "holmes-rule-mgmt") }}'
GLOBAL_INJECTED_LOG_ELASTICSEARCH_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "log-es") }}'
GLOBAL_INJECTED_LOG_KIBANA_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "log-kibana") }}'
GLOBAL_INJECTED_LOG_LOGSTASH_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "log-ls-http") }}'
GLOBAL_INJECTED_POMBA_AAI_CONTEXT_BUILDER_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pomba-aaictxbuilder") }}'
GLOBAL_INJECTED_POMBA_SDC_CONTEXT_BUILDER_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pomba-sdcctxbuilder") }}'
GLOBAL_INJECTED_POMBA_NETWORK_DISC_CONTEXT_BUILDER_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pomba-networkdiscoveryctxbuilder") }}'
GLOBAL_INJECTED_POMBA_SERVICE_DECOMPOSITION_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pomba-servicedecomposition") }}'
GLOBAL_INJECTED_POMBA_SDNC_CTX_BUILDER_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pomba-sdncctxbuilder") }}'
GLOBAL_INJECTED_POMBA_NETWORKDISCOVERY_MICROSERVICE_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pomba-networkdiscovery") }}'
GLOBAL_INJECTED_POMBA_VALIDATION_SERVICE_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pomba-validation-service") }}'
GLOBAL_INJECTED_POMBA_KIBANA_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pomba-kibana") }}'
GLOBAL_INJECTED_POMBA_ELASTIC_SEARCH_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pomba-es") }}'
GLOBAL_INJECTED_POMBA_CONTEX_TAGGREGATOR_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pomba-contextaggregator") }}'
GLOBAL_INJECTED_KEYSTONE = '{{ .Values.openStackKeyStoneUrl }}'
GLOBAL_INJECTED_MUSIC_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "music") }}'
GLOBAL_INJECTED_NBI_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "nbi") }}'
GLOBAL_INJECTED_NETWORK = '{{ .Values.openStackPrivateNetId }}'
GLOBAL_INJECTED_NEXUS_DOCKER_REPO = '{{ include "common.repository" . }}'
GLOBAL_INJECTED_NEXUS_PASSWORD = 'docker'
GLOBAL_INJECTED_NEXUS_REPO ='https://nexus.onap.org/content/sites/raw'
GLOBAL_INJECTED_NEXUS_USERNAME = 'docker'
GLOBAL_INJECTED_OOF_IP_ADDR = 'N/A'
GLOBAL_INJECTED_OOF_HOMING_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "oof-has-api") }}'
GLOBAL_INJECTED_OOF_SNIRO_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "oof-osdf") }}'
GLOBAL_INJECTED_OOF_CMSO_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "oof-cmso") }}'
GLOBAL_INJECTED_MSB_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "msb-iag") }}'
GLOBAL_INJECTED_MC_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "multicloud") }}'
GLOBAL_INJECTED_MC_PIKE_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "multicloud-pike") }}'
GLOBAL_INJECTED_MC_PROMETHEUS_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "multicloud-prometheus") }}'
GLOBAL_INJECTED_MC_STARLINGX_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "multicloud-starlingx") }}'
GLOBAL_INJECTED_MC_TC_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "multicloud-titaniumcloud") }}'
GLOBAL_INJECTED_MC_VIO_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "multicloud-vio") }}'
GLOBAL_INJECTED_MC_K8S_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "multicloud-k8s") }}'
GLOBAL_INJECTED_MC_FCAPS_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "multicloud-fcaps") }}'
GLOBAL_INJECTED_OPENSTACK_API_KEY = '{{ .Values.config.openStackEncryptedPasswordHere}}'
GLOBAL_INJECTED_OPENSTACK_TENANT_ID = '{{ .Values.openStackTenantId }}'
GLOBAL_INJECTED_OPENSTACK_USERNAME = '{{ .Values.openStackUserName }}'
GLOBAL_INJECTED_OPENSTACK_PROJECT_NAME = '{{ .Values.openStackProjectName }}'
GLOBAL_INJECTED_OPENSTACK_DOMAIN_ID = '{{ .Values.openStackDomainId }}'
GLOBAL_INJECTED_OPENSTACK_USER_DOMAIN = '{{ .Values.openStackUserDomain }}'
GLOBAL_INJECTED_OPENSTACK_KEYSTONE_API_VERSION = '{{ .Values.openStackKeystoneAPIVersion }}'
GLOBAL_INJECTED_REGION_THREE = '{{ .Values.openStackRegionRegionThree }}'
GLOBAL_INJECTED_KEYSTONE_REGION_THREE = '{{ .Values.openStackKeyStoneUrlRegionThree }}'
GLOBAL_INJECTED_MODEL_PARSER_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "modeling-etsicatalog") }}'
GLOBAL_INJECTED_OPENSTACK_KEYSTONE_API_VERSION_REGION_THREE = '{{ .Values.openStackKeystoneAPIVersionRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_USERNAME_REGION_THREE = '{{ .Values.openStackUserNameRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_SO_ENCRYPTED_PASSWORD_REGION_THREE  = '{{ .Values.openSackMsoEncryptdPasswordRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_SO_ENCRYPTED_PASSWORD = '{{ .Values.config.openStackSoEncryptedPassword}}'
GLOBAL_INJECTED_OPENSTACK_TENANT_ID_REGION_THREE = '{{ .Values.openStackTenantIdRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_PROJECT_DOMAIN_REGION_THREE = '{{ .Values.openStackProjectNameRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_USER_DOMAIN_REGION_THREE = '{{ .Values.openStackDomainIdRegionThree }}'
GLOBAL_INJECTED_OPENSTACK_OAM_NETWORK_CIDR_PREFIX = '{{ .Values.openStackOamNetworkCidrPrefix }}'
GLOBAL_INJECTED_OPENSTACK_OAM_NETWORK_3RD_OCTET = '{{ .Values.openStackOamNetwork3rdOctet}}'
GLOBAL_INJECTED_OPENSTACK_PUBLIC_NETWORK = '{{ .Values.openStackPublicNetworkName }}'
GLOBAL_INJECTED_OPENSTACK_SECURITY_GROUP = '{{ .Values.openStackSecurityGroup }}'
GLOBAL_INJECTED_OPENSTACK_PRIVATE_SUBNET_ID = "{{ .Values.openStackPrivateSubnetId }}"
GLOBAL_INJECTED_OPENSTACK_PRIVATE_NET_CIDR = "{{ .Values.openStackPrivateNetCidr }}"
GLOBAL_INJECTED_POLICY_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "pdp") }}'
GLOBAL_INJECTED_POLICY_DROOLS_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "policy-drools-pdp") }}'
GLOBAL_INJECTED_PORTAL_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "portal-app") }}'
GLOBAL_INJECTED_POLICY_API_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "policy-api") }}'
GLOBAL_INJECTED_POLICY_PAP_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "policy-pap") }}'
GLOBAL_INJECTED_POLICY_DISTRIBUTION_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "policy-distribution") }}'
GLOBAL_INJECTED_POLICY_PDPX_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "policy-xacml-pdp") }}'
GLOBAL_INJECTED_POLICY_APEX_PDP_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "policy-apex-pdp") }}'
GLOBAL_INJECTED_PUBLIC_NET_ID = '{{ .Values.openStackPublicNetId }}'
GLOBAL_INJECTED_PRIVATE_KEY = "{{ .Files.Get .Values.vnfPrivateKey }}"
GLOBAL_INJECTED_PUBLIC_KEY = "{{ .Values.vnfPubKey }}"
GLOBAL_INJECTED_REGION = '{{ .Values.openStackRegion }}'
GLOBAL_INJECTED_SCRIPT_VERSION = '{{ .Values.scriptVersion }}'
GLOBAL_INJECTED_SDC_BE_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "sdc-be") }}'
GLOBAL_INJECTED_SDC_BE_ONBOARD_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "sdc-onboarding-be") }}'
GLOBAL_INJECTED_SDC_FE_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "sdc-fe") }}'
GLOBAL_INJECTED_SDC_DCAE_BE_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "sdc-dcae-be") }}'
GLOBAL_INJECTED_SDC_IP_ADDR = 'N/A'
GLOBAL_INJECTED_SDNC_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "sdnc") }}'
GLOBAL_INJECTED_SDNC_PORTAL_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "sdnc-portal") }}'
GLOBAL_INJECTED_SO_APIHAND_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "so") }}'
GLOBAL_INJECTED_SO_SDCHAND_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "so-sdc-controller") }}'
GLOBAL_INJECTED_SO_BPMN_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "so-bpmn-infra") }}'
GLOBAL_INJECTED_SO_CATDB_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "so-catalog-db-adapter") }}'
GLOBAL_INJECTED_SO_OPENSTACK_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "so-openstack-adapter") }}'
GLOBAL_INJECTED_SO_REQDB_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "so-request-db-adapter") }}'
GLOBAL_INJECTED_SO_SDNC_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "so-sdnc-adapter") }}'
GLOBAL_INJECTED_SO_VFC_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "so-etsi-sol005-adapter") }}'
GLOBAL_INJECTED_SO_VNFM_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "so-etsi-sol003-adapter") }}'
GLOBAL_INJECTED_SO_NSSMF_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "so-nssmf-adapter") }}'
GLOBAL_INJECTED_UBUNTU_1404_IMAGE = '{{ .Values.ubuntu14Image }}'
GLOBAL_INJECTED_UBUNTU_1604_IMAGE = '{{ .Values.ubuntu16Image }}'
GLOBAL_INJECTED_UUI_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "uui-server") }}'
GLOBAL_INJECTED_VFC_GVNFMDRIVER_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "vfc-generic-vnfm-driver") }}'
GLOBAL_INJECTED_VFC_HUAWEIVNFMDRIVER_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "vfc-huawei-vnfm-driver") }}'
GLOBAL_INJECTED_VFC_NSLCM_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "vfc-nslcm") }}'
GLOBAL_INJECTED_VFC_VNFLCM_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "vfc-vnflcm") }}'
GLOBAL_INJECTED_VFC_VNFMGR_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "vfc-vnfmgr") }}'
GLOBAL_INJECTED_VFC_VNFRES_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "vfc-vnfres") }}'
GLOBAL_INJECTED_VFC_ZTEVNFDRIVER_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "vfc-zte-vnfm-driver") }}'
GLOBAL_INJECTED_VM_IMAGE_NAME = '{{ .Values.ubuntu14Image }}'
GLOBAL_INJECTED_DANOS_IMAGE_NAME = '{{ .Values.danosImage }}'
GLOBAL_INJECTED_DANOS_FLAVOR = '{{ .Values.danosFlavor }}'
GLOBAL_INJECTED_VID_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "vid") }}'
GLOBAL_INJECTED_VM_FLAVOR = '{{ .Values.openStackFlavourMedium }}'
GLOBAL_INJECTED_VNFSDK_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "refrepo") }}'
GLOBAL_INJECTED_CCSDK_CDS_BLUEPRINT_PROCESSOR_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "cds-blueprints-processor-http") }}'

# aaf info - everything is from the private oam network (also called onap private network)
GLOBAL_AAF_SERVER = 'https://{{include "robot.ingress.svchost" (dict "root" . "hostname" "aaf-service") }}:{{include "robot.ingress.port" (dict "root" . "hostname" "aaf-service" "port" 8100) }}'
GLOBAL_AAF_USERNAME = '{{ .Values.aafUsername }}'
GLOBAL_AAF_PASSWORD = '{{ .Values.aafPassword }}'
GLOBAL_AAF_AUTHENTICATION = [GLOBAL_AAF_USERNAME, GLOBAL_AAF_PASSWORD]
# aai info - everything is from the private oam network (also called onap private network)
GLOBAL_AAI_SERVER_PROTOCOL = '{{ include "common.scheme" . }}'
GLOBAL_AAI_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "aai" "port" 80 ) }}'
GLOBAL_AAI_USERNAME = '{{ .Values.aaiUsername }}'
GLOBAL_AAI_PASSWORD = '{{ .Values.aaiPassword}}'
GLOBAL_AAI_AUTHENTICATION = [GLOBAL_AAI_USERNAME, GLOBAL_AAI_PASSWORD]
# sdc info - everything is from the private oam network (also called onap private network)
GLOBAL_SDC_SERVER_PROTOCOL = 'http'
GLOBAL_SDC_FE_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "sdc-fe" "port" 8181) }}'
GLOBAL_SDC_BE_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "sdc-be" "port" 8080) }}'
GLOBAL_SDC_BE_ONBOARD_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "sdc-onboarding-be" "port" 8081) }}'
GLOBAL_SDC_DCAE_BE_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "sdc-dcae-be" "port" 8444) }}'
GLOBAL_SDC_USERNAME = '{{ .Values.sdcUsername }}'
GLOBAL_SDC_PASSWORD = '{{ .Values.sdcPassword }}'
GLOBAL_SDC_AUTHENTICATION = [GLOBAL_SDC_USERNAME, GLOBAL_SDC_PASSWORD]
# clamp info - everything is from the private oam network (also called onap private network)
GLOBAL_CLAMP_SERVER_PROTOCOL = 'http'
GLOBAL_CLAMP_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "policy-gui" "port" 2443) }}'
# nbi info - everything is from the private oam network (also called onap private network)
GLOBAL_NBI_SERVER_PROTOCOL = 'http'
GLOBAL_NBI_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "nbi" "port" 8080) }}'
# cli info - everything is from the private oam network (also called onap private network)
GLOBAL_CLI_SERVER_PROTOCOL = "http"
GLOBAL_CLI_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "cli" "port" 8080) }}'
# dcae info - everything is from the private oam network (also called onap private network)
GLOBAL_DCAE_SERVER_PROTOCOL = "http"
GLOBAL_DCAE_HEALTH_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dcae-healthcheck" "port" 80) }}'
GLOBAL_DCAE_USERNAME = '{{ .Values.dcaeUsername }}'
GLOBAL_DCAE_PASSWORD = '{{ .Values.dcaePassword}}'
GLOBAL_DCAE_AUTHENTICATION = [GLOBAL_DCAE_USERNAME, GLOBAL_DCAE_PASSWORD]
# dcae microservice info - everything is from the private oam network (also called onap private network)
GLOBAL_DCAE_MS_SERVER_PROTOCOL = "http"
GLOBAL_DCAE_MS_HEALTH_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dcae-healthcheck" "port" 8080) }}'
GLOBAL_DCAE_MS_USERNAME = '{{ .Values.dcaeMsUsername }}'
GLOBAL_DCAE_MS_PASSWORD = '{{ .Values.dcaeMsPassword}}'
GLOBAL_DCAE_AUTHENTICATION = [GLOBAL_DCAE_USERNAME, GLOBAL_DCAE_PASSWORD]
# dcae hv-ves info
GLOBAL_DCAE_HVVES_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dcae-hv-ves-collector") }}'
GLOBAL_DCAE_HVVES_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dcae-hv-ves-collector" "port" 6061) }}'

#DMAAP
# message router info - everything is from the private oam network (also called onap private network)
GLOBAL_MR_SERVER_PROTOCOL = "http"
GLOBAL_MR_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "message-router" "port" 3904) }}'
GLOBAL_INJECTED_MR_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "message-router") }}'
GLOBAL_DMAAP_MESSAGE_ROUTER_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "message-router") }}'
GLOBAL_DMAAP_MESSAGE_ROUTER_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "message-router" "port" 3904) }}'
# bus controller info
GLOBAL_INJECTED_BC_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dmaap-bc") }}'
GLOBAL_BC_SERVER_PROTOCOL = 'http'
GLOBAL_BC_HTTPS_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dmaap-bc" "port" 8080) }}'
GLOBAL_BC_USERNAME = '{{ .Values.bcUsername }}'
GLOBAL_BC_PASSWORD = '{{ .Values.bcPassword }}'
# data router info - everything is from the private oam network (also called onap private network)
GLOBAL_DMAAP_DR_PROV_SERVER_PROTOCOL = 'http'
GLOBAL_DMAAP_DR_PROV_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dmaap-dr-prov" "port" 8080) }}'
GLOBAL_INJECTED_DMAAP_DR_PROV_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dmaap-dr-prov") }}'
GLOBAL_DMAAP_DR_NODE_SERVER_PROTOCOL = 'http'
GLOBAL_DMAAP_DR_NODE_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dmapp-dr-node" "port" 8080) }}'
GLOBAL_INJECTED_DMAAP_DR_NODE_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dmaap-dr-node") }}'

# strimzi kafka
GLOBAL_KAFKA_BOOTSTRAP_SERVICE = '{{ include "common.release" . }}-strimzi-kafka-bootstrap:9092'
GLOBAL_KAFKA_USER = '{{ .Values.strimziKafkaUsername }}'

# DROOL server port and credentials
GLOBAL_DROOLS_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "policy-drools-pdp" "port" 9696) }}'
GLOBAL_DROOLS_USERNAME = '{{ .Values.droolsUsername }}'
GLOBAL_DROOLS_PASSWORD = '{{ .Values.droolsPassword }}'
GLOBAL_DROOLS_AUTHENTICATION = [GLOBAL_DROOLS_USERNAME, GLOBAL_DROOLS_PASSWORD]

# holmes info
GLOBAL_HOLMES_ENGINE_SERVER_PROTOCOL = 'http'
GLOBAL_HOLMES_ENGINE_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "holmes-engine-mgmt" "port" 9102) }}'
GLOBAL_HOLMES_RULE_SERVER_PROTOCOL = 'http'
GLOBAL_HOLMES_RULE_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "holmes-rule-mgmt" "port" 9101) }}'

# log server config - NOTE: no log server is run in HEAT; only on OOM
GLOBAL_LOG_SERVER_PROTOCOL = "http"
GLOBAL_LOG_ELASTICSEARCH_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "log-es" "port" 9200) }}'
GLOBAL_LOG_LOGSTASH_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "log-ls-http" "port" 9600) }}'
GLOBAL_LOG_KIBANA_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "log-kibana" "port" 5601) }}'
# pomba info - NOTE: no pomba is run in HEAT; only on OOM
GLOBAL_POMBA_SERVER_PROTOCOL_HTTP = "http"
GLOBAL_POMBA_SERVER_PROTOCOL_HTTPS = "https"
GLOBAL_POMBA_AAICONTEXTBUILDER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "pomba-aaictxbuilder" "port" 9530) }}'
GLOBAL_POMBA_SDCCONTEXTBUILDER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "pomba-sdcctxbuilder" "port" 9530) }}'
GLOBAL_POMBA_NETWORKDISCCONTEXTBUILDER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "pomba-networkdiscoveryctxbuilder" "port" 9530) }}'
GLOBAL_POMBA_SERVICEDECOMPOSITION_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "pomba-servicedecomposition" "port" 9532) }}'
GLOBAL_POMBA_SDNCCXTBUILDER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "pomba-sdncctxbuilder" "port" 9530) }}'
GLOBAL_POMBA_NETWORKDISCOVERY_MICROSERVICE_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "pomba-networkdiscovery" "port" 9531) }}'
GLOBAL_POMBA_VALIDATIONSERVICE_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "pomba-validation-service" "port" 9529) }}'
GLOBAL_POMBA_KIBANA_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "pomba-kibana" "port" 5601) }}'
GLOBAL_POMBA_ELASTICSEARCH_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "pomba-es" "port" 9200) }}'
GLOBAL_POMBA_CONTEXTAGGREGATOR_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "pomba-contextaggregator" "port" 9529) }}'

# microservice bus info - everything is from the private oam network (also called onap private network)
GLOBAL_MSB_SERVER_PROTOCOL = 'http'
GLOBAL_MSB_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "msb-iag" "port" 80) }}'

# multicloud info
GLOBAL_MC_SERVER_PROTOCOL = 'http'
GLOBAL_MC_PIKE_SERVER_PROTOCOL = 'http'
GLOBAL_MC_PROMETHEUS_SERVER_PROTOCOL = 'http'
GLOBAL_MC_STARLINGX_SERVER_PROTOCOL = 'http'
GLOBAL_MC_TC_SERVER_PROTOCOL = 'http'
GLOBAL_MC_VIO_SERVER_PROTOCOL = 'http'
GLOBAL_MC_K8S_SERVER_PROTOCOL = 'http'
GLOBAL_MC_FCAPS_SERVER_PROTOCOL = 'http'
GLOBAL_MC_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "multicloud" "port" 9001) }}'
GLOBAL_MC_PIKE_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "multicloud-pike" "port" 9007) }}'
GLOBAL_MC_PROMETHEUS_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "multicloud-prometheus" "port" 9090) }}'
GLOBAL_MC_STARLINGX_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "multicloud-starlingx" "port" 9009) }}'
GLOBAL_MC_TC_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "multicloud-titaniumcloud" "port" 9005) }}'
GLOBAL_MC_VIO_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "multicloud-vio" "port" 9004) }}'
GLOBAL_MC_K8S_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "multicloud-k8s" "port" 9015) }}'
GLOBAL_MC_FCAPS_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "multicloud-fcaps" "port" 9011) }}'

# dcae inventory and deployment handler info
GLOBAL_INVENTORY_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "inventory") }}'
GLOBAL_INVENTORY_SERVER_PROTOCOL = "https"
GLOBAL_INVENTORY_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "inventory" "port" 8080) }}'
GLOBAL_DEPLOYMENT_HANDLER_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "deployment-handler") }}'
GLOBAL_DEPLOYMENT_HANDLER_SERVER_PROTOCOL = "https"
GLOBAL_DEPLOYMENT_HANDLER_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "deployment-handler" "port" 8443) }}'
GLOBAL_K8S_CHART_REPOSTORY_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "chart-museum") }}'
GLOBAL_K8S_CHART_REPOSTORY_SERVER_PROTOCOL = "http"
GLOBAL_K8S_CHART_REPOSTORY_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "chart-museum" "port" 80) }}'
GLOBAL_K8S_CHART_REPOSTORY_SERVER_USERNAME = '{{ .Values.k8sChartRepoUsername }}'
GLOBAL_K8S_CHART_REPOSTORY_SERVER_PASSWORD = '{{ .Values.k8sChartRepoPassword }}'
# consul info
GLOBAL_CONSUL_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "consul-server-ui") }}'
GLOBAL_CONSUL_SERVER_PROTOCOL = "http"
GLOBAL_CONSUL_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "consul-server-ui" "port" 8500) }}'

# dcae mod info
GLOBAL_DCAEMOD_ONBOARDING_API_SERVER_PROTOCOL = "http"
GLOBAL_DCAEMOD_ONBOARDING_API_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dcaemod-onboarding-api" "port" 8080) }}'
GLOBAL_DCAEMOD_ONBOARDING_API_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dcaemod-onboarding-api") }}'
GLOBAL_DCAEMOD_RUNTIME_API_SERVER_PROTOCOL = "http"
GLOBAL_DCAEMOD_RUNTIME_API_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dcaemod-runtime-api" "port" 9090) }}'
GLOBAL_DCAEMOD_RUNTIME_API_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dcaemod-runtime-api") }}'
GLOBAL_DCAEMOD_DISTRIBUTOR_API_SERVER_PROTOCOL = "http"
GLOBAL_DCAEMOD_DISTRIBUTOR_API_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dcaemod-distributor-api" "port" 8080) }}'
GLOBAL_DCAEMOD_DISTRIBUTOR_API_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dcaemod-distributor-api") }}'
GLOBAL_DCAEMOD_DESIGNTOOL_SERVER_PROTOCOL = "http"
GLOBAL_DCAEMOD_DESIGNTOOL_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dcaemod-designtool" "port" 8080) }}'
GLOBAL_DCAEMOD_DESIGNTOOL_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dcaemod-designtool") }}'
GLOBAL_DCAEMOD_NIFI_REGISTRY_PROTOCOL = "http"
GLOBAL_DCAEMOD_NIFI_REGISTRY_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dcaemod-nifi-registry" "port" 18080) }}'
GLOBAL_DCAEMOD_NIFI_REGISTRY_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "dcaemod-nifi-registry") }}'
# SO containers - everything is from the private oam network (also called onap private network)
GLOBAL_SO_APIHAND_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "so" "port" 8080) }}'
GLOBAL_SO_SDCHAND_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "so-sdc-controller" "port" 8085) }}'
GLOBAL_SO_BPMN_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "so-bpmn-infra" "port" 8081) }}'
GLOBAL_SO_CATDB_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "so-catalog-db-adapter" "port" 8082) }}'
GLOBAL_SO_OPENSTACK_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "so-openstack-adapter" "port" 8087) }}'
GLOBAL_SO_REQDB_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "so-request-db-adapter" "port" 8083) }}'
GLOBAL_SO_SDNC_SERVER_PORT =  '{{include "robot.ingress.port" (dict "root" . "hostname" "so-sdnc-adapter" "port" 8086) }}'
GLOBAL_SO_VFC_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "so-etsi-sol005-adapter" "port" 8084) }}'
GLOBAL_SO_VNFM_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "so-etsi-sol003-adapter" "port" 9092) }}'
GLOBAL_SO_NSSMF_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "so-nssmf-adapter" "port" 8088) }}'
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
GLOBAL_SO_VNFM_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_VNFM_IP_ADDR + ':' + GLOBAL_SO_VNFM_SERVER_PORT
GLOBAL_SO_NSSMF_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_NSSMF_IP_ADDR + ':' + GLOBAL_SO_NSSMF_SERVER_PORT
#GLOBAL_SO_VNFM_ENDPOINT = 'http://' + GLOBAL_INJECTED_SO_VNFM_IP_ADDR + ':' + GLOBAL_SO_VNFM_SERVER_PORT
# modeling info
GLOBAL_MODEL_PARSER_SERVER_PROTOCOL = "http"
GLOBAL_MODEL_PARSER_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "modeling-etsicatalog" "port" 8806) }}'
# music info - everything is from the private oam network (also called onap private network)
GLOBAL_MUSIC_SERVER_PROTOCOL = "https"
GLOBAL_MUSIC_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "music" "port" 8443) }}'
# oof global info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_SERVER_PROTOCOL = 'http'
# oof-homing info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_HOMING_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "oof-has-api" "port" 8091) }}'
GLOBAL_OOF_HOMING_USERNAME="{{ .Values.oofHomingUsername }}"
GLOBAL_OOF_HOMING_PASSWORD="{{ .Values.oofHomingPassword }}"
# oof-sniro info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_SNIRO_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "oof-osdf" "port" 8698) }}'
#oof user
GLOBAL_OOF_OSDF_USERNAME="{{ .Values.oofUsername }}"
GLOBAL_OOF_OSDF_PASSWORD="{{ .Values.oofPassword }}"
#oof pci user
GLOBAL_OOF_PCI_USERNAME="{{ .Values.oofOsdfPciOptUsername }}"
GLOBAL_OOF_PCI_PASSWORD="{{ .Values.oofOsdfPciOptPassword }}"
# oof cmso global info - everything is from the private oam network (also called onap private network)
GLOBAL_OOF_CMSO_PROTOCOL = "http"
GLOBAL_OOF_CMSO_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "oof-cmso" "port" 8080) }}'
GLOBAL_OOF_CMSO_USERNAME = "{{ .Values.oofCmsoUsername }}"
GLOBAL_OOF_CMSO_PASSWORD = "{{ .Values.oofCmsoPassword }}"
# openstack info - info to select right info in environment
# packet generate vnf info - everything is from the private oam network (also called onap private network)
GLOBAL_PACKET_GENERATOR_PORT = "8183"
GLOBAL_PACKET_GENERATOR_USERNAME = "admin"
GLOBAL_PACKET_GENERATOR_PASSWORD = "admin"
GLOBAL_PGN_PORT = "2831"
# policy info - everything is from the private oam network (also called onap private network)
GLOBAL_POLICY_SERVER_PROTOCOL = 'http'
GLOBAL_POLICY_SERVER_PORT = "8081"
GLOBAL_POLICY_HEALTHCHECK_PORT = "6969"
GLOBAL_POLICY_AUTH = '{{ .Values.policyAuth}}'
GLOBAL_POLICY_CLIENTAUTH = '{{ .Values.policyClientAuth}}'
GLOBAL_POLICY_USERNAME = '{{ .Values.policyUsername }}'
GLOBAL_POLICY_PASSWORD = '{{ .Values.policyPassword }}'
GLOBAL_POLICY_HEALTHCHECK_USERNAME = '{{ .Values.policyComponentUsername }}'
GLOBAL_POLICY_HEALTHCHECK_PASSWORD = '{{ .Values.policyComponentPassword }}'
GLOBAL_POLICY_ADMIN_USERNAME = '{{ .Values.policyAdminUsername }}'
GLOBAL_POLICY_ADMIN_PASSWORD = '{{ .Values.policyAdminPassword }}'
# portal info - everything is from the private oam network (also called onap private network)
GLOBAL_PORTAL_SERVER_PROTOCOL = "https"
GLOBAL_PORTAL_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "portal-app" "port" 8443) }}'
GLOBAL_PORTAL_USERNAME = '{{ .Values.portalUsername }}'
GLOBAL_PORTAL_PASSWORD = '{{ .Values.portalPassword }}'
# sdnc info - everything is from the private oam network (also called onap private network)
GLOBAL_SDNC_SERVER_PROTOCOL = 'http'
GLOBAL_SDNC_REST_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "sdnc" "port" 8282) }}'
GLOBAL_SDNC_ADMIN_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "sdnc-portal" "port" 8080) }}'
GLOBAL_SDNC_USERNAME = '{{ .Values.sdncUsername }}'
GLOBAL_SDNC_PASSWORD = '{{ .Values.sdncPassword }}'
GLOBAL_SDNC_AUTHENTICATION = [GLOBAL_SDNC_USERNAME, GLOBAL_SDNC_PASSWORD]
# sms (AAF)  info
GLOBAL_SMS_SERVER_PROTOCOL = "https"
GLOBAL_SMS_SERVER_NAME = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "aaf-sms") }}'
GLOBAL_SMS_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "aaf-sms" "port" 10443) }}'
# uui info
GLOBAL_UUI_SERVER_PROTOCOL = "http"
GLOBAL_UUI_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "uui-server" "port" 8082) }}'
# vfc info
GLOBAL_VFC_GVNFMDRIVER_SERVER_PROTOCOL = 'http'
GLOBAL_VFC_GVNFMDRIVER_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "vfc-generic-vnfm-driver" "port" 8484) }}'
GLOBAL_VFC_HUAWEIVNFMDRIVER_SERVER_PROTOCOL = 'http'
GLOBAL_VFC_HUAWEIVNFMDRIVER_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "vfc-huawei-vnfm-driver" "port" 8482) }}'
GLOBAL_VFC_NSLCM_SERVER_PROTOCOL = 'http'
GLOBAL_VFC_NSLCM_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "vfc-nslcm" "port" 8403) }}'
GLOBAL_VFC_VNFLCM_SERVER_PROTOCOL = 'http'
GLOBAL_VFC_VNFLCM_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "vfc-vnflcm" "port" 8801) }}'
GLOBAL_VFC_VNFMGR_SERVER_PROTOCOL = 'http'
GLOBAL_VFC_VNFMGR_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "vfc-vnfmgr" "port" 8803) }}'
GLOBAL_VFC_VNFRES_SERVER_PROTOCOL = 'http'
GLOBAL_VFC_VNFRES_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "vfc-vnfres" "port" 8802) }}'
GLOBAL_VFC_ZTEVNFDRIVER_SERVER_PROTOCOL = 'http'
GLOBAL_VFC_ZTEVNFDRIVER_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "vfc-zte-vnfm-driver" "port" 8410) }}'
# vid info - everything is from the private oam network (also called onap private network)
GLOBAL_VID_SERVER_PROTOCOL = '{{ .Values.vidServerProtocol }}'
GLOBAL_VID_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "clamp" "port" (.Values.vidServerPort | default 0 | int)) }}'
GLOBAL_VID_USERNAME = '{{ .Values.vidUsername }}'
GLOBAL_VID_PASSWORD = '{{ .Values.vidPassword}}'
GLOBAL_VID_HEALTH_USERNAME = '{{ .Values.vidHealthUsername }}'
GLOBAL_VID_HEALTH_PASSWORD = '{{ .Values.vidHealthPassword }}'
# vnfsdk info - everything is from the private oam network (also called onap private network)
GLOBAL_VNFSDK_SERVER_PROTOCOL = 'http'
GLOBAL_VNFSDK_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "refrepo" "port" 8703) }}'

GLOBAL_DCAE_VES_PROTOCOL = "http"
GLOBAL_DCAE_VES_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dcae-ves-collector" "port" 8080) }}'
GLOBAL_DCAE_VES_HTTPS_PROTOCOL = 'http{{ (eq "true" (include "common.needTLS" .)) | ternary "s" "" }}'
GLOBAL_DCAE_VES_HTTPS_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "dcae-ves-collector-https" "port" 8080) }}'
GLOBAL_DCAE_VES_USERNAME = 'sample1'
GLOBAL_DCAE_VES_PASSWORD = 'sample1'


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
GLOBAL_CDS_AUTH = "Y2NzZGthcHBzOmNjc2RrYXBwcw=="

#cps info - everything is from the private oam network (also called onap private network)
GLOBAL_INJECTED_CPS_IP_ADDR = '{{include "robot.ingress.svchost" (dict "root" . "hostname" "cps") }}'
GLOBAL_CPS_SERVER_PROTOCOL = "http"
GLOBAL_CPS_SERVER_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "cps" "port" 8080) }}'
GLOBAL_CPS_HEALTH_PORT = '{{include "robot.ingress.port" (dict "root" . "hostname" "cps" "port" 8081) }}'
