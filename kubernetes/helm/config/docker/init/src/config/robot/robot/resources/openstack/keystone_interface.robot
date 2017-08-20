*** Settings ***
Documentation     The main interface for interacting with Openstack Keystone API. It handles low level stuff like managing the authtoken and Openstack required fields
Library           OpenstackLibrary
Library 	      RequestsLibrary
Library	          UUID
Library	          Collections
Library    OperatingSystem
Resource    ../global_properties.robot
Resource    ../json_templater.robot
Resource    openstack_common.robot

*** Variables ***
${OPENSTACK_KEYSTONE_API_VERSION}    /v2.0
${OPENSTACK_KEYSTONE_AUTH_PATH}    /tokens
${OPENSTACK_KEYSTONE_AUTH_BODY_FILE}    robot/assets/templates/keystone_get_auth.template
${OPENSTACK_KEYSTONE_TENANT_PATH}    /tenants

*** Keywords ***
Run Openstack Auth Request
    [Documentation]    Runs an Openstack Auth Request and returns the token and service catalog. you need to include the token in future request's x-auth-token headers. Service catalog describes what can be called
    [Arguments]    ${alias}    ${username}=    ${password}=
    ${username}    ${password}=   Set Openstack Credentials   ${username}    ${password}
    ${session}=    Create Session 	keystone 	${GLOBAL_OPENSTACK_KEYSTONE_SERVER}    verify=True
    ${uuid}=    Generate UUID
    ${data_template}=    OperatingSystem.Get File    ${OPENSTACK_KEYSTONE_AUTH_BODY_FILE}
    ${arguments}=    Create Dictionary    username=${username}    password=${password}
    ${data}=	Fill JSON Template    ${data_template}    ${arguments}
    ${data_path}=    Catenate    ${OPENSTACK_KEYSTONE_API_VERSION}${OPENSTACK_KEYSTONE_AUTH_PATH}
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    Log    Sending authenticate post request ${data_path} with headers ${headers} and data ${data}
    ${resp}= 	Post Request 	keystone 	${data_path}     data=${data}    headers=${headers}
    Save Openstack Auth    ${alias}    ${resp.text}
    Log    Received response from keystone ${resp.text}

Get Openstack Tenants
    [Documentation]    Returns all the openstack tenant info
    [Arguments]    ${alias}
    ${resp}=    Internal Get Openstack With Region    ${alias}    ${GLOBAL_OPENSTACK_KEYSTONE_SERVICE_TYPE}    region=    url_ext=${OPENSTACK_KEYSTONE_TENANT_PATH}    data_path=
    [Return]    ${resp.json()}

Get Openstack Tenant
    [Documentation]    Returns the openstack tenant info for the specified tenantid
    [Arguments]    ${alias}     ${tenant_id}
    ${resp}=    Internal Get Openstack With Region    ${alias}    ${GLOBAL_OPENSTACK_KEYSTONE_SERVICE_TYPE}    region=    url_ext=${OPENSTACK_KEYSTONE_TENANT_PATH}    data_path=/${tenant_id}
    [Return]    ${resp.json()}

Set Openstack Credentials
    [Arguments]    ${username}    ${password}
    Return From Keyword If    '${username}' != ''   ${username}    ${password}
    ${user}   ${pass}=   Get Openstack Credentials
    [Return]   ${user}   ${pass}

Get Openstack Credentials
    Dictionary Should Contain Key  ${GLOBAL_VM_PROPERTIES}   openstack_username
    [Return]   ${GLOBAL_VM_PROPERTIES['openstack_username']}    ${GLOBAL_VM_PROPERTIES['openstack_password']}