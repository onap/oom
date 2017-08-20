#!/bin/sh
#
# ============LICENSE_START==========================================
# ===================================================================
# Copyright © 2017 AT&T Intellectual Property. All rights reserved.
# ===================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END============================================
#
# ECOMP and OpenECOMP are trademarks
# and service marks of AT&T Intellectual Property.
#
#
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "UPDATE heat_environment SET ENVIRONMENT='parameters:\n  vfw_image_name: Ubuntu_14.04.5_LTS\n  vfw_flavor_name: m1.medium\n  public_net_id: 5a88ca9c-7fbb-4232-8d8e-46b53e492de9\n  unprotected_private_net_id: zdfw1fwl01_unprotected\n  protected_private_net_id: zdfw1fwl01_protected\n  ecomp_private_net_id: onap_oam\n  unprotected_private_net_cidr: 192.168.10.0/24\n  protected_private_net_cidr: 192.168.20.0/24\n  ecomp_private_net_cidr: 192.168.9.0/24\n  vfw_private_ip_0: 192.168.10.100\n  vfw_private_ip_1: 192.168.20.100\n  vfw_private_ip_2: 192.168.9.100\n  vpg_private_ip_0: 192.168.10.200\n  vpg_private_ip_1: 192.168.9.200\n  vsn_private_ip_0: 192.168.20.250\n  vsn_private_ip_1: 192.168.9.250\n  vfw_name_0: zdfw1fwl01fwl01\n  vpg_name_0: zdfw1fwl01pgn01\n  vsn_name_0: zdfw1fwl01snk01\n  vnf_id: vFirewall_demo_app\n  vf_module_id: vFirewall\n  webserver_ip: 162.242.237.182\n  dcae_collector_ip: 192.168.9.1\n  key_name: vfw_key\n  pub_key: INSERT YOUR PUBLIC KEY HERE' where id=5;" mso_catalog
