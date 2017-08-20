*** Settings ***
Documentation     The main interface for interacting with A&AI. It handles low level stuff like managing the http request library and A&AI required fields
Library 	    ExtendedSelenium2Library
Library           StringTemplater
Library	          UUID      
Library	          OperatingSystem      
Resource          ../global_properties.robot
Resource          ../browser_setup.robot

*** Variables ***
${SNK_HOSTS_TEMPLATE}     http://\${host}:\${port}/hosts/
${SNK_HOME_TEMPLATE}     http://\${host}:\${port}/
${SNK_PATH}    
${SNK_PORT}    667
${BYTES_PER_PACKET}    29
${PACKETS_PER_SECOND_PER_STREAM}     11
${MONITOR_INTERVAL_IN_SECONDS}      4

*** Keywords ***
Get Darkstat Bytes In 
    [Documentation]    Get bytes received on the passed interface for the given interval  
    [Arguments]    ${host}    ${interface}    ${interval}=${MONITOR_INTERVAL_IN_SECONDS}     
    ${map}=  Create Dictionary     host=${host}    port=${SNK_PORT}    path=${SNK_PATH}   
    ${url}=    Template String    ${SNK_HOSTS_TEMPLATE}    ${map}        
    Connect to Darkstat    ${host}    ${url}        
    Title Should Be    Hosts (darkstat3 eth1)
    ${initial_bytes}=    Get Current Bytes In    ${interface}
    Sleep     ${interval}    
    Go To    ${url}
    ${new_bytes}=    Get Current Bytes In   ${interface}
    ${return_bytes}=    Evaluate    int(${new_bytes}) - int(${initial_bytes})
    [Return]    ${return_bytes}

Get Darkstat Packets In 
    [Documentation]    Get bytes received on the passed interface for the given interval  
    [Arguments]    ${host}    ${interval}=${MONITOR_INTERVAL_IN_SECONDS}     
    ${map}=  Create Dictionary     host=${host}    port=${SNK_PORT}    path=${SNK_PATH}   
    ${url}=    Template String    ${SNK_HOME_TEMPLATE}    ${map}        
    Connect to Darkstat    ${host}    ${url}        
    Title Should Be    Graphs (darkstat3 eth1)
    ${initial_pkts}=    Get Current Packets In
    Sleep     ${interval}    
    Go To    ${url}
    ${new_pkts}=    Get Current Packets In
    ${return_pkts}=    Evaluate    int(${new_pkts}) - int(${initial_pkts})
    [Return]    ${return_pkts}

    
Connect to Darkstat
    [Documentation]   COnnects to the Darkstat port on passed host
    [Arguments]    ${host}    ${url}
    ## Being managed by the test case
    ##Setup Browser
    Go To    ${url}
    Maximize Browser Window
    Set Selenium Speed    ${GLOBAL_SELENIUM_DELAY}
    Set Browser Implicit Wait    ${GLOBAL_SELENIUM_BROWSER_IMPLICIT_WAIT}
    Log    Logging in to ${url}
    Handle Proxy Warning
    

Get Current Bytes In
    [Documentation]    Retrieves packets input from given host from current Darkstats hosts page
    [Arguments]    ${interface}
    ${bytes}=    Get Text    xpath=//tr[td/a[text() = '${interface}']]/td[4]
    ${bytes}=    Evaluate    ${bytes.replace(',', '')}
    [Return]     ${bytes}

Get Current Packets In
    [Documentation]    Retrieves packets input from given host from current Darkstats hosts page
    ${bytes}=    Get Text    xpath=//span[@id = 'tp']
    ${bytes}=    Evaluate    ${bytes.replace(',', '')}
    [Return]     ${bytes}
    
    
Get Expected Range For Number Of Streams
    [Documentation]    Calculates the expected range of bytes for an interval for the given number of streams
    [Arguments]    ${number_of_streams}
    ${bytes_per_second}=     Evaluate    ${BYTES_PER_PACKET}*(${PACKETS_PER_SECOND_PER_STREAM}*${number_of_streams})
    ${low_bytes}=    Evaluate    (${MONITOR_INTERVAL_IN_SECONDS}-1)*${bytes_per_second}
    ${high_bytes}=    Evaluate    (${MONITOR_INTERVAL_IN_SECONDS}+1)*${bytes_per_second}       
    [Return]    ${low_bytes}    ${high_bytes}