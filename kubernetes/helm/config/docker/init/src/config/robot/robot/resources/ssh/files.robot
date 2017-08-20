*** Settings ***
Documentation     Some handy Keywords for accessing log files over SSH.  Assumptions are that logs will belong to users other than the currently logged in user and that sudo will be required
Library           OperatingSystem
Library 	      SSHLibrary
Library           HttpLibrary.HTTP
Library           String
Library           Collections

*** Variables ***

*** Keywords ***
Open Connection And Log In
   [Documentation]    Open a connection using the passed user and SSH key. Connection alias will be the host name by default.
   [Arguments]    ${HOST}    ${user}    ${pvt}    ${password}=    ${alias}=${HOST}    ${timeout}=120s
   Open Connection    ${HOST}    alias=${alias}    timeout=${timeout}
   Login With Public Key    ${user}    ${pvt}    password=${password}    delay=0.5 seconds

Grep Local File
    [Documentation]     Grep the passed file name and return all of the lines that match the passed pattern using the current connection
    [Arguments]    ${pattern}     ${fullpath}
    ${output}=    Execute Command    grep ${pattern} ${fullpath}
    [Return]     ${output}

 Grep File on Host
    [Documentation]     Grep the passed file name and return all of the lines that match the passed pattern using passed connection alias/host
    [Arguments]     ${host}    ${pattern}     ${fullpath}
    Switch Connection    ${host}
    ${output}=    Grep Local File    ${pattern}    ${fullpath}
    @{lines}=    Split To Lines    ${output}
    [Return]     @{lines}

Grep File on Hosts
    [Documentation]     Grep the passed file name and return all of the lines that match the passed pattern using passed list of connections
    [Arguments]    ${HOSTS}    ${pattern}    ${fullpath}
    &{map}=    Create Dictionary
    :FOR    ${HOST}    IN    @{HOSTS}
    \    Log    ${HOST}
    \    @{lines}=    Grep File on Host    ${HOST}   ${pattern}    ${fullpath}
    \    &{map}=    Create Dictionary    ${HOST}=@{lines}    &{map}
    [Return]    &{map}

Tail File on Host Until
    [Documentation]     Tail log file into grep which returns file lines containing the grep pattern. Will timeout after timeout= if expected pattern not received.
    [Arguments]    ${host}    ${pattern}    ${fullpath}    ${expected}    ${timeout}=60    ${options}=-c -0
    Switch Connection    ${host}
    ${tailcommand}=    Catenate    tail ${options} -f ${fullpath} | grep --color=never ${pattern}
    Write    ${tailcommand}
    ${stdout}=	Read Until Regexp    ${expected}
    @{lines}=    Split To Lines    ${stdout}
    [Return]    @{lines}
