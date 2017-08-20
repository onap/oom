*** Settings ***
Documentation	  Testing openstack.
Library    OperatingSystem
Library    SSHLibrary
Library    RequestsLibrary
Library    JSONUtils
Library    OpenstackLibrary
Library    HEATUtils
Library    Collections
Resource          ../../resources/openstack/keystone_interface.robot
Resource          ../../resources/openstack/nova_interface.robot
Resource          ../../resources/openstack/heat_interface.robot
Resource          ../../resources/ssh/files.robot
Resource          ../../resources/ssh/processes.robot
Resource          packet_generator_interface.robot
Resource          validate_common.robot


*** Variables ***

*** Keywords ***
Validate Dns Scaling Stack
    [Documentation]    Wait for the DNS scaling stack to be instantiated
    [Arguments]    ${STACK_NAME}
    Run Openstack Auth Request    auth
    ${stack_info}=    Wait for Stack to Be Deployed    auth    ${STACK_NAME}
    ${stack_id}=    Get From Dictionary    ${stack_info}    id
    ${server_list}=    Get Openstack Servers    auth
    Log     ${server_list}
    ${vdns_public_ip}=    Get Server Ip    ${server_list}    ${stack_info}   vdns_name_0    network_name=public
    Wait For Server    ${vdns_public_ip}
    Log    Accessed all servers
    #Wait for vDNS    ${vdns_public_ip}
    Log    All server processes up

Wait For vDNS
    [Documentation]     Wait for the DNSServer to be running on the scaling DNS.
    ...  Disabled. Potential for robot to hang due to network reconfigurations at startup.
    [Arguments]    ${ip}
    Wait for Process on Host    java DNSServer     ${ip}

