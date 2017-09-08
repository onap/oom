GLOBAL_PRELOAD_PARAMETERS = {
# heat template parameter values common to all heat template continaing these parameters
     "defaults" : {
        'key_name' : 'vfw_key${uuid}',
        "pub_key" : "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAqqnA9BAiMLtjOPSYBfhzLu4CiBolWoskDg4KVwhTJVTTeB6CqrQNcadlGXxOHhCYuNCKkUmIVF4WTOisVOJ75Z1c4OMoZLL85xVPKSIeH63kgVugwgPYQu55NbbWX+rsbUha3LnElDhNviMM3iTPbD5nnhKixNERAJMTLKXvZZZGqxW94bREknYPQTT2qrk3YRqwldncopp6Nkgv3AnSJz2gc9tjxnWF0poTQnQm/3D6hiJICrzKfAV0EaPN0KdtYjPhKrYoy6Qb/tKOVaaqsvwfKBJGrT9LfcA7D7M/yj292RT1XN63hI84WC383LsaPJ6eWdDTE6zUP1eGTWCoOw== rsa-key-20161026",
        "repo_url_blob" : "https://nexus.onap.org/content/repositories/raw",
        "repo_url_artifacts" : "https://nexus.onap.org/content/groups/staging",
        "demo_artifacts_version" : "DEMO_ARTIFACTS_VERSION_HERE",
         "ecomp_private_net_id" : "OPENSTACK_NETWORK_ID_WITH_ONAP_ROUTE_HERE",
        "ecomp_private_subnet_id" : "OPENSTACK_SUBNET_ID_WITH_ONAP_ROUTE_HERE",
        "ecomp_private_net_cidr" : "NETWORK_CIDR_WITH_ONAP_ROUTE_HERE",

        "dcae_collector_ip" : "192.168.176.225",
        "dcae_collector_port" : "30241",

    },
# heat template parameter values for heat template instances created during Vnf-Orchestration test cases
    "Vnf-Orchestration" : {
        "vfw_preload.template": {
            "unprotected_private_net_id" : "vofwl01_unprotected${hostid}",
            "unprotected_private_net_cidr" : "192.168.10.0/24",
            "protected_private_net_id" : "vofwl01_protected${hostid}",
            "protected_private_net_cidr" : "192.168.20.0/24",
            "vfw_private_ip_0" : "192.168.10.100",
            "vfw_private_ip_1" : "192.168.20.100",
            "vfw_private_ip_2" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.3",
            "vpg_private_ip_0" : "192.168.10.200",
            "vpg_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.4",
            "vsn_private_ip_0" : "192.168.20.250",
            "vsn_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.5",
            'vfw_name_0':'vofwl01fwl${hostid}',
            'vpg_name_0':'vofwl01pgn${hostid}',
            'vsn_name_0':'vofwl01snk${hostid}',
        },
        "vlb_preload.template" : {
            "vlb_private_net_id" : "volb01_private${hostid}",
            "vlb_private_net_cidr" : "192.168.30.0/24",
            "vlb_private_ip_0" : "192.168.30.100",
            "vlb_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.6",
            "vdns_private_ip_0" : "192.168.30.110",
            "vdns_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.7",
            'vlb_name_0':'vovlblb${hostid}',
            'vdns_name_0':'vovlbdns${hostid}',
        },
        "dnsscaling_preload.template" : {
            "vlb_private_net_id" : "volb01_private${hostid}",
            "vlb_private_ip_0" : "192.168.30.100",
            "vlb_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.8",
            "vdns_private_ip_0" : "192.168.30.222",
            "vdns_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.9",
            'scaling_vdns_name_0':'vovlbscaling${hostid}',
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
            "vfw_private_ip_0" : "192.168.110.100",
            "vfw_private_ip_1" : "192.168.120.100",
            "vfw_private_ip_2" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.10",
            "vpg_private_ip_0" : "192.168.110.200",
            "vpg_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.11",
            "vsn_private_ip_0" : "192.168.120.250",
            "vsn_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.12",
            'vfw_name_0':'clfwl01fwl${hostid}',
            'vpg_name_0':'clfwl01pgn${hostid}',
            'vsn_name_0':'clfwl01snk${hostid}',
        },
        "vlb_preload.template" : {
            "vlb_private_net_id" : "cllb01_private${hostid}",
            "vlb_private_net_cidr" : "192.168.130.0/24",
            "vlb_private_ip_0" : "192.168.130.100",
            "vlb_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.13",
            "vdns_private_ip_0" : "192.168.130.110",
            "vdns_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.14",
            'vlb_name_0':'clvlblb${hostid}',
            'vdns_name_0':'clvlbdns${hostid}',
        },
        "dnsscaling_preload.template" : {
            "vlb_private_net_id" : "cllb01_private${hostid}",
            "vlb_private_ip_0" : "192.168.130.100",
            "vlb_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.15",
            "vdns_private_ip_0" : "192.168.130.222",
            "vdns_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.16",
            'scaling_vdns_name_0':'clvlbscaling${hostid}',
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
            "vfw_private_ip_0" : "192.168.110.100",
            "vfw_private_ip_1" : "192.168.120.100",
            "vfw_private_ip_2" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.17",
            "vpg_private_ip_0" : "192.168.110.200",
            "vpg_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.18",
            "vsn_private_ip_0" : "192.168.120.250",
            "vsn_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.19",
            'vfw_name_0':'demofwl01fwl',
            'vpg_name_0':'demofwl01pgn',
            'vsn_name_0':'demofwl01snk',
        },
        "vlb_preload.template" : {
            "vlb_private_net_id" : "demolb_private",
            "vlb_private_net_cidr" : "192.168.130.0/24",
            "vlb_private_ip_0" : "192.168.130.100",
            "vlb_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.20",
            "vdns_private_ip_0" : "192.168.130.110",
            "vdns_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.21",
            'vlb_name_0':'demovlblb',
            'vdns_name_0':'demovlbdns',
        },
        "dnsscaling_preload.template" : {
            "vlb_private_net_id" : "demolb_private",
            "vlb_private_ip_0" : "192.168.130.100",
            "vlb_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.22",
            "vdns_private_ip_0" : "192.168.130.222",
            "vdns_private_ip_1" : "OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE.23",
            'scaling_vdns_name_0':'demovlbscaling',
        },
        "vvg_preload.template" : {
        }
    }
}

