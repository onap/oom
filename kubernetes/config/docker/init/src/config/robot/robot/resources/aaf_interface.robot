*** Settings ***
Documentation	  The main interface for interacting with AAF. It handles low level stuff like managing the http request library and AAF required fields
Library	          RequestsClientCert
Library 	      RequestsLibrary
Library	          UUID      

Resource          global_properties.robot

*** Variables ***
${AAF_HEALTH_CHECK_PATH}        /authz/nss/org.openecomp

*** Keywords ***
Run AAF Health Check
     [Documentation]    Runs AAF Health check
     ${resp}=    Run AAF Get Request    ${AAF_HEALTH_CHECK_PATH}    
     Should Be Equal As Strings 	${resp.status_code} 	200
     Should Contain    ${resp.json()}    ns
         
Run AAF Get Request
     [Documentation]    Runs AAF Get request
     [Arguments]    ${data_path}
     ${auth}=  Create List  ${GLOBAL_AAF_USERNAME}    ${GLOBAL_AAF_PASSWORD}
     ${session}=    Create Session 	aaf	${GLOBAL_AAF_SERVER}    auth=${auth}
     ${uuid}=    Generate UUID
     ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
     ${resp}= 	Get Request 	aaf 	${data_path}     headers=${headers}
     Log    Received response from aaf ${resp.text}
     [Return]    ${resp}

