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


*** Variables ***

*** Keywords ***
Wait For Server
    [Documentation]    Attempts to login to the passed server info and verify (??). Uses server info to get public ip and locate corresponding provate key file
    [Arguments]    ${server_ip}    ${timeout}=300s
    ${file}=    Catenate    ${GLOBAL_VM_PRIVATE_KEY}
    Wait Until Keyword Succeeds    ${timeout}    5 sec    Open Connection And Log In    ${server_ip}    root    ${file}
    ${lines}=   Grep Local File    "Accepted publickey"    /var/log/auth.log
    Log    ${lines}
    Should Not Be Empty    ${lines}

Get Server Ip
    [Arguments]    ${server_list}    ${stack_info}    ${key_name}    ${network_name}=public
    ${server_name}=   Get From Dictionary     ${stack_info}   ${key_name}
    ${server}=    Get From Dictionary    ${server_list}    ${server_name}
    Log    Entering Get Openstack Server Ip
    ${ip}=    Get Openstack Server Ip    ${server}    network_name=${network_name}
    Log    Returned Get Openstack Server Ip
    [Return]    ${ip}

Find And Reboot The Server
    [Documentation]    Code to reboot the server by teh heat server name parameter value
    [Arguments]    ${stack_info}    ${server_list}    ${server_name_parameter}
    ${server_name}=   Get From Dictionary     ${stack_info}   ${server_name_parameter}
    ${vfw_server}=    Get From Dictionary    ${server_list}    ${server_name}
    ${vfw_server_id}=    Get From Dictionary    ${vfw_server}    id
    Reboot Server    auth   ${vfw_server_id}


