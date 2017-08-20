*** Settings ***
Documentation     The main interface for interacting with VID. It handles low level stuff like managing the selenium request library and VID required steps
Library           Collections
Library           OSUtils
Library           OperatingSystem
Library           ExtendedSelenium2Library
Resource          global_properties.robot

*** Variables ***

*** Keywords ***
Setup Browser
    [Documentation]   Sets up browser based upon the value of ${GLOBAL_SELENIUM_BROWSER}
    Run Keyword If    '${GLOBAL_SELENIUM_BROWSER}' == 'firefox'    Setup Browser Firefox
    Run Keyword If    '${GLOBAL_SELENIUM_BROWSER}' == 'chrome'    Setup Browser Chrome
    Log    Running with ${GLOBAL_SELENIUM_BROWSER}
    
Setup Browser Firefox
    ${dc}   Evaluate    sys.modules['selenium.webdriver'].DesiredCapabilities.FIREFOX  sys, selenium.webdriver
    Set To Dictionary   ${dc}   elementScrollBehavior    1 
    Create Webdriver    Firefox    desired_capabilities=${dc}
    Set Global Variable    ${GLOBAL_SELENIUM_BROWSER_CAPABILITIES}    ${dc}
           
 Setup Browser Chrome
    ${os}=   Get Normalized Os 
    Log    Normalized OS=${os}
    ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${chrome options}    add_argument    no-sandbox
    ${dc}   Evaluate    sys.modules['selenium.webdriver'].DesiredCapabilities.CHROME  sys, selenium.webdriver
    Set To Dictionary   ${dc}   elementScrollBehavior    1
    Create Webdriver    Chrome   chrome_options=${chrome_options}    desired_capabilities=${dc}  
    Set Global Variable    ${GLOBAL_SELENIUM_BROWSER_CAPABILITIES}    ${dc}       

Handle Proxy Warning    
    [Documentation]    Handle Intermediate Warnings from Proxies
    ${status}    ${data}=    Run Keyword And Ignore Error   Variable Should Exist    \${GLOBAL_PROXY_WARNING_TITLE}           
    Return From Keyword if    '${status}' != 'PASS'
    ${status}    ${data}=    Run Keyword And Ignore Error   Variable Should Exist    \${GLOBAL_PROXY_WARNING_CONTINUE_XPATH}          
    Return From Keyword if    '${status}' != 'PASS'
    Return From Keyword if    "${GLOBAL_PROXY_WARNING_TITLE}" == ''
    Return From Keyword if    "${GLOBAL_PROXY_WARNING_CONTINUE_XPATH}" == ''
    ${test}    ${value}=    Run keyword and ignore error    Title Should Be     ${GLOBAL_PROXY_WARNING_TITLE}
    Run keyword If    '${test}' == 'PASS'    Click Element    xpath=${GLOBAL_PROXY_WARNING_CONTINUE_XPATH}