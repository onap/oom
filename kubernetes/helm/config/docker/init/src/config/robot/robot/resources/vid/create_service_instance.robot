*** Settings ***
Documentation	  Creates VID Service Instance
...
...	              Creates VID Service Instance

Library 	    ExtendedSelenium2Library
Library	        UUID
Library         String
Library        DateTime

Resource          ../mso_interface.robot
Resource          vid_interface.robot

*** Keywords ***
Create VID Service Instance
    [Documentation]    Creates a service instance using VID
    [Arguments]    ${customer_name}  ${service_model_type}    ${service_type}     ${service_name}
    Go To VID HOME
    Wait Until Keyword Succeeds    300s    1s    Wait For Model    ${service_model_type}
    Press Key    xpath=//tr[td/span/text() = '${service_model_type}']/td/button[text() = 'Deploy' and not(@disabled)]    \\13
    ${uuid}=    Generate UUID
    Wait Until Page Contains Element    xpath=//input[@parameter-name='Instance Name']    120s
    Wait Until Element Is Visible    xpath=//input[@parameter-name='Instance Name']    120s
    Xpath Should Match X Times    //input[@parameter-name='Instance Name']    1
    Input Text When Enabled    //input[@parameter-name='Instance Name']    ${service_name}
    Select From List When Enabled    //select[@prompt='Select Subscriber Name']    ${customer_name}
    Select From List WHen Enabled    //select[@prompt='Select Service Type']     ${service_type}
    Click On Button When Enabled    //div[@class = 'buttonRow']/button[text() = 'Confirm']
 	Wait Until Element Contains    xpath=//div[@ng-controller= 'msoCommitController']/pre[@class = 'log ng-binding']    requestId    timeout=120s
    ${response text}=    Get Text    xpath=//div[@ng-controller= 'msoCommitController']/pre[@class = 'log ng-binding']
    Click On Button When Enabled    //div[@class = 'buttonRow']/button[text() = 'Close']
    ${request_id}=    Parse Request Id    ${response text}
    ${service_instance_id}=    Parse Instance Id     ${response text}
    Poll MSO Get Request    ${GLOBAL_MSO_STATUS_PATH}${request_id}   COMPLETE
    [return]    ${service_instance_id}

Wait For Model
    [Documentation]   Distributed model may not yet be available. Kepp trying until it shows up.
    [Arguments]   ${service_model_type}
    Click Element    partial link=Browse SDC Service
    Page Should Contain Element    xpath=//div/h1[text() = 'Browse SDC Service Models']
    Wait Until Page Contains Element    xpath=//button[text() = 'Deploy']    240s
    Input Text When Enabled    //input[@ng-model='searchString']    ${service_model_type}
    Wait Until Element Is Visible    xpath=//tr[td/span/text() = '${service_model_type}']/td/button[contains(text(),'Deploy')]    10s

Delete Service Instance By GUI
    [Arguments]    ${service_instance_id}    ${customer_name}
    Click On Element When Visible    xpath=//a/span[@class='glyphicon glyphicon-remove']
    Click On Button When Visible    xpath=//div[@class='buttonRow']/button[@ngx-enabled='true']
    Wait Until Element Contains    xpath=//div[@ng-controller='deletionDialogController']//div[@ng-controller= 'msoCommitController']/pre[@class = 'log ng-binding']   requestId    timeout=120s
    ${response text}=    Get Text    xpath=//div[@ng-controller='deletionDialogController']//div[@ng-controller= 'msoCommitController']/pre[@class = 'log ng-binding']
    ${request_id}=    Parse Request Id     ${response text}
    Poll MSO Get Request    ${GLOBAL_MSO_STATUS_PATH}${request_id}   COMPLETE


Search Service Instance
    [Arguments]    ${service_instance_id}    ${customer_name}
    Click Link       xpath=//div[@heading = 'Search for Existing Service Instances']/a
    Input Text When Enabled    //input[@name='selectedServiceInstance']    ${service_instance_id}
    Click On Button When Enabled    //button[text() = 'Submit']
