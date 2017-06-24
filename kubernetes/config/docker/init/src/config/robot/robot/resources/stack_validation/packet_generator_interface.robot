*** Settings ***
Documentation     The main interface for interacting with A&AI. It handles low level stuff like managing the http request library and A&AI required fields
Library 	      RequestsLibrary
Library           StringTemplater
Library	          UUID      
Library	          OperatingSystem      
Resource          ../global_properties.robot
Resource          ../json_templater.robot

*** Variables ***
${PGN_URL_TEMPLATE}     http://\${host}:\${port}
${PGN_PATH}    /restconf/config/sample-plugin:sample-plugin
${PGN_ENABLE_STREAM_TEMPLATE}    robot/assets/templates/vfw_pg_stream_enable.template
${PGN_ENABLE_STREAMS_TEMPLATE}    robot/assets/templates/vfw_pg_streams_enable.template

*** Keywords ***
Connect To Packet Generator
    [Documentation]    Enables packet generator for the passed stream on the passed host
    [Arguments]    ${host}    ${alias}=pgn
    ${map}=  Create Dictionary     host=${host}    port=${GLOBAL_PACKET_GENERATOR_PORT}    path=${PGN_PATH}   
    ${url}=    Template String    ${PGN_URL_TEMPLATE}    ${map}        
    ${auth}=  Create List     ${GLOBAL_PACKET_GENERATOR_USERNAME}    ${GLOBAL_PACKET_GENERATOR_PASSWORD} 
    ${session}=    Create Session 	${alias} 	${url}    auth=${auth}
    [Return]     ${session}    

Enable Stream
    [Documentation]    Enable a single stream on the passed packet generator host IP  
    [Arguments]    ${host}    ${stream}=udp1    ${alias}=pgn
    Connect To Packet Generator    ${host}    alias=${alias}
    ${headers}=  Create Headers
    ${data_path}=    Catenate    ${PGN_PATH}/pg-streams    
    ${map}=    Create Dictionary    stream=${stream}
    ${streams}=   Fill JSON Template File    ${PGN_ENABLE_STREAM_TEMPLATE}    ${map}
    ${streams}=    evaluate    json.dumps(${streams})    json
    ${map}=    Create Dictionary    pgstreams=${streams}
    ${data}=   Fill JSON Template File    ${PGN_ENABLE_STREAMS_TEMPLATE}    ${map} 
    ${resp}= 	Put Request 	${alias} 	${data_path}     data=${data}     headers=${headers}
    Should Be Equal As Strings    ${resp.status_code}    200
    [Return]    ${resp}

Enable Streams
    [Documentation]    Enable <stream_count> number of streams on the passed packet generator host IP  
    [Arguments]    ${host}    ${stream_count}=5    ${alias}=pgn    ${prefix}=fw_udp
    Connect To Packet Generator    ${host}    alias=${alias}
    ${headers}=  Create Headers
    ${data_path}=    Catenate    ${PGN_PATH}/pg-streams
    ${streams}=    Set Variable
    ${comma}=      Set Variable
    ${stream_count}=    Evaluate    ${stream_count}+1        
    :for    ${i}    in Range     1    ${stream_count}
    \    ${name}=    Catenate    ${prefix}${i}
    \    ${map}=    Create Dictionary    stream=${name}
    \    ${one}=   Fill JSON Template File    ${PGN_ENABLE_STREAM_TEMPLATE}    ${map}
    \    ${one}=    evaluate    json.dumps(${one})    json     
    \    ${streams}=    Set Variable    ${streams}${comma}${one}
    \    ${comma}=      Set Variable    , 
    ${map}=    Create Dictionary    pgstreams=${streams}
    ${data}=   Fill JSON Template File    ${PGN_ENABLE_STREAMS_TEMPLATE}    ${map} 
    ${resp}= 	Put Request 	${alias} 	${data_path}     data=${data}     headers=${headers}
    Should Be Equal As Strings    ${resp.status_code}    200
    [Return]    ${resp}

Disable All Streams
    [Documentation]    Disable all streams on the passed packet generator host IP
    [Arguments]    ${host}    ${stream}=udp1    ${alias}=pgn
    Connect To Packet Generator    ${host}    alias=${alias}
    ${headers}=  Create Headers
    ${data_path}=    Catenate    ${PGN_PATH}/pg-streams  
    ${data}=   Catenate    {"pg-streams":{"pg-stream": []}}
    ${resp}= 	Put Request 	${alias} 	${data_path}     data=${data}     headers=${headers}
    Should Be Equal As Strings    ${resp.status_code}    200
    [Return]    ${resp}

 Disable Stream
    [Documentation]    Disables packet generator for the passed stream 
    [Arguments]    ${host}    ${stream}=udp1    ${alias}=pgn
    ${session}=    Connect To Packet Generator    ${host}    alias=${alias}
    ${headers}=  Create Headers
    ${data_path}=    Catenate    ${PGN_PATH}/pg-streams/pg-stream/${stream}        
    ${resp}= 	Delete Request 	${alias} 	${data_path}     headers=${headers}
    Should Be Equal As Strings    ${resp.status_code}    200
    [Return]    ${resp}
    
Get List Of Enabled Streams
    [Documentation]     Get a list of streams on the passed packet generator host IP    
    [Arguments]    ${host}    ${alias}=pgn
    ${session}=    Connect To Packet Generator    ${host}    alias=${alias}
    ${headers}=  Create Headers
    ${data_path}=    Catenate    /        
    ${resp}= 	Get Request 	${alias} 	${PGN_PATH}     headers=${headers}
    Should Be Equal As Strings    ${resp.status_code}    200
    [Return]    ${resp.json()}
    
   
Create Headers
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    [Return]    ${headers}     