*** Settings ***
Documentation     The main interface for interacting with A&AI. It handles low level stuff like managing the http request library and A&AI required fields
Library 	      RequestsLibrary
Library	          UUID      
Resource            ../global_properties.robot

*** Variables ***
${AAI_HEALTH_PATH}  /aai/util/echo?action=long
${VERSIONED_INDEX_PATH}     /aai/v8

*** Keywords ***
Run A&AI Health Check
    [Documentation]    Runs an A&AI health check
    ${resp}=    Run A&AI Get Request    ${AAI_HEALTH_PATH}    
    Should Be Equal As Strings 	${resp.status_code} 	200

Run A&AI Get Request
    [Documentation]    Runs an A&AI get request
    [Arguments]    ${data_path}
    ${auth}=  Create List  ${GLOBAL_AAI_USERNAME}    ${GLOBAL_AAI_PASSWORD}
    ${session}=    Create Session 	aai 	${GLOBAL_AAI_SERVER_URL}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Get Request 	aai 	${data_path}     headers=${headers}
    Log    Received response from aai ${resp.text}
    [Return]    ${resp}
    
Run A&AI Put Request
    [Documentation]    Runs an A&AI put request
    [Arguments]    ${data_path}    ${data}
    ${auth}=  Create List  ${GLOBAL_AAI_USERNAME}    ${GLOBAL_AAI_PASSWORD}
    ${session}=    Create Session 	aai 	${GLOBAL_AAI_SERVER_URL}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Put Request 	aai 	${data_path}     data=${data}    headers=${headers}
    Log    Received response from aai ${resp.text}
    [Return]    ${resp}

Run A&AI Post Request
    [Documentation]    Runs an A&AI Post request
    [Arguments]    ${data_path}    ${data}
    ${auth}=  Create List  ${GLOBAL_AAI_USERNAME}    ${GLOBAL_AAI_PASSWORD}
    ${session}=    Create Session 	aai 	${GLOBAL_AAI_SERVER_URL}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Post Request 	aai 	${data_path}     data=${data}    headers=${headers}
    Log    Received response from aai ${resp.text}
    [Return]    ${resp}
    
Run A&AI Delete Request
    [Documentation]    Runs an A&AI delete request
    [Arguments]    ${data_path}    ${resource_version}
    ${auth}=  Create List  ${GLOBAL_AAI_USERNAME}    ${GLOBAL_AAI_PASSWORD}
    ${session}=    Create Session 	aai 	${GLOBAL_AAI_SERVER_URL}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Delete Request 	aai 	${data_path}?resource-version=${resource_version}       headers=${headers}
    Log    Received response from aai ${resp.text}
    [Return]    ${resp}

Delete A&AI Entity
    [Documentation]    Deletes an entity in A&AI	
    [Arguments]    ${uri}
    ${get_resp}=    Run A&AI Get Request     ${VERSIONED_INDEX PATH}${uri}    
	Run Keyword If    '${get_resp.status_code}' == '200'    Delete A&AI Entity Exists    ${uri}    ${get_resp.json()['resource-version']}

Delete A&AI Entity Exists
    [Documentation]    Deletes an  A&AI	entity
    [Arguments]    ${uri}    ${resource_version_id}   
    ${put_resp}=    Run A&AI Delete Request    ${VERSIONED_INDEX PATH}${uri}    ${resource_version_id}
    Should Be Equal As Strings 	${put_resp.status_code} 	204  

    