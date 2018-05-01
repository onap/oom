*** Settings ***
Documentation     The main interface for interacting with OOF: SNIRO and Homing Service
Library           RequestsLibrary

Resource          global_properties.robot

*** Variables ***
${OOF_HOMING_HEALTH_CHECK_PATH}       /v1/plans/healthcheck
${OOF_SNIRO_HEALTH_CHECK_PATH}        /api/oof/v1/healthcheck

${OOF_HOMING_ENDPOINT}    ${GLOBAL_OOF_SERVER_PROTOCOL}://${GLOBAL_INJECTED_OOF_HOMING_IP_ADDR}:${GLOBAL_OOF_HOMING_SERVER_PORT}
${OOF_SNIRO_ENDPOINT}     ${GLOBAL_OOF_SERVER_PROTOCOL}://${GLOBAL_INJECTED_OOF_SNIRO_IP_ADDR}:${GLOBAL_OOF_SNIRO_SERVER_PORT}

*** Keywords ***
Run OOF-Homing Health Check
     [Documentation]    Runs OOF-Homing Health check
     ${resp}=    Run OOF-Homing Get Request    ${OOF_HOMING_HEALTH_CHECK_PATH}
     Should Be Equal As Integers   ${resp.status_code}   200

Run OOF-Homing Get Request
     [Documentation]    Runs OOF-Homing Get request
     [Arguments]    ${data_path}
     ${session}=    Create Session   session   ${OOF_HOMING_ENDPOINT}
     ${resp}=   Get Request   session   ${data_path}
     Should Be Equal As Integers   ${resp.status_code}   200
     Log    Received response from OOF-Homing ${resp.text}
     [Return]    ${resp}
 
Run OOF-SNIRO Health Check
     [Documentation]    Runs OOF-SNIRO Health check
     ${resp}=    Run OOF-SNIRO Get Request    ${OOF_SNIRO_HEALTH_CHECK_PATH}
     Should Be Equal As Integers   ${resp.status_code}   200

Run OOF-SNIRO Get Request
     [Documentation]    Runs OOF-SNIRO Get request
     [Arguments]    ${data_path}
     ${session}=    Create Session   session   ${OOF_SNIRO_ENDPOINT}
     ${resp}=   Get Request   session   ${data_path}
     Should Be Equal As Integers   ${resp.status_code}   200
     Log    Received response from OOF-SNIRO ${resp.text}
     [Return]    ${resp}
