*** Settings ***
Documentation     The main interface for interacting with DCAE. It handles low level stuff like managing the http request library and DCAE required fields
Library 	      RequestsLibrary
Library	          UUID      
Library           OperatingSystem
Library           Collections
Resource          global_properties.robot

*** Variables ***
${DCAE_HEALTH_CHECK_BODY}    robot/assets/dcae/dcae_healthcheck.json
${DCAE_HEALTH_CHECK_PATH}    /gui

*** Keywords ***
Run DCAE Health Check
    [Documentation]    Runs a DCAE health check
    ${auth}=  Create List  ${GLOBAL_DCAE_USERNAME}    ${GLOBAL_DCAE_PASSWORD}
    Log    Creating session ${GLOBAL_DCAE_SERVER}
    ${session}=    Create Session 	dcae 	${GLOBAL_DCAE_SERVER}    auth=${auth}
    ${uuid}=    Generate UUID
    ${data}=    OperatingSystem.Get File    ${DCAE_HEALTH_CHECK_BODY}
    ${headers}=  Create Dictionary     action=getTable    Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Put Request 	dcae 	${DCAE_HEALTH_CHECK_PATH}     data=${data}    headers=${headers}
    Log    Received response from dcae ${resp.json()}
    Should Be Equal As Strings 	${resp.status_code} 	200
    Check DCAE Results    ${resp.json()}
    
Check DCAE Results
    [Documentation]    Parse DCAE JSON response and make sure all rows have healthTestStatus=GREEN
    [Arguments]    ${json}
    @{rows}=    Get From Dictionary    ${json['returns']}    rows
    @{headers}=    Get From Dictionary    ${json['returns']}    columns
    
    # Retrieve column names from headers
    ${columns}=    Create List
    :for    ${header}    in    @{headers}
    \    ${colName}=    Get From Dictionary    ${header}    colName 
    \    Append To List    ${columns}    ${colName}
    
    # Process each row making sure status=GREEN          
    :for    ${row}    in    @{rows}
    \    ${cells}=    Get From Dictionary    ${row}    cells
    \    ${dict}=    Make A Dictionary    ${cells}    ${columns} 
    \    Dictionary Should Contain Item    ${dict}    healthTestStatus    GREEN

        
Make A Dictionary
    [Documentation]    Given a list of column names and a list of dictionaries, map columname=value
    [Arguments]     ${columns}    ${names}    ${valuename}=value
    ${dict}=    Create Dictionary
    ${collength}=    Get Length    ${columns} 
    ${namelength}=    Get Length    ${names} 
    :for    ${index}    in range    0   ${collength}
    \    ${name}=    Evaluate     ${names}[${index}]
    \    ${valued}=    Evaluate     ${columns}[${index}]
    \    ${value}=    Get From Dictionary    ${valued}    ${valueName}
    \    Set To Dictionary    ${dict}   ${name}    ${value}     
    [Return]     ${dict}            