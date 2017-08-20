*** Settings ***
Documentation     The main interface for interacting with MSO. It handles low level stuff like managing the http request library and MSO required fields
Library 	      RequestsLibrary
Library	          UUID      
Library           OperatingSystem
Library           Collections
Resource          global_properties.robot
Resource          ../resources/json_templater.robot
*** Variables ***
${MSO_HEALTH_CHECK_PATH}    /ecomp/mso/infra/globalhealthcheck

*** Keywords ***
Run MSO Health Check
    [Documentation]    Runs an MSO global health check
    ${auth}=  Create List  ${GLOBAL_MSO_USERNAME}    ${GLOBAL_MSO_PASSWORD}
    ${session}=    Create Session 	mso 	${GLOBAL_MSO_SERVER}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=text/html    Content-Type=text/html    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Get Request 	mso 	${MSO_HEALTH_CHECK_PATH}     headers=${headers}
    Should Be Equal As Strings 	${resp.status_code} 	200

Run MSO Get Request
    [Documentation]    Runs an MSO get request
    [Arguments]    ${data_path}    ${accept}=application/json
    ${auth}=  Create List  ${GLOBAL_MSO_USERNAME}    ${GLOBAL_MSO_PASSWORD}
    Log    Creating session ${GLOBAL_MSO_SERVER}
    ${session}=    Create Session 	mso 	${GLOBAL_MSO_SERVER}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=${accept}    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Get Request 	mso 	${data_path}     headers=${headers}
    Log    Received response from mso ${resp.text}
    [Return]    ${resp}
    
Poll MSO Get Request
    [Documentation]    Runs an MSO get request until a certain status is received. valid values are COMPLETE
    [Arguments]    ${data_path}     ${status}
    ${auth}=  Create List  ${GLOBAL_MSO_USERNAME}    ${GLOBAL_MSO_PASSWORD}
    Log    Creating session ${GLOBAL_MSO_SERVER}
    ${session}=    Create Session 	mso 	${GLOBAL_MSO_SERVER}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    #do this until it is done
    :FOR    ${i}    IN RANGE    20
    \    ${resp}= 	Get Request 	mso 	${data_path}     headers=${headers}
    \    Should Not Contain    ${resp.text}    FAILED
    \    Log    ${resp.json()['request']['requestStatus']['requestState']}   
    \    ${exit_loop}=    Evaluate    "${resp.json()['request']['requestStatus']['requestState']}" == "${status}"
    \    Exit For Loop If  ${exit_loop}
    \    Sleep    15s
    Log    Received response from mso ${resp.text}
    [Return]    ${resp}


    
