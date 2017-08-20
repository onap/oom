*** Settings ***
Documentation     The main interface for interacting with VID. It handles low level stuff like managing the selenium request library and VID required steps
Library 	    ExtendedSelenium2Library
Library    Collections
Library         String
Library 	      RequestsLibrary
Library	          UUID      
Resource        ../global_properties.robot
Resource        ../browser_setup.robot

*** Variables ***
${VID_ENV}            /vid
${VID_LOGIN_URL}                ${GLOBAL_VID_SERVER}${VID_ENV}/login_external.htm
${VID_HEALTHCHECK_PATH}    ${VID_ENV}/api/users
${VID_HOME_URL}                ${GLOBAL_VID_SERVER}${VID_ENV}/vidhome.htm

*** Keywords ***
Run VID Health Check
    [Documentation]   Logs in to VID GUI
    ${resp}=    Run VID Get Request    ${VID_HEALTHCHECK_PATH}
    Should Be Equal As Strings 	${resp.status_code} 	200
    Should Be String    ${resp.json()[0]['loginId']}

Run VID Get Request
    [Documentation]    Runs an VID get request
    [Arguments]    ${data_path}
    ${auth}=  Create List  ${GLOBAL_VID_HEALTH_USERNAME}    ${GLOBAL_VID_HEALTH_PASSWORD}
    Log    Creating session ${GLOBAL_VID_SERVER}
    ${session}=    Create Session 	vid 	${GLOBAL_VID_SERVER}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     username=${GLOBAL_VID_HEALTH_USERNAME}    password=${GLOBAL_VID_HEALTH_PASSWORD}    Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Get Request 	vid 	${data_path}     headers=${headers}
    Log    Received response from vid ${resp.text}
    [Return]    ${resp}   
    
Login To VID GUI
    [Documentation]   Logs in to VID GUI
    # Setup Browser Now being managed by test case
    ##Setup Browser
    Go To    ${VID_LOGIN_URL}
    Maximize Browser Window
    Set Selenium Speed    ${GLOBAL_SELENIUM_DELAY}
    Set Browser Implicit Wait    ${GLOBAL_SELENIUM_BROWSER_IMPLICIT_WAIT}
    Log    Logging in to ${GLOBAL_VID_SERVER}${VID_ENV}
    Handle Proxy Warning
    Title Should Be    VID Login
    Input Text    xpath=//input[@ng-model='loginId']    ${GLOBAL_VID_USERNAME}
    Input Password    xpath=//input[@ng-model='password']    ${GLOBAL_VID_PASSWORD}
    Click Button    xpath=//input[@id='loginBtn']
    Wait Until Page Contains Element    xpath=//div[@class='applicationWindow']    ${GLOBAL_SELENIUM_BROWSER_WAIT_TIMEOUT}    
    Log    Logged in to ${GLOBAL_VID_SERVER}${VID_ENV}

Go To VID HOME
    [Documentation]    Naviage to VID Home
    Go To    ${VID_HOME_URL}
    Wait Until Page Contains Element    xpath=//div[@class='applicationWindow']    ${GLOBAL_SELENIUM_BROWSER_WAIT_TIMEOUT}    
        
Click On Button When Enabled
    [Arguments]     ${xpath}    ${timeout}=60s
    Wait Until Page Contains Element    xpath=${xpath}    ${timeout}
    Wait Until Element Is Enabled    xpath=${xpath}    ${timeout}
    Click Button      xpath=${xpath}

Click On Button When Visible
    [Arguments]     ${xpath}    ${timeout}=60s
    Wait Until Page Contains Element    xpath=${xpath}    ${timeout}
    Wait Until Element Is Visible    xpath=${xpath}    ${timeout}
    Click Button      xpath=${xpath}
   
Click On Element When Visible
    [Arguments]     ${xpath}    ${timeout}=60s
    Wait Until Page Contains Element    xpath=${xpath}    ${timeout}
    Wait Until Element Is Visible    xpath=${xpath}    ${timeout}
    Click Element      xpath=${xpath}
    
Select From List When Enabled
    [Arguments]     ${xpath}    ${value}    ${timeout}=60s
    Wait Until Page Contains Element    xpath=${xpath}    ${timeout}
    Wait Until Element Is Enabled    xpath=${xpath}    ${timeout}
    Select From List     xpath=${xpath}    ${value}   
    
Input Text When Enabled        
    [Arguments]     ${xpath}    ${value}    ${timeout}=60s
    Wait Until Page Contains Element    xpath=${xpath}    ${timeout}
    Wait Until Element Is Enabled    xpath=${xpath}    ${timeout}
    Input Text    xpath=${xpath}    ${value}
    
Parse Request Id
    [Arguments]    ${mso_response_text}					
	${request_list}=     Split String    ${mso_response_text}    202)\n    1
	${clean_string}=    Replace String    ${request_list[1]}    \n    ${empty}   
    ${json}=    To Json    ${clean_string} 
    ${request_id}=    Catenate    ${json['requestReferences']['requestId']}
    [Return]    ${request_id}
    
Parse Instance Id
    [Arguments]    ${mso_response_text}					
	${request_list}=     Split String    ${mso_response_text}    202)\n    1
    ${json}=    To Json    ${request_list[1]} 
    ${request_id}=    Catenate    ${json['requestReferences']['instanceId']}
    [Return]    ${request_id}