*** Settings ***
Documentation     The main interface for interacting with APP-C. It handles low level stuff like managing the http request library and APP-C required fields
Library 	      RequestsLibrary
Library	          UUID      
Library           OperatingSystem
Library           StringTemplater
Resource          global_properties.robot

*** Variables ***
${APPC_INDEX_PATH}    /restconf
${APPC_HEALTHCHECK_OPERATION_PATH}  /operations/SLI-API:healthcheck
${APPC_CREATE_MOUNTPOINT_PATH}  /config/network-topology:network-topology/topology/topology-netconf/node/
${APPC_MOUNT_XML}    robot/assets/templates/appc/vnf_mount.template

*** Keywords ***
Run APPC Health Check
    [Documentation]    Runs an APPC healthcheck
	${resp}=    Run APPC Post Request     ${APPC_INDEX PATH}${APPC_HEALTHCHECK_OPERATION_PATH}     ${None}
    Should Be Equal As Strings 	${resp.status_code} 	200
    Should Be Equal As Strings 	${resp.json()['output']['response-code']} 	200   

Run APPC Post Request
    [Documentation]    Runs an APPC post request
    [Arguments]    ${data_path}    ${data}    ${content}=json
    ${auth}=  Create List  ${GLOBAL_APPC_USERNAME}    ${GLOBAL_APPC_PASSWORD}
    Log    Creating session ${GLOBAL_APPC_SERVER}
    ${session}=    Create Session 	appc 	${GLOBAL_APPC_SERVER}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/${content}    Content-Type=application/${content}    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Post Request 	appc 	${data_path}     data=${data}    headers=${headers}
    Log    Received response from appc ${resp.text}
    [Return]    ${resp}

Run APPC Put Request
    [Documentation]    Runs an APPC post request
    [Arguments]    ${data_path}    ${data}    ${content}=xml
    ${auth}=  Create List  ${GLOBAL_APPC_USERNAME}    ${GLOBAL_APPC_PASSWORD}
    Log    Creating session ${GLOBAL_APPC_SERVER}
    ${session}=    Create Session 	appc 	${GLOBAL_APPC_SERVER}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/${content}    Content-Type=application/${content}    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Put Request 	appc 	${data_path}     data=${data}    headers=${headers}
    Log    Received response from appc ${resp.text}
    [Return]    ${resp}
    
Create Mount Point In APPC
    [Documentation]     Go tell APPC about the PGN we just spun up...
    [Arguments]    ${nodeid}    ${host}    ${port}=${GLOBAL_PGN_PORT}    ${username}=admin    ${password}=admin
    ${dict}=    Create Dictionary    nodeid=${nodeid}    host=${host}    port=${port}    username=${username}    password=${password}
    ${template}=    OperatingSystem.Get File    ${APPC_MOUNT_XML}
    ${data}=    Template String    ${template}    ${dict}   
    ${resp}=    Run APPC Put Request     ${APPC_INDEX PATH}${APPC_CREATE_MOUNTPOINT_PATH}${nodeid}     ${data}
    Should Be Equal As Strings 	${resp.status_code} 	200
    [Return]     ${resp}    