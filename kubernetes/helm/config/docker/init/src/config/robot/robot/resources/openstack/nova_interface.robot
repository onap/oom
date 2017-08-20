*** Settings ***
Documentation     The main interface for interacting with Openstack. It handles low level stuff like managing the authtoken and Openstack required fields
Library           OpenstackLibrary
Library 	      RequestsLibrary
Library 	      JSONUtils
Library	          UUID
Library    OperatingSystem
Library    Collections
Resource    ../global_properties.robot
Resource    ../json_templater.robot
Resource    openstack_common.robot

*** Variables ***
${OPENSTACK_NOVA_API_VERSION}    /v2
${OPENSTACK_NOVA_KEYPAIR_PATH}    /os-keypairs
${OPENSTACK_NOVA_KEYPAIR_ADD_BODY_FILE}    robot/assets/templates/nova_add_keypair.template
${OPENSTACK_NOVA_KEYPAIR_SSH_KEY}    robot/assets/keys/robot_ssh_public_key.txt
${OPENSTACK_NOVA_FLAVORS_PATH}    /flavors
${OPENSTACK_NOVA_SERVERS_PATH}    /servers
${OPENSTACK_NOVA_IMAGES_PATH}    /images
${OPENSTACK_NOVA_SERVERS_REBOOT_BODY}    {"reboot" : { "type" : "SOFT" }}
${OPENSTACK_NOVA_SERVER_ADD_BODY_FILE}    robot/assets/templates/nova_add_server.template


*** Keywords ***
Get Openstack Keypair
    [Documentation]    Runs an Openstack Request and returns the keypair info
    [Arguments]    ${alias}    ${keypair_name}
    ${resp}=    Internal Get Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_KEYPAIR_PATH}    /${keypair_name}
    [Return]    ${resp.json()}

Add Openstack Keypair
    [Documentation]    Runs an Openstack Request to add a keypair and returns the keypair name
    [Arguments]    ${alias}    ${name}
    ${data_template}=    OperatingSystem.Get File    ${OPENSTACK_NOVA_KEYPAIR_ADD_BODY_FILE}
    ${ssh_key}=    OperatingSystem.Get File     ${OPENSTACK_NOVA_KEYPAIR_SSH_KEY}
    ${arguments}=    Create Dictionary    name=${name}	    publickey=${ssh_key}
    ${data}=	Fill JSON Template    ${data_template}    ${arguments}
    ${resp}=    Internal Post Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_KEYPAIR_PATH}    data_path=    data=${data}
    Should Be Equal As Strings    200  ${resp.status_code}
    [Return]    ${resp.json()['keypair']['name']}

Delete Openstack Keypair
    [Documentation]    Runs an Openstack Request to delete a keypair
    [Arguments]    ${alias}    ${keypair_name}
    ${resp}=    Internal Delete Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_KEYPAIR_PATH}	  /${keypair_name}
    ${status_string}=    Convert To String    ${resp.status_code}
    Should Match Regexp    ${status_string}    ^(204|202|200)$
    [Return]    ${resp.text}


Get Openstack Servers
    [Documentation]    Returns the list of servers as a dictionary by name
    [Arguments]    ${alias}
    ${resp}=    Internal Get Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_SERVERS_PATH}    /detail
    Log    Returned from Internal Get Openstack
    ${by_name}=    Make List Into Dict    ${resp.json()['servers']}    name
    Log    got it
    [Return]    ${by_name}

Get Openstack Server By Id
    [Documentation]    Returns the openstack stacks info for the given stack name
    [Arguments]    ${alias}    ${server_id}
    ${resp}=    Internal Get Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_SERVERS_PATH}    /${server_id}
    [Return]    ${resp}

Get Openstack Flavors
    [Documentation]    Runs an Openstack Request and returns the flavor list
    [Arguments]    ${alias}
    ${resp}=    Internal Get Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_FLAVORS_PATH}
    [Return]    ${resp.json()}

Get Openstack Images
    [Documentation]    Runs an Openstack Request and returns the flavor list
    [Arguments]    ${alias}
    ${resp}=    Internal Get Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_IMAGES_PATH}
    [Return]    ${resp.json()}

Reboot Server
    [Documentation]    Requests a reboot of the passed server id
    [Arguments]    ${alias}    ${server_id}
    ${resp}=    Internal Post Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_SERVERS_PATH}    /${server_id}/action    ${OPENSTACK_NOVA_SERVERS_REBOOT_BODY}
    [Return]    ${resp}

Add Server
    [Documentation]    Adds a server for the passed if
    [Arguments]    ${alias}    ${name}    ${imageRef}    ${flavorRef}
    ${dict}=    Create Dictionary   name=${name}   imageRef=${imageRef}   flavorRef=${flavorRef}
    ${data}=    Fill JSON Template File    ${OPENSTACK_NOVA_SERVER_ADD_BODY_FILE}    ${dict}
    ${resp}=    Internal Post Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_SERVERS_PATH}   data_path=    data=${data}
    [Return]    ${resp}

Add Server For Image Name
    [Documentation]    Adds a server for the passed if
    [Arguments]    ${alias}    ${name}    ${imageName}    ${flavorName}
    ${images}=  Get Openstack Images    ${alias}
    ${flavors}=  Get Openstack Flavors    ${alias}
    ${images}=   Get From Dictionary   ${images}   images
    ${flavors}=   Get From Dictionary   ${flavors}   flavors
    ${imageRef}=    Get Id For Name   ${images}    ${imageName}
    ${flavorRef}=   Get Id For Name   ${flavors}    ${flavorName}
    ${dict}=    Create Dictionary   name=${name}   imageRef=${imageRef}   flavorRef=${flavorRef}
    ${data}=    Fill JSON Template File    ${OPENSTACK_NOVA_SERVER_ADD_BODY_FILE}    ${dict}
    ${resp}=    Internal Post Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_SERVERS_PATH}   data_path=    data=${data}
    ${status_string}=    Convert To String    ${resp.status_code}
    Should Match Regexp    ${status_string}    ^(202)$
    [Return]    ${resp.json()}

Wait for Server to Be Active
    [Arguments]    ${alias}   ${server_id}    ${timeout}=300s
    ${server_info}=    Wait Until Keyword Succeeds    ${timeout}    10 sec    Get Active Server    ${alias}    ${server_id}
    ${status}=   Get From Dictionary    ${server_info}    status
    Should Be Equal    ${status}    ACTIVE
    [Return]    ${server_info}

 Get Active Server
    [Arguments]    ${alias}    ${server_id}
    ${resp}=    Get Openstack Server By Id    ${alias}    ${server_id}
    Should Be Equal As Strings   ${resp.status_code}    200
    ${server_info}=    Set Variable    ${resp.json()}
    ${server_info}=    Get From Dictionary   ${server_info}    server
    ${status}=   Get From Dictionary    ${server_info}    status
    Should Not Be Equal    ${status}    BUILD
    [Return]    ${server_info}

Wait for Server to Be Deleted
    [Arguments]    ${alias}    ${server_id}
    Wait Until Keyword Succeeds    300s   10s    Get Deleted Server   ${alias}    ${server_id}

Get Deleted Server
    [Arguments]    ${alias}    ${server_id}
    ${resp}=  Get Openstack Server By Id   ${alias}    ${server_id}
    Should Be Equal As Strings    ${resp.status_code}    404

Delete Server
    [Documentation]    Runs an Openstack Request to delete a keypair
    [Arguments]    ${alias}    ${server_id}
    ${resp}=    Internal Delete Openstack    ${alias}    ${GLOBAL_OPENSTACK_NOVA_SERVICE_TYPE}    ${OPENSTACK_NOVA_SERVERS_PATH}	  /${server_id}
    ${status_string}=    Convert To String    ${resp.status_code}
    Should Match Regexp    ${status_string}    ^(204)$
    [Return]    ${resp.text}

Get Id For Name
    [Arguments]    ${list}    ${name}
    :for   ${item}   in   @{list}
    \    ${id}=    Get From Dictionary    ${item}    id
    \    ${n}=    Get From Dictionary    ${item}    name
    \    Return from Keyword If   '${n}' == '${name}'   ${id}
    [Return]   None
