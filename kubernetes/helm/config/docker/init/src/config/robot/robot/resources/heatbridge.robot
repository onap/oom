*** Settings ***
Library     HeatBridge
Library     Collections
Library     StringTemplater
Library     OperatingSystem
Library     UUID

Resource    openstack/keystone_interface.robot
Resource    openstack/heat_interface.robot
Resource    openstack/nova_interface.robot
Resource    openstack/neutron_interface.robot
Resource    aai/aai_interface.robot

*** Variables ***
${MULTIPART_PATH}  /bulkadd
${NAMED_QUERY_PATH}  /aai/search/named-query
${NAMED_QUERY_TEMPLATE}    robot/assets/templates/aai/named_query.template

${BASE_URI}   /cloud-infrastructure/cloud-regions/cloud-region/\${cloud}/\${region}
${IMAGE_URI}   ${BASE_URI}/images/image/\${image_id}
${FLAVOR_URI}   ${BASE_URI}/flavors/flavor/\${flavor}
${VSERVER_URI}   ${BASE_URI}/tenants/tenant/\${tenant}/vservers/vserver/\${vserver_id}
${L_INTERFACE_URI}   ${VSERVER_URI}/l-interfaces/l-interface/\${linterface_id}

#******************** Test Case Variables ****************
${REVERSE_HEATBRIDGE}


*** Keywords ***
Execute Heatbridge
    [Documentation]   Run the Heatbridge against the stack to generate the bulkadd message
    ...    Execute the build add
    ...    Validate the add results by running the named query
    [Arguments]    ${stack_name}    ${service_instance_id}    ${service}
    Return From Keyword If    '${service}' == 'vVG'
    Run Openstack Auth Request    auth
    ${stack_info}=    Wait for Stack to Be Deployed    auth    ${stack_name}
    ${stack_id}=    Get From Dictionary    ${stack_info}    id
    ${tenant_id}=   Get From Dictionary    ${stack_info}    OS::project_id
    ${vnf_id}=    Get From Dictionary    ${stack_info}    vnf_id
    ${openstack_identity_url}=    Catenate    ${GLOBAL_OPENSTACK_KEYSTONE_SERVER}/v2.0
    ${region}=   Get Openstack Region
    ${user}   ${pass}=   Get Openstack Credentials
    Init Bridge    ${openstack_identity_url}    ${user}    ${pass}    ${tenant_id}    ${region}   ${GLOBAL_AAI_CLOUD_OWNER}
    ${request}=    Bridge Data    ${stack_id}
    Log    ${request}
    ${resp}=    Run A&AI Put Request    ${VERSIONED_INDEX_PATH}${MULTIPART_PATH}    ${request}
    ${status_string}=    Convert To String    ${resp.status_code}
    Should Match Regexp    ${status_string} 	^(201|200)$
    ${reverse_heatbridge}=   Generate Reverse Heatbridge From Stack Info   ${stack_info}
    Set Test Variable   ${REVERSE_HEATBRIDGE}   ${reverse_heatbridge}
    Run Validation Query    ${stack_info}    ${service}


Run Validation Query
    [Documentation]    Run A&AI query to validate the bulk add
    [Arguments]    ${stack_info}    ${service}
    Return from Keyword If    '${service}' == ''
    ${server_name_parameter}=    Get From Dictionary    ${GLOBAL_VALIDATE_NAME_MAPPING}    ${service}
    ${vserver_name}=    Get From Dictionary    ${stack_info}   ${server_name_parameter}
    Run Vserver Query   ${vserver_name}

Run Vserver Query
    [Documentation]    Run A&AI query to validate the bulk add
    [Arguments]    ${vserver_name}
    ${dict}=    Create Dictionary    vserver_name=${vserver_name}
    ${request}=    OperatingSystem.Get File    ${NAMED_QUERY_TEMPLATE}
    ${request}=    Template String    ${request}    ${dict}
    ${resp}=    Run A&AI Post Request    ${NAMED_QUERY_PATH}    ${request}
    Should Be Equal As Strings    ${resp.status_code}    200


Execute Reverse Heatbridge
    [Documentation]   VID has already torn down the stack, reverse HB
    Return From Keyword If   len(${REVERSE_HEATBRIDGE}) == 0
    :for   ${uri}    in   @{REVERSE_HEATBRIDGE}
    \    Run Keyword And Ignore Error    Delete A&AI Entity   ${uri}

Generate Reverse Heatbridge From Stack Name
    [Arguments]   ${stack_name}
    Run Openstack Auth Request    auth
    ${stack_info}=    Wait for Stack to Be Deployed    auth    ${stack_name}   timeout=10s
    ${reverse_heatbridge}=    Generate Reverse Heatbridge From Stack Info   ${stack_info}
    [Return]    ${reverse_heatbridge}

Generate Reverse Heatbridge From Stack Info
    [Arguments]   ${stack_info}
    ${reverse_heatbridge}=    Create List
    ${stack_name}=    Get From Dictionary    ${stack_info}    name
    ${stack_id}=    Get From Dictionary    ${stack_info}    id
    ${tenant_id}=   Get From Dictionary    ${stack_info}    OS::project_id
    ${region}=   Get Openstack Region
    ${keys}=    Create Dictionary   region=${region}   cloud=${GLOBAL_AAI_CLOUD_OWNER}   tenant=${tenant_id}
    ${stack_resources}=    Get Stack Resources    auth    ${stack_name}    ${stack_id}
    ${resource_list}=    Get From Dictionary    ${stack_resources}    resources
    :FOR   ${resource}    in    @{resource_list}
    \    Log     ${resource}
    \    Run Keyword If    '${resource['resource_type']}' == 'OS::Neutron::Port'    Generate Linterface Uri    auth    ${resource['physical_resource_id']}   ${reverse_heatbridge}   ${keys}
    :FOR   ${resource}    in    @{resource_list}
    \    Log     ${resource}
    \    Run Keyword If    '${resource['resource_type']}' == 'OS::Nova::Server'    Generate Vserver Uri    auth    ${resource['physical_resource_id']}  ${reverse_heatbridge}   ${keys}   ${resource_list}
    [Return]    ${reverse_heatbridge}

Generate Vserver Uri
    [Documentation]   Run teardown against the server to generate a message that removes it
    [Arguments]    ${alias}    ${port_id}   ${reverse_heatbridge}   ${keys}   ${resource_list}
    ${resp}=    Get Openstack Server By Id   ${alias}	  ${port_id}
    Return From Keyword If   '${resp.status_code}' != '200'
    ${info}=   Set Variable   ${resp.json()}
    Set To Dictionary   ${keys}   vserver_id=${info['server']['id']}
    Set To Dictionary   ${keys}   flavor=${info['server']['flavor']['id']}
    Set To Dictionary   ${keys}   image_id=${info['server']['image']['id']}
    ${uri}=   Template String    ${VSERVER_URI}    ${keys}
    Append To List  ${reverse_heatbridge}   ${uri}
    ${uri}=   Template String    ${FLAVOR_URI}    ${keys}
    Append To List  ${reverse_heatbridge}   ${uri}
    ${uri}=   Template String    ${IMAGE_URI}    ${keys}
    Append To List  ${reverse_heatbridge}   ${uri}

Generate Linterface Uri
    [Documentation]   Run teardown against the server to generate a message that removes it
    [Arguments]    ${alias}    ${server_id}   ${reverse_heatbridge}   ${keys}
    ${resp}=    Get Openstack Port By Id   ${alias}	${server_id}
    Return From Keyword If   '${resp.status_code}' != '200'
    ${info}=   Set Variable   ${resp.json()}
    Set To Dictionary   ${keys}   vserver_id=${info['port']['device_id']}
    Set To Dictionary   ${keys}   linterface_id=${info['port']['name']}
    ${uri}=   Template String    ${L_INTERFACE_URI}    ${keys}
    Append To List  ${reverse_heatbridge}   ${uri}

