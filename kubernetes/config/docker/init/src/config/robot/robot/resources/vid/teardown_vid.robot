*** Settings ***
Documentation     The main interface for interacting with VID. It handles low level stuff like managing the selenium request library and VID required steps
Library 	    ExtendedSelenium2Library
Library            Collections
Library         String
Library 	      StringTemplater
Library	          UUID      
Resource        vid_interface.robot
Resource        create_vid_vnf.robot
Resource        create_service_instance.robot

*** Variables ***
${VID_ENV}            /vid
${VID_SERVICE_MODELS_SEARCH_CUST}  ${GLOBAL_VID_SERVER}${VID_ENV}/serviceModels.htm#/instances/subdetails?selectedSubscriber=\${customer_id}
${VID_SERVICE_MODELS_SEARCH_URL}  ${GLOBAL_VID_SERVER}${VID_ENV}/serviceModels.htm#/instances/services
*** Keywords ***
    
Teardown VID 
    [Documentation]   Teardown the VID This assumes that the any runnign stacks have been torn down
    [Arguments]    ${service_instance_id}    ${lcp_region}    ${tenant}  
    Return From Keyword If   len('${service_instance_id}') == 0       
    # Keep going to the VID service instance until we get the pop-up alert that there is no service instance
    Wait Until Keyword Succeeds    300s    1s    Delete VID    ${service_instance_id}    ${lcp_region}    ${tenant}
    

Delete VID   
    [Documentation]    Teardown the next VID entity that has a Remove icon.
    [Arguments]    ${service_instance_id}    ${lcp_region}    ${tenant}
    # For vLB closed loop, we may have 2 vf modules and the vDNS one needs to be removed first.     
    ${remove_order}=    Create List    vDNS_Ete   Vfmodule_Ete
    
    # FAIL status is returned in ${vfmodule} because FAIL are ignored during teardown
    ${status}    ${vfmodule}=   Run Keyword and Ignore Error   Delete Next VID Entity    ${service_instance_id}    ${lcp_region}    ${tenant}   ${remove_order}
    Return From Keyword If    '${status}' == 'FAIL'
    Return From Keyword If    '${vfmodule}' == 'FAIL'
    # After tearing down a VF module, execute the reverse HB for it to remove the references from A&AI
    Run Keyword If   'Vfmodule_Ete' in '${vfmodule}'    Execute Reverse Heatbridge
    Fail    Continue with Next Remove

Delete Next VID Entity  
    [Documentation]    Teardown the next VID entity that has a Remove icon.
    [Arguments]    ${service_instance_id}    ${lcp_region}    ${tenant}   ${remove_order}    
    ${vfmodule}=    Catenate
    Go To    ${VID_SERVICE_MODELS_SEARCH_URL}
    Wait Until Page Contains    Please search by    timeout=60s
    Wait Until Page Contains Element    xpath=//div[@class='statusLine aaiHidden']    timeout=60s
    Wait Until Element Is Not Visible    xpath=//div[@class='statusLine aaiHidden']    timeout=60s
    
    # If we don't wait for this control to be enabled, the submit results in a 'not found' pop-up (UnexpectedAlertPresentException) 
    Input Text When Enabled    //input[@name='selectedServiceInstance']    ${service_instance_id}

    # When Handle alert detects a pop-up. it will return FAIL and we are done
    # Return from Keyword is required because FAIL is inored during teardown
    ${status}   ${value}   Run Keyword And Ignore Error    Handle Alert
    Return From Keyword If   '${status}' == 'FAIL'   ${status}
    ${status}   ${value}   Run Keyword And Ignore Error    Wait Until Page Contains Element    link=View/Edit    timeout=60s
    Return From Keyword If   '${status}' == 'FAIL'   ${status}


    Click Element     link=View/Edit   
    Wait Until Page Contains    View/Edit Service Instance     timeout=60s
    Wait Until Element Is Visible    xpath=//a/span[@class='glyphicon glyphicon-remove']    timeout=120s
    
    :for   ${remove_first}    in    @{remove_order}  
    \    ${remove_xpath}=    Set Variable   //li/div[contains(.,'${remove_first}')]/a/span[@class='glyphicon glyphicon-remove']
    \    ${status}    ${data}=   Run Keyword And Ignore Error    Page Should Contain Element     xpath=${remove_xpath}
    \    Exit For Loop If    '${status}' == 'PASS'   
    \   ${remove_xpath}=    Set Variable   //li/div/a/span[@class='glyphicon glyphicon-remove']
    Click On Element When Visible    xpath=${remove_xpath}    

    ${status}   ${value}=   Run Keyword and Ignore Error   Wait Until Page Contains Element     xpath=//select[@parameter-id='lcpRegion']
    Run Keyword If   '${status}'=='PASS'   Select From List By Label    xpath=//select[@parameter-id='lcpRegion']    ${lcp_region}      
    Run Keyword If   '${status}'=='PASS'   Select From List By Label    xpath=//select[@parameter-id='tenant']    ${tenant}
    ${status}   ${vfmodule}=    Run Keyword And Ignore Error    Get Text    xpath=//td[contains(text(), 'Vf Module Name')]/../td[2]      
    Click Element    xpath=//div[@class='buttonRow']/button[@ngx-enabled='true']
    #//*[@id="mContent"]/div/div/div/div/table/tbody/tr/td/div/div[2]/div/div[1]/div[5]/button[1]
    Wait Until Page Contains    100 %     300s
    ${response text}=    Get Text    xpath=//div[@ng-controller='deletionDialogController']//div[@ng-controller= 'msoCommitController']/pre[@class = 'log ng-binding']
    ${request_id}=    Parse Request Id     ${response text}
    Click Element    xpath=//div[@class='ng-scope']/div[@class = 'buttonRow']/button[text() = 'Close']
    Poll MSO Get Request    ${GLOBAL_MSO_STATUS_PATH}${request_id}   COMPLETE
    [Return]   ${vfmodule}
  
Handle Alert
    [Documentation]   When service instance has been deleted, an alert will be triggered on the search to end the loop
    ...   The various Alert keywords did not prevent the alert exception on the Click ELement, hence this roundabout way of handling the alert
    Run Keyword And Ignore Error    Click Element    button=Submit   
    ${status}   ${t}=    Run Keyword And Ignore Error    Get Alert Message
    Return From Keyword If   '${status}' == 'FAIL'    
    Fail    ${t}
    