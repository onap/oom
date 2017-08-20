GLOBAL_SERVICE_FOLDER_MAPPING = {"vFW" : ['base_vfw'], \
                                 "vLB" : ['base_vlb'], \
                                 "vVG" : ['base_vvg'], \
                                 }
                                 
GLOBAL_SERVICE_TEMPLATE_MAPPING = {"vFW" : [{"isBase" : "true", "template" : "vfw_preload.template", "name_pattern": "base_vfw"}], \
                                 "vLB" : [{"isBase" : "true", "template" : "vlb_preload.template", "name_pattern": "base_vlb"},
                                          {"isBase" : "false", "template" : "dnsscaling_preload.template", "name_pattern": "dnsscaling", "prefix" : "vDNS_"}],
                                 "vVG" : [{"isBase" : "true", "template" : "vvg_preload.template", "name_pattern": "base_vvg"}], \
                                 }


##
## The following identifies the stack parameter names for the onap_oam network IPS
## In stantiated by the stack. During stack teardown, we need to ensure that 
## These ports are deleted due to latency in rackspace to free these ports.
## This is just a workaround to enable respinning a VM as soon as possible
GLOBAL_SERVICE_ECOMP_IP_MAPPING = {"vFW" : ['vpg_private_ip_1', 'vfw_private_ip_2','vsn_private_ip_1'], \
                                 "vLB" : ['vlb_private_ip_1', 'vdns_private_ip_1'],
                                 "vVG" : [], \
                                 }


## 
## Used by the Heatbridge Validate Query to A&AI to locate the vserver name
GLOBAL_VALIDATE_NAME_MAPPING = {"vFW" : 'vfw_name_0',
                                 "vLB" : 'vlb_name_0',
                                 "vVG" : '' 
                                 }
