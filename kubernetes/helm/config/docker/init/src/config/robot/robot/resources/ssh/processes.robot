*** Settings ***
Documentation     Some handy Keywords for accessing log files over SSH.  Assumptions are that logs will belong to users other than the currently logged in user and that sudo will be required
Library           OperatingSystem
Library 	      SSHLibrary    60 seconds
Library           HttpLibrary.HTTP
Library           String
Library           Collections

*** Variables ***

*** Keywords ***

Get Processes
    [Documentation]     Returns all of the processes on the currently connected host 
    ${output}=    Execute Command    ps -ef   
    ${map}=    Create Process Map    ${output}
    [Return]     ${map}

Grep Processes
    [Documentation]     Return the list of processes matching the passed regex 
    [Arguments]    ${pattern} 
    ${output}=    Execute Command    ps -ef|grep "${pattern}"|grep -v grep   
    ${map}=    Create Process Map    ${output}
    [Return]     ${map}

Create Process Map
    [Documentation]     Extract process pids and process names from ps -ef output
    [Arguments]    ${input} 
    @{lines}=    Split To Lines    ${input}
    ${map}=    Create Dictionary
    :for    ${line}    in    @{lines}
    \    @{parts}=    Split String    ${line}    max_split=7 
    \    ${pid}=    Catenate    ${parts[1]}
    \    ${name}=   Catenate   ${parts[7]}
    \    Set To Dictionary    ${map}    ${pid}=${name}      
    [Return]     ${map}
    
         
Wait for Process on Host
    [Documentation]     Wait for the passed process name (regular expression) to be running on the passed host  
    [Arguments]    ${process_name}    ${host}    ${timeout}=600s    
    ${map}=    Wait Until Keyword Succeeds    ${timeout}    10 sec    Is Process On Host    ${process_name}    ${host}
    [Return]    ${map}


Pkill Process on Host
    [Documentation]     Kill the named process(es). Process name must match exactly  
    [Arguments]    ${process_name}    ${host}    ${timeout}=600s
    Switch Connection    ${host}
    ${output}=    Execute Command    pkill -9 -e -f ${process_name}     
    [Return]    ${output}

Is Process on Host
   [Documentation]     Look for the passed process name (regex) to be running on the passed host. Process name can include regex.   
   [Arguments]    ${process_name}    ${host}    
   Switch Connection    ${host}
   ${pass}    ${map}=    Run Keyword and Ignore Error    Grep Processes    ${process_name}
   @{pids}=    Get Dictionary Keys    ${map}
   ${foundpid}=    Catenate    ""
   :for    ${pid}    in    @{pids}
   \    ${process_cmd}=    Get From Dictionary    ${map}    ${pid}
   \    ${status}    ${value}=    Run Keyword And Ignore Error    Should Match Regexp    ${process_cmd}    ${process_name}    
   \    Run Keyword If   '${status}' == 'PASS'    Set Test Variable    ${foundpid}    ${pid}             
   Should Not Be Equal    ${foundpid}    ""           
   [Return]    ${map}[${foundpid}]
   
   
Get Process List on Host
    [Documentation]     Gets the list of all processes on the passed host  
    [Arguments]    ${host}    
    Switch Connection    ${host}
    ${map}=    Get Processes  
    [Return]    ${map}
        