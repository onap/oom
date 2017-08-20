*** Settings ***
Documentation	  Creates VID VNF Instance

Library    ExtendedSelenium2Library    60
Library	        UUID
Library         String
Library        DateTime
Library 	      RequestsLibrary

Resource          ../mso_interface.robot
Resource          vid_interface.robot

*** Keywords ***

Create VID VNF
    [Documentation]    Creates a VNF instance using VID for passed instance id with the passed service instance name
    [Arguments]    ${service_instance_id}    ${service_instance_name}    ${product_family}    ${lcp_region}    ${tenant}   ${vnf_type}
    Go To VID HOME
    Click Link       xpath=//div[@heading = 'Search for Existing Service Instances']/a
    Wait Until Page Contains    Please search by    timeout=60s
    #Wait Until Page Contains Element    xpath=//div[@class='statusLine aaiHidden']    timeout=60s
    #Wait Until Element Is Not Visible    xpath=//div[@class='statusLine aaiHidden']    timeout=60s

    # If we don't wait for this control to be enabled, the submit results in a 'not found' pop-up (UnexpectedAlertPresentException)
    Input Text When Enabled    //input[@name='selectedServiceInstance']    ${service_instance_id}
    Click Button    button=Submit
    Wait Until Page Contains Element    link=View/Edit    timeout=60s
    Click Element     xpath=//a[contains(text(), 'View/Edit')]
    Wait Until Page Contains    View/Edit Service Instance     timeout=60s
    #Wait Until Page Contains Element    xpath=//div[@class='statusLine aaiVisible']    timeout=120s
    #Wait Until Element Is Not Visible    xpath=//div[@class='statusLine aaiVisible']    timeout=60s
    Click Element    button=Add VNF

    # This is where firefox breaks. Th elink never becomes visible when run with the script.
    Click Element    link=${vnf_type}
    Wait Until Page Contains Element    xpath=//input[@parameter-id='instanceName']    20s
    Wait Until Element Is Enabled    xpath=//input[@parameter-id='instanceName']    20s

    ## Without this sleep, the input text below gets immediately wiped out.
    ## Wait Until Angular Ready just sleeps for its timeout value
    Sleep    10s
    Input Text 	  xpath=//input[@parameter-id='instanceName']    ${service_instance_name}
    Select From List By Label     xpath=//select[@parameter-id='productFamily']    ${product_family}
    Select From List By Label    xpath=//select[@parameter-id='lcpRegion']    ${lcp_region}
    Select From List By Label    xpath=//select[@parameter-id='tenant']    ${tenant}
    Click Element    button=Confirm
 	Wait Until Element Contains    xpath=//div[@ng-controller= 'msoCommitController']/pre[@class = 'log ng-binding']    Status: OK (200)    timeout=120
    ${response text}=    Get Text    xpath=//div[@ng-controller= 'msoCommitController']/pre[@class = 'log ng-binding']
 	Should Not Contain    ${response text}    FAILED
    Click Element    button=Close
    ${instance_id}=    Parse Instance Id     ${response text}
    Wait Until Page Contains    ${service_instance_name}    60s
    [Return]     ${instance_id}

Delete VID VNF
    [Arguments]    ${service_instance_id}    ${lcp_region}    ${tenant}    ${vnf_instance_id}
    Go To VID HOME
    Click Link       xpath=//div[@heading = 'Search for Existing Service Instances']/a
    Wait Until Page Contains    Please search by    timeout=60s
    Wait Until Page Contains Element    xpath=//div[@class='statusLine aaiHidden']    timeout=60s
    Wait Until Element Is Not Visible    xpath=//div[@class='statusLine aaiHidden']    timeout=60s

    # If we don't wait for this control to be enabled, the submit results in a 'not found' pop-up (UnexpectedAlertPresentException)
    Input Text When Enabled    //input[@name='selectedServiceInstance']    ${service_instance_id}
    Click Button    button=Submit
    Wait Until Page Contains Element    link=View/Edit    timeout=60s
    Click Element     link=View/Edit
    Wait Until Page Contains    View/Edit Service Instance     timeout=60s
    Wait Until Page Contains Element    xpath=//div[@class='statusLine']    timeout=120s
    Wait Until Element Is Not Visible    xpath=//div[@class='statusLine aaiHidden']    timeout=60s



    Click On Element When Visible    xpath=//li/div[contains(.,'${vnf_instance_id}')]/a/span[@class='glyphicon glyphicon-remove']    timeout=120s
    Select From List By Label    xpath=//select[@parameter-id='lcpRegion']    ${lcp_region}
    Select From List By Label    xpath=//select[@parameter-id='tenant']    ${tenant}
    Click Element    xpath=//div[@class='buttonRow']/button[@ngx-enabled='true']
    #//*[@id="mContent"]/div/div/div/div/table/tbody/tr/td/div/div[2]/div/div[1]/div[5]/button[1]

    ${response text}=    Get Text    xpath=//div[@ng-controller='deletionDialogController']//div[@ng-controller= 'msoCommitController']/pre[@class = 'log ng-binding']
    ${request_id}=    Parse Request Id     ${response text}
    Poll MSO Get Request    ${GLOBAL_MSO_STATUS_PATH}${request_id}   COMPLETE

Create VID VNF module
    [Arguments]    ${service_instance_id}    ${vf_module_name}    ${lcp_region}    ${TENANT}    ${VNF_TYPE}
    Go To VID HOME
    Click Link       xpath=//div[@heading = 'Search for Existing Service Instances']/a
    Wait Until Page Contains    Please search by    timeout=60s
    Wait Until Page Contains Element    xpath=//div[@class='statusLine aaiHidden']    timeout=60s

     # If we don't wait for this control to be enabled, the submit results in a 'not found' pop-up (UnexpectedAlertPresentException)
    Input Text When Enabled    //input[@name='selectedServiceInstance']    ${service_instance_id}
    Click Button    button=Submit
    Wait Until Page Contains Element    link=View/Edit    timeout=60s
    Click Element     link=View/Edit
    Wait Until Page Contains    View/Edit Service Instance     timeout=60s
    Wait Until Page Contains Element    xpath=//div[@class='statusLine']    timeout=120s
    Wait Until Element Is Not Visible    xpath=//div[@class='statusLine aaiHidden']    timeout=120s
    Wait Until Element Is Visible    button=Add VF-Module   timeout=120s
    Click Element    button=Add VF-Module

    # This is where firefox breaks. Th elink never becomes visible when run with the script.
    Click Element    link=${vnf_type}
    Wait Until Page Contains Element    xpath=//input[@parameter-id='instanceName']    20s
    Wait Until Element Is Enabled    xpath=//input[@parameter-id='instanceName']    20s

    ## Without this sleep, the input text below gets immediately wiped out.
    ## Wait Until Angular Ready just sleeps for its timeout value
    Sleep    10s
    Input Text 	  xpath=//input[@parameter-id='instanceName']    ${vf_module_name}
    Select From List By Label    xpath=//select[@parameter-id='lcpRegion']    ${lcp_region}
    Select From List By Label    xpath=//select[@parameter-id='tenant']    ${tenant}
    Click Element    button=Confirm
 	Wait Until Element Contains    xpath=//div[@ng-controller= 'msoCommitController']/pre[@class = 'log ng-binding']    requestId    timeout=120
    ${response text}=    Get Text    xpath=//div[@ng-controller= 'msoCommitController']/pre[@class = 'log ng-binding']
    Click Element    button=Close
    ${instance_id}=    Parse Instance Id     ${response text}

    ${request_id}=    Parse Request Id     ${response text}
    Poll MSO Get Request    ${GLOBAL_MSO_STATUS_PATH}${request_id}   COMPLETE

    [Return]     ${instance_id}