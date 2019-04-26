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

import json
import os.path
from itertools import chain
from collections import defaultdict


GLOBAL_PRELOAD_PARAMETERS = {
    # heat template parameter values common to all heat template continaing these parameters
     "defaults" : {
         'key_name' : 'vfw_key${uuid}',
         "pub_key" : "{{ .Values.vnfPubKey }}",
         "repo_url_blob" : "https://nexus.onap.org/content/repositories/raw",
         "repo_url_artifacts" : "{{ .Values.demoArtifactsRepoUrl }}",
         "demo_artifacts_version" : "${GLOBAL_INJECTED_ARTIFACTS_VERSION}",
         "onap_private_net_id" : "${GLOBAL_INJECTED_NETWORK}",
         "onap_private_subnet_id" : "{{ .Values.openStackPrivateSubnetId }}",
         "onap_private_net_cidr" : "{{ .Values.openStackPrivateNetCidr }}",
         "sec_group" : "{{ .Values.openStackSecurityGroup }}",
         "dcae_collector_ip" : "{{ .Values.dcaeCollectorIp }}",
         "dcae_collector_port" : "30235",
         "public_net_id" : "${GLOBAL_INJECTED_PUBLIC_NET_ID}",
         "cloud_env" : "${GLOBAL_INJECTED_CLOUD_ENV}",
         "install_script_version" : "${GLOBAL_INJECTED_SCRIPT_VERSION}",
     },
    # ##
    # heat template parameter values for heat template instances created during Vnf-Orchestration test cases
    # ##
    "Vnf-Orchestration" : {
        "vfw_preload.template": {
            "unprotected_private_net_id" : "vofwl01_unprotected${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "protected_private_net_id" : "vofwl01_protected${hostid}",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_int_unprotected_private_ip_0" : "192.168.10.100",
            "vfw_int_protected_private_ip_0" : "192.168.20.100",
            "vfw_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.1",
            "vfw_int_protected_private_floating_ip" : "192.168.10.200",
            "vpg_int_unprotected_private_ip_0" : "192.168.10.200",
            "vpg_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.2",
            "vsn_int_protected_private_ip_0" : "192.168.20.250",
            "vsn_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.3",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vfw_name_0':'vofwl01fwl${hostid}',
            'vpg_name_0':'vofwl01pgn${hostid}',
            "vfw_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vfw_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vpg_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vpg_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vsn_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vsn_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            'vsn_name_0':'vofwl01snk${hostid}'
        },
        "vfwsnk_preload.template": {
            "int_unprotected_private_net_id" : "vofwlsnk_unprotected${hostid}",
            "int_unprotected_private_subnet_id" : "vofwlsnk_unprotected_sub${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "int_protected_private_net_id" : "vofwlsnk_protected${hostid}",
            "int_protected_private_subnet_id" : "vofwlsnk_protected_sub${hostid}",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_int_unprotected_private_ip_0" : "192.168.10.100",
            # this should be the same value as vpg_private_ip_0
            "vfw_int_protected_private_floating_ip" : "192.168.10.200",
            "vfw_int_protected_private_ip_0" : "192.168.20.100",
            "vfw_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.101",
            "vsn_int_protected_private_ip_0" : "192.168.20.250",
            "vsn_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.102",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vfw_name_0':'vofwl01fwl${hostid}',
            'vsn_name_0':'vofwl01snk${hostid}',
            "vfw_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vfw_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vsn_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vsn_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
        },
        "vpkg_preload.template": {
            # vFWSNK_ prepended to vpkg since the default behoir for vFWSNK tempalte is to concatenate vnf_name and network_name
            "unprotected_private_net_id" : "vFWSNK_vofwlsnk_unprotected${hostid}",
            "unprotected_private_subnet_id" : "vFWSNK_vofwlsnk_unprotected_sub${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_private_ip_0" : "192.168.10.100",
            "vpg_unprotected_private_ip_0" : "192.168.10.200",
            "vpg_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.103",
            "vsn_private_ip_0" : "192.168.20.250",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vpg_name_0':'vofwl01pgn${hostid}',
            "vpg_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vpg_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
        },
        #  vFWDT preload data
        "vfwdt_vpkg_preload.template": {
            "unprotected_private_net_id" : "vofwlsnk_unprotected${hostid}",
            "unprotected_private_subnet_id" : "vofwlsnk_unprotected_sub${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_private_ip_0" : "192.168.10.100",
            "vpg_private_ip_0" : "192.168.10.200",
            "vpg_private_ip_1" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.103",
            "vsn_private_ip_0" : "192.168.20.250",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vpg_name_0':'vofwl01pgn${hostid}',
            "vfw_name_0": "vofwl01vfw${hostid}",
            "vsn_name_0": "vofwl01snk${hostid}",
            "image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "protected_private_net_id" : "vofwlsnk01_protected${hostid}",
            "protected_private_subnet_id" : "vofwlsnk01_protected_sub${hostid}",
            "ext_private_net_id": "onap_oam_ext",
            "ext_private_subnet_id": "onap_oam_ext_sub",
            "ext_private_net_cidr": "10.100.0.0/16",
            "vfw_private_ip_1": "192.168.20.100",
            "vfw_private_ip_2": "10.0.110.1",
            "vfw_private_ip_3": "10.100.100.1",
            "vsn_private_ip_1": "10.0.110.3",
            "vsn_private_ip_0": "192.168.20.250",
            "vsn_private_ip_2": "10.100.100.3",
        },
        "vfwdt_vfwsnk0_preload.template": {
            "unprotected_private_net_id" : "vofwlsnk_unprotected${hostid}",
            "unprotected_private_subnet_id" : "vofwlsnk_unprotected_sub${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_private_ip_0" : "192.168.10.100",
            "vpg_private_ip_0" : "192.168.10.200",
            "vpg_private_ip_1" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.103",
            "vsn_private_ip_0" : "192.168.20.250",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vpg_name_0':'vofwl01pgn${hostid}',
            "vsn_name_0": "vofwl01snk${hostid}",
            "vfw_name_0": "vofwl01vfw${hostid}",
            "image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "protected_private_net_id" : "vofwlsnk01_protected${hostid}",
            "protected_private_subnet_id" : "vofwlsnk01_protected_sub${hostid}",
            "ext_private_net_id": "onap_oam_ext",
            "ext_private_subnet_id": "onap_oam_ext_sub",
            "ext_private_net_cidr": "10.100.0.0/16",
            "vfw_private_ip_1": "192.168.20.100",
            "vfw_private_ip_2": "10.0.110.1",
            "vfw_private_ip_3": "10.100.100.1",
            "vsn_private_ip_1": "10.0.110.3",
            "vsn_private_ip_0": "192.168.20.250",
            "vpg_private_ip_2": "10.100.100.2",
            "vsn_private_ip_1": "10.0.110.3",
            "vsn_private_ip_0": "192.168.20.250",
            "vsn_private_ip_2": "10.100.100.3"
        },
        "vfwdt_vfwsnk1_preload.template": {
            "unprotected_private_net_id" : "vofwlsnk_unprotected${hostid}",
            "unprotected_private_subnet_id" : "vofwlsnk_unprotected_sub${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_private_ip_0" : "192.168.10.110",
            "vpg_private_ip_0" : "192.168.10.200",
            "vpg_private_ip_1" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.103",
            "vsn_private_ip_0" : "192.168.20.250",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vpg_name_0':'vofwl01pgn${hostid}',
            "vsn_name_0": "vofwl01snk${hostid}",
            "vfw_name_0": "vofwl01vfw${hostid}",
            "image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "protected_private_net_id" : "vofwlsnk01_protected${hostid}",
            "protected_private_subnet_id" : "vofwlsnk01_protected_sub${hostid}",
            "ext_private_net_id": "onap_oam_ext",
            "ext_private_subnet_id": "onap_oam_ext_sub",
            "ext_private_net_cidr": "10.100.0.0/16",
            "vfw_private_ip_1": "192.168.20.110",
            "vfw_private_ip_2": "10.0.110.4",
            "vfw_private_ip_3": "10.100.100.4",
            "vpg_private_ip_0": "192.168.10.200",
            "vpg_private_ip_1": "10.0.110.2",
            "vpg_private_ip_2": "10.100.100.2",
            "vsn_private_ip_0": "192.168.20.240",
            "vsn_private_ip_1": "10.0.110.5",
            "vsn_private_ip_2": "10.100.100.5"
        },
        "vlb_preload.template" : {
            "vlb_image_name" : "${GLOBAL_INJECTED_UBUNTU_1604_IMAGE}",
            "vlb_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vdns_image_name" : "${GLOBAL_INJECTED_UBUNTU_1604_IMAGE}",
            "vdns_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vpg_image_name" : "${GLOBAL_INJECTED_UBUNTU_1604_IMAGE}",
            "vpg_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            'vlb_name_0':'vovlblb${hostid}',
            'vdns_name_0':'vovlbdns${hostid}',
            "vpg_name_0" : "vovlbpgn${hostid}",
            "vlb_private_net_id" : "volb01_private${hostid}",
            "vlb_private_net_cidr" : "192.168.30.0/24",
            "pktgen_private_net_id" : "volb01_pktgen${hostid}",
            "pktgen_private_net_cidr" : "192.168.9.0/24",
            "vlb_int_private_ip_0" : "192.168.30.100",
            "vlb_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.4",
            "vlb_int_pktgen_private_ip_0" : "192.168.9.111",
            "vdns_int_private_ip_0" : "192.168.30.110",
            "vdns_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.5",
            "vpg_int_pktgen_private_ip_0" : "192.168.9.110",
            "vpg_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.7",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            "pg_int" : "192.168.9.109",
            "vip" : "192.168.9.112",
            "gre_ipaddr" : "192.168.30.112",
            "vnf_id" : "vLoadBalancer_${hostid}",
            "vf_module_id" : "vLoadBalancer"

        },
        "dnsscaling_preload.template" : {
            "int_private_net_id" : "vLBMS_volb01_private${hostid}",
            "int_private_subnet_id" : "vLBMS_volb01_private${hostid}_subnet",
            "vlb_int_private_ip_0" : "192.168.30.100",
            "vlb_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.4",
            "vlb_int_pktgen_private_ip_0" : "192.168.9.111",
            "vdns_int_private_ip_0" : "192.168.30.222",
            "vdns_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.6",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vdns_name_0':'vovlbscaling${hostid}',
            "vlb_private_net_cidr" : "192.168.30.0/24"
        },
        "vims_preload.template" : {
            "bono_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "sprout_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "homer_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "homestead_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "ralf_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "ellis_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "dns_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "bono_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "sprout_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "homer_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "homestead_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "ralf_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "ellis_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "dns_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "repo_url" : "http://repo.cw-ngv.com/stable",
            "zone" : "me.cw-ngv.com",
            "dn_range_start" : "2425550000",
            "dn_range_length" : "10000",
            "dnssec_key" : "9FPdYTWhk5+LbhrqtTPQKw=="

        },
        "vvg_preload.template" : {
        }
    },
# heat template parameter values for heat template instances created during Closed-Loop test cases
    "Closed-Loop" : {
        "vfw_preload.template": {
            "unprotected_private_net_id" : "clfwl01_unprotected${hostid}",
            "unprotected_private_net_cidr" : "192.168.110.0/24",
            "protected_private_net_id" : "clfwl01_protected${hostid}",
            "protected_private_net_cidr" : "192.168.120.0/24",
            "vfw_int_unprotected_private_ip_0" : "192.168.110.100",
            "vfw_int_protected_private_ip_0" : "192.168.120.100",
            "vfw_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.11",
            "vfw_int_protected_private_floating_ip" : "192.168.110.200",
            "vpg_int_unprotected_private_ip_0" : "192.168.110.200",
            "vpg_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.12",
            "vsn_int_protected_private_ip_0" : "192.168.120.250",
            "vsn_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.13",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vfw_name_0':'clfwl01fwl${hostid}',
            'vpg_name_0':'clfwl01pgn${hostid}',
            "vfw_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vfw_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vpg_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vpg_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vsn_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vsn_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            'vsn_name_0':'clfwl01snk${hostid}'
        },
        "vfwsnk_preload.template": {
            "int_unprotected_private_net_id" : "clfwlsnk_unprotected${hostid}",
            "int_unprotected_private_subnet_id" : "clfwlsnk_unprotected_sub${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "int_protected_private_net_id" : "clfwlsnk_protected${hostid}",
            "int_protected_private_subnet_id" : "clfwlsnk_protected_sub${hostid}",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_int_unprotected_private_ip_0" : "192.168.10.100",
            # this should be the same value as vpg_private_ip_0
            "vfw_int_protected_private_floating_ip" : "192.168.10.200",
            "vfw_int_protected_private_ip_0" : "192.168.20.100",
            "vfw_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.111",
            "vsn_int_protected_private_ip_0" : "192.168.20.250",
            "vsn_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.112",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vfw_name_0':'clfwl01fwl${hostid}',
            'vsn_name_0':'clfwl01snk${hostid}',
            "vfw_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vfw_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vsn_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vsn_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
        },
        "vpkg_preload.template": {
            "unprotected_private_net_id" : "vFWSNK_clfwlsnk_unprotected${hostid}",
            "unprotected_private_subnet_id" : "vFWSNK_clfwlsnk_unprotected_sub${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_private_ip_0" : "192.168.10.100",
            "vpg_unprotected_private_ip_0" : "192.168.10.200",
            "vpg_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.113",
            "vsn_private_ip_0" : "192.168.20.250",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vpg_name_0':'clfwl01pgn${hostid}',
            "vpg_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vpg_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
        },
        # vLBMS
        "vlb_preload.template" : {
            "vlb_image_name" : "${GLOBAL_INJECTED_UBUNTU_1604_IMAGE}",
            "vlb_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vdns_image_name" : "${GLOBAL_INJECTED_UBUNTU_1604_IMAGE}",
            "vdns_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vpg_image_name" : "${GLOBAL_INJECTED_UBUNTU_1604_IMAGE}",
            "vpg_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            'vlb_name_0':'clvlblb${hostid}',
            'vdns_name_0':'clvlbdns${hostid}',
            "vpg_name_0" : "clvlbpgn${hostid}",
            "vlb_private_net_id" : "cllb01_private${hostid}",
            "vlb_private_net_cidr" : "192.168.30.0/24",
            "pktgen_private_net_id" : "cllb01_pktgen${hostid}",
            "pktgen_private_net_cidr" : "192.168.9.0/24",
            "vlb_int_private_ip_0" : "192.168.30.100",
            "vlb_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.14",
            "vlb_int_pktgen_private_ip_0" : "192.168.9.111",
            "vdns_int_private_ip_0" : "192.168.30.110",
            "vdns_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.15",
            "vpg_int_pktgen_private_ip_0" : "192.168.9.110",
            "vpg_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.17",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            "pg_int" : "192.168.9.109",
            "vip" : "192.168.9.112",
            "gre_ipaddr" : "192.168.30.112",
            "vnf_id" : "vLoadBalancer_${hostid}",
            "vf_module_id" : "vLoadBalancer"
        },
        "dnsscaling_preload.template" : {
            "int_private_net_id" : "vLBMS_cllb01_private${hostid}",
            "int_private_subnet_id" : "vLBMS_cllb01_private${hostid}_subnet",
            "vlb_int_private_ip_0" : "192.168.30.100",
            "vlb_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.14",
            "vlb_int_pktgen_private_ip_0" : "192.168.9.111",
            "vdns_int_private_ip_0" : "192.168.30.222",
            "vdns_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.16",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vdns_name_0':'clvlbscaling${hostid}',
            "vlb_private_net_cidr" : "192.168.10.0/24"
        },
        "vims_preload.template" : {
            "bono_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "sprout_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "homer_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "homestead_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "ralf_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "ellis_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "dns_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "bono_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "sprout_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "homer_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "homestead_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "ralf_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "ellis_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "dns_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "repo_url" : "http://repo.cw-ngv.com/stable",
            "zone" : "me.cw-ngv.com",
            "dn_range_start" : "2425550000",
            "dn_range_length" : "10000",
            "dnssec_key" : "9FPdYTWhk5+LbhrqtTPQKw=="
        },
        "vvg_preload.template" : {
        }
    },
 # heat template parameter values for heat template instances created for hands on demo test case
   "Demo" : {
        "vfw_preload.template": {
            "unprotected_private_net_id" : "demofwl_unprotected",
            "unprotected_private_net_cidr" : "192.168.110.0/24",
            "protected_private_net_id" : "demofwl_protected",
            "protected_private_net_cidr" : "192.168.120.0/24",
            "vfw_int_unprotected_private_ip_0" : "192.168.110.100",
            "vfw_int_protected_private_ip_0" : "192.168.120.100",
            "vfw_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.11",
            "vpg_int_unprotected_private_ip_0" : "192.168.110.200",
            "vfw_int_protected_private_floating_ip" : "192.168.110.200",
            "vpg_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.12",
            "vsn_int_protected_private_ip_0" : "192.168.120.250",
            "vsn_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.13",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vfw_name_0':'demofwl01fwl',
            'vpg_name_0':'demofwl01pgn',
            "vfw_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vfw_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vpg_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vpg_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vsn_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vsn_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            'vsn_name_0':'demofwl01snk'
        },
        "vfwsnk_preload.template": {
            "int_unprotected_private_net_id" : "demofwlsnk_unprotected${hostid}",
            "int_unprotected_private_subnet_id" : "demofwlsnk_unprotected_sub${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "int_protected_private_net_id" : "demofwlsnk_protected${hostid}",
            "int_protected_private_subnet_id" : "vofwlsnk_protected_sub${hostid}",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_int_unprotected_private_ip_0" : "192.168.10.100",
            # this should be the same value as vpg_private_ip_0
            "vfw_int_protected_private_floating_ip" : "192.168.10.200",
            "vfw_int_protected_private_ip_0" : "192.168.20.100",
            "vfw_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.121",
            "vsn_int_protected_private_ip_0" : "192.168.20.250",
            "vsn_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.122",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vfw_name_0':'${generic_vnf_name}',
            'vsn_name_0':'demofwl01snk${hostid}',
            "vfw_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vfw_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vsn_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vsn_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
        },
        "vpkg_preload.template": {
            "unprotected_private_net_id" : "vFWSNK_demofwlsnk_unprotected${hostid}",
            "unprotected_private_subnet_id" : "vFWSNK_demofwlsnk_unprotected_sub${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_private_ip_0" : "192.168.10.100",
            "vpg_unprotected_private_ip_0" : "192.168.10.200",
            "vpg_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.123",
            "vsn_private_ip_0" : "192.168.20.250",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vpg_name_0':'demofwl01pgn${hostid}',
            "vpg_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "vpg_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}"
        },
        # vLBMS
        "vlb_preload.template" : {
            "vlb_image_name" : "${GLOBAL_INJECTED_UBUNTU_1604_IMAGE}",
            "vlb_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vdns_image_name" : "${GLOBAL_INJECTED_UBUNTU_1604_IMAGE}",
            "vdns_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "vpg_image_name" : "${GLOBAL_INJECTED_UBUNTU_1604_IMAGE}",
            "vpg_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            'vlb_name_0':'demovlblb${hostid}',
            'vdns_name_0':'demovlbdns${hostid}',
            "vpg_name_0" : "clvlbpgn${hostid}",
            "vlb_private_net_id" : "demolb_private${hostid}",
            "vlb_private_net_cidr" : "192.168.30.0/24",
            "pktgen_private_net_id" : "demolb_pktgen${hostid}",
            "pktgen_private_net_cidr" : "192.168.9.0/24",
            "vlb_int_private_ip_0" : "192.168.30.100",
            "vlb_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.24",
            "vlb_int_pktgen_private_ip_0" : "192.168.9.111",
            "vdns_int_private_ip_0" : "192.168.30.110",
            "vdns_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.25",
            "vpg_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.27",
            "vpg_int_pktgen_private_ip_0" : "192.168.9.110",
            "pg_int" : "192.168.9.109",
            "vip" : "192.168.9.112",
            "gre_ipaddr" : "192.168.30.112",
            "vnf_id" : "vLoadBalancer_${hostid}",
            "vf_module_id" : "vLoadBalancer",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}"
        },
        "dnsscaling_preload.template" : {
            "int_private_net_id" : "vLBMS_demolb_private${hostid}",
            "int_private_subnet_id" : "vLBMS_demolb_private${hostid}_subnet",
            "vlb_int_private_ip_0" : "192.168.30.100",
            "vlb_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.24",
            "vlb_int_pktgen_private_ip_0" : "192.168.9.111",
            "vdns_int_private_ip_0" : "192.168.30.222",
            "vdns_onap_private_ip_0" : "{{.Values.openStackOamNetworkCidrPrefix}}.${ecompnet}.26",
            "sec_group" : "{{ .Values.openStackSecurityGroup }}",
            'vdns_name_0':'demovlbscaling${hostid}',
            "vlb_private_net_cidr" : "192.168.30.0/24"
        },
        "vims_preload.template" : {
            "bono_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "sprout_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "homer_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "homestead_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "ralf_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "ellis_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "dns_image_name" : "${GLOBAL_INJECTED_UBUNTU_1404_IMAGE}",
            "bono_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "sprout_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "homer_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "homestead_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "ralf_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "ellis_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "dns_flavor_name" : "${GLOBAL_INJECTED_VM_FLAVOR}",
            "repo_url" : "http://repo.cw-ngv.com/stable",
            "zone" : "me.cw-ngv.com",
            "dn_range_start" : "2425550000",
            "dn_range_length" : "10000",
            "dnssec_key" : "9FPdYTWhk5+LbhrqtTPQKw=="
        },
        "vvg_preload.template" : {
        }
    }
}


# Create dictionaries for new MAPPING data to join to original MAPPING data
GLOBAL_PRELOAD_PARAMETERS2 = {}


folder=os.path.join('/var/opt/ONAP/demo/preload_data')
subfolders = [d for d in os.listdir(folder) if os.path.isdir(os.path.join(folder, d))]

for service in subfolders:
    filepath=os.path.join('/var/opt/ONAP/demo/preload_data', service, 'preload_data.json')
    with open(filepath, 'r') as f:
        preload_data = json.load(f)
        GLOBAL_PRELOAD_PARAMETERS2['Demo']=preload_data


# Merge dictionaries
#    preload_data.json is for Demo key in GLOBAL_PRELOAD_PARAMETERS


GLOBAL_PRELOAD_PARAMETERS3 = {'Demo':{}}

for k, v in chain(GLOBAL_PRELOAD_PARAMETERS['Demo'].items(), GLOBAL_PRELOAD_PARAMETERS2['Demo'].items()):
    GLOBAL_PRELOAD_PARAMETERS3['Demo'][k] =  v
#    print(k, v)

GLOBAL_PRELOAD_PARAMETERS =  dict(GLOBAL_PRELOAD_PARAMETERS.items() + GLOBAL_PRELOAD_PARAMETERS3.items())

#print GLOBAL_PRELOAD_PARAMETERS

