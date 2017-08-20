*** Settings ***
Documentation	  The main interface for interacting with Message router. It handles low level stuff like managing the http request library and message router required fields
Library	          RequestsClientCert
Library 	      RequestsLibrary
Library	          UUID      

Resource          global_properties.robot

*** Variables ***
${MR_HEALTH_CHECK_PATH}        /topics

*** Keywords ***
Run MR Health Check
     [Documentation]    Runs MR Health check
     ${resp}=    Run MR Get Request    ${MR_HEALTH_CHECK_PATH}    
     Should Be Equal As Strings 	${resp.status_code} 	200
     Should Contain    ${resp.json()}    topics
         
Run MR Get Request
     [Documentation]    Runs MR Get request
     [Arguments]    ${data_path}
     ${session}=    Create Session 	mr	${GLOBAL_MR_SERVER}
     ${uuid}=    Generate UUID
     ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
     ${resp}= 	Get Request 	mr 	${data_path}     headers=${headers}
     Log    Received response from message router ${resp.text}
     [Return]    ${resp}

