*** Settings ***
Documentation	  The main interface for interacting with Portal. It handles low level stuff like managing the http request library and Portal required fields
Library	          RequestsClientCert
Library 	      RequestsLibrary
Library	          UUID      

Resource          global_properties.robot

*** Variables ***
${PORTAL_HEALTH_CHECK_PATH}        /ECOMPPORTAL/portalApi/healthCheck

*** Keywords ***
Run Portal Health Check
     [Documentation]    Runs Portal Health check
     ${resp}=    Run Portal Get Request    ${PORTAL_HEALTH_CHECK_PATH}    
     Should Be Equal As Strings 	${resp.status_code} 	200
     Should Be Equal As Strings 	${resp.json()['statusCode']} 	200
         
Run Portal Get Request
     [Documentation]    Runs Portal Get request
     [Arguments]    ${data_path}
     ${session}=    Create Session 	portal	${GLOBAL_PORTAL_SERVER}
     ${uuid}=    Generate UUID
     ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
     ${resp}= 	Get Request 	portal 	${data_path}     headers=${headers}
     Log    Received response from portal ${resp.text}
     [Return]    ${resp}

