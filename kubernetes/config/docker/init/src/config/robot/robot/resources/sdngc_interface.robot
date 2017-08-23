*** Settings ***
Documentation     The main interface for interacting with SDN-GC. It handles low level stuff like managing the http request library and SDN-GC required fields
Library 	      RequestsLibrary
Library	          UUID      
Library    OperatingSystem
Library 	    ExtendedSelenium2Library
Library         Collections
Library      String
Library      StringTemplater
Resource          global_properties.robot
Resource          ../resources/json_templater.robot
Resource        browser_setup.robot

Variables    ../assets/service_mappings.py

*** Variables ***
${PRELOAD_VNF_TOPOLOGY_OPERATION_PATH}  /operations/VNF-API:preload-vnf-topology-operation
${PRELOAD_VNF_CONFIG_PATH}  /config/VNF-API:preload-vnfs/vnf-preload-list
${PRELOAD_VNF_TOPOLOGY_OPERATION_BODY}  robot/assets/templates/sdnc/
${SDNGC_INDEX_PATH}    /restconf
${SDNCGC_HEALTHCHECK_OPERATION_PATH}  /operations/SLI-API:healthcheck
${SDNGC_REST_ENDPOINT}    ${GLOBAL_SDNGC_SERVER_PROTOCOL}://${GLOBAL_INJECTED_SDNC_IP_ADDR}:${GLOBAL_SDNGC_REST_PORT}
${SDNGC_ADMIN_ENDPOINT}    ${GLOBAL_SDNGC_SERVER_PROTOCOL}://${GLOBAL_INJECTED_SDNC_PORTAL_IP_ADDR}:${GLOBAL_SDNGC_ADMIN_PORT}
${SDNGC_ADMIN_SIGNUP_URL}    ${SDNGC_ADMIN_ENDPOINT}/signup
${SDNGC_ADMIN_LOGIN_URL}    ${SDNGC_ADMIN_ENDPOINT}/login
${SDNGC_ADMIN_VNF_PROFILE_URL}    ${SDNGC_ADMIN_ENDPOINT}/mobility/getVnfProfile

*** Keywords ***
Run SDNGC Health Check
    [Documentation]    Runs an SDNGC healthcheck
	${resp}=    Run SDNGC Post Request     ${SDNGC_INDEX PATH}${SDNCGC_HEALTHCHECK_OPERATION_PATH}     ${None}
    Should Be Equal As Strings 	${resp.status_code} 	200
    Should Be Equal As Strings 	${resp.json()['output']['response-code']} 	200   

Run SDNGC Get Request
    [Documentation]    Runs an SDNGC get request
    [Arguments]    ${data_path}
    ${auth}=  Create List  ${GLOBAL_SDNGC_USERNAME}    ${GLOBAL_SDNGC_PASSWORD}
    Log    Creating session ${SDNGC_REST_ENDPOINT}
    ${session}=    Create Session 	sdngc 	${SDNGC_REST_ENDPOINT}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Get Request 	sdngc 	${data_path}     headers=${headers}
    Log    Received response from sdngc ${resp.text}
    [Return]    ${resp}
    
Run SDNGC Put Request
    [Documentation]    Runs an SDNGC put request
    [Arguments]    ${data_path}    ${data}
    ${auth}=  Create List  ${GLOBAL_SDNGC_USERNAME}    ${GLOBAL_SDNGC_PASSWORD}
    Log    Creating session ${SDNGC_REST_ENDPOINT}
    ${session}=    Create Session 	sdngc 	${SDNGC_REST_ENDPOINT}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Put Request 	sdngc 	${data_path}     data=${data}    headers=${headers}
    Log    Received response from sdngc ${resp.text}
    [Return]    ${resp}

Run SDNGC Post Request
    [Documentation]    Runs an SDNGC post request
    [Arguments]    ${data_path}    ${data}
    ${auth}=  Create List  ${GLOBAL_SDNGC_USERNAME}    ${GLOBAL_SDNGC_PASSWORD}
    Log    Creating session ${SDNGC_REST_ENDPOINT}
    ${session}=    Create Session 	sdngc 	${SDNGC_REST_ENDPOINT}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Post Request 	sdngc 	${data_path}     data=${data}    headers=${headers}
    Log    Received response from sdngc ${resp.text}
    [Return]    ${resp} 
  
Run SDNGC Delete Request
    [Documentation]    Runs an SDNGC delete request
    [Arguments]    ${data_path}
    ${auth}=  Create List  ${GLOBAL_SDNGC_USERNAME}    ${GLOBAL_SDNGC_PASSWORD}
    Log    Creating session ${SDNGC_REST_ENDPOINT}
    ${session}=    Create Session 	sdngc 	${SDNGC_REST_ENDPOINT}    auth=${auth}
    ${uuid}=    Generate UUID
    ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    X-TransactionId=${GLOBAL_APPLICATION_ID}-${uuid}    X-FromAppId=${GLOBAL_APPLICATION_ID}
    ${resp}= 	Delete Request 	sdngc 	${data_path}        headers=${headers}
    Log    Received response from sdngc ${resp.text}
    [Return]    ${resp}


Preload Vnf
    [Arguments]    ${service_type_uuid}    ${generic_vnf_name}    ${generic_vnf_type}     ${vf_module_name}    ${vf_modules}    ${service}   ${uuid}
    ${base_vf_module_type}=    Catenate    ''
    ${closedloop_vf_module}=    Create Dictionary
    ${templates}=    Get From Dictionary    ${GLOBAL_SERVICE_TEMPLATE_MAPPING}    ${service}
    :for    ${vf_module}    in      @{vf_modules}
    \       ${vf_module_type}=    Get From Dictionary    ${vf_module}    name
    \       ${dict}   Get From Mapping    ${templates}    ${vf_module}
    \       ${filename}=    Get From Dictionary    ${dict}    template
    \       ${base_vf_module_type}=   Set Variable If    '${dict['isBase']}' == 'true'     ${vf_module_type}    ${base_vf_module_type}
    \       ${closedloop_vf_module}=   Set Variable If    '${dict['isBase']}' == 'false'     ${vf_module}    ${closedloop_vf_module}
    \       ${vf_name}=     Update Module Name    ${dict}    ${vf_module_name}  
    \       Preload Vnf Profile    ${vf_module_type}     
    \       Preload One Vnf Topology    ${service_type_uuid}    ${generic_vnf_name}    ${generic_vnf_type}     ${vf_name}    ${vf_module_type}    ${service}    ${filename}   ${uuid}
    [Return]    ${base_vf_module_type}   ${closedloop_vf_module}    


Update Module Name
    [Arguments]    ${dict}    ${vf_module_name}
    Return From Keyword If    'prefix' not in ${dict}    ${vf_module_name}
    Return From Keyword If    '${dict['prefix']}' == ''    ${vf_module_name}
    ${name}=    Replace String   ${vf_module_name}   Vfmodule_    ${dict['prefix']} 
    [Return]    ${name}           

Get From Mapping
    [Documentation]    Retrieve the appropriate prelad template entry for the passed vf_module    
    [Arguments]    ${templates}    ${vf_module}
    ${vf_module_name}=    Get From DIctionary    ${vf_module}    name
    :for    ${template}   in   @{templates} 
    \    Return From Keyword If    '${template['name_pattern']}' in '${vf_module_name}'     ${template}    
    [Return]    None
    
            
Preload One Vnf Topology
    [Arguments]    ${service_type_uuid}    ${generic_vnf_name}    ${generic_vnf_type}       ${vf_module_name}    ${vf_module_type}    ${service}    ${filename}   ${uuid}
    Return From Keyword If    '${filename}' == ''
    ${data_template}=    OperatingSystem.Get File    ${PRELOAD_VNF_TOPOLOGY_OPERATION_BODY}/${filename}
    ${parameters}=    Get Template Parameters    ${filename}   ${uuid}
    Set To Dictionary   ${parameters}   generic_vnf_name=${generic_vnf_name}     generic_vnf_type=${generic_vnf_type}  service_type=${service_type_uuid}    vf_module_name=${vf_module_name}    vf_module_type=${vf_module_type}    uuid=${uuid}
    ${data}=	Fill JSON Template    ${data_template}    ${parameters}        
	${put_resp}=    Run SDNGC Post Request     ${SDNGC_INDEX_PATH}${PRELOAD_VNF_TOPOLOGY_OPERATION_PATH}     ${data}
    Should Be Equal As Strings 	${put_resp.json()['output']['response-code']} 	200   
    ${get_resp}=  Run SDNGC Get Request  ${SDNGC_INDEX_PATH}${PRELOAD_VNF_CONFIG_PATH}/${vf_module_name}/${vf_module_type}
    Should Be Equal As Strings 	${get_resp.status_code} 	200

Get Template Parameters
    [Arguments]    ${template}    ${uuid}
    ${rest}   ${suite}=    Split String From Right    ${SUITE NAME}   .   1
    ${uuid}=    Catenate    ${uuid}
    ${hostid}=    Get Substring    ${uuid}    -4
    ${ecompnet}=    Evaluate    ${GLOBAL_BUILD_NUMBER}%255
    # Initialize the value map with the properties generated from the Robot VM /opt/config folder
    ${valuemap}=   Create Dictionary
    Set To Dictionary   ${valuemap}   artifacts_version=${GLOBAL_INJECTED_ARTIFACTS_VERSION}
    Set To Dictionary   ${valuemap}   network=${GLOBAL_INJECTED_NETWORK} 
    # update the value map with unique values.
    Set To Dictionary   ${valuemap}   uuid=${uuid}   hostid=${hostid}    ecompnet=${ecompnet}
    ${parameters}=    Create Dictionary
    ${defaults}=    Get From Dictionary    ${GLOBAL_PRELOAD_PARAMETERS}    defaults
    Resolve Values Into Dictionary   ${valuemap}   ${defaults}    ${parameters}
    ${suite_templates}=    Get From Dictionary    ${GLOBAL_PRELOAD_PARAMETERS}    ${suite}
    ${template}=    Get From Dictionary    ${suite_templates}    ${template}
    Resolve Values Into Dictionary   ${valuemap}   ${template}    ${parameters}
    [Return]    ${parameters}
   
Resolve Values Into Dictionary    
    [Arguments]   ${valuemap}    ${from}    ${to}
    ${keys}=    Get Dictionary Keys    ${from}
    :for   ${key}   in  @{keys}
    \    ${value}=    Get From Dictionary    ${from}   ${key}
    \    ${value}=    Template String    ${value}    ${valuemap}
    \    Set To Dictionary    ${to}    ${key}    ${value}
     
Preload Vnf Profile
    [Arguments]    ${vnf_name}
    Login To SDNGC Admin GUI
    Go To    ${SDNGC_ADMIN_VNF_PROFILE_URL}
    Click Button    xpath=//button[@data-target='#add_vnf_profile']
    Input Text    xpath=//input[@id='nf_vnf_type']    ${vnf_name}
    Input Text    xpath=//input[@id='nf_availability_zone_count']    999
    Input Text    xpath=//input[@id='nf_equipment_role']    robot-ete-test
    Click Button    xpath=//button[contains(.,'Submit')]
    Page Should Contain  VNF Profile 
    Input Text    xpath=//div[@id='vnf_profile_filter']//input    ${vnf_name}
    Page Should Contain  ${vnf_name}  

Delete Vnf Profile
    [Arguments]    ${vnf_name}
    Login To SDNGC Admin GUI
    Go To    ${SDNGC_ADMIN_VNF_PROFILE_URL}
    Page Should Contain  VNF Profile 
    Input Text    xpath=//div[@id='vnf_profile_filter']//input    ${vnf_name}
    Page Should Contain  ${vnf_name}
    Click Button    xpath=//button[contains(@onclick, '${vnf_name}')]    
    Page Should Contain    Are you sure you want to delete VNF_PROFILE
    Click Button    xpath=//button[contains(text(), 'Yes')]
    Page Should Not Contain  ${vnf_name}
        
Login To SDNGC Admin GUI
    [Documentation]   Login To SDNGC Admin GUI
    ## Setup Browser is now being managed by the test case 
    ## Setup Browser
    Go To    ${SDNGC_ADMIN_SIGNUP_URL}
    Maximize Browser Window
    Set Selenium Speed    ${GLOBAL_SELENIUM_DELAY}
    Set Browser Implicit Wait    ${GLOBAL_SELENIUM_BROWSER_IMPLICIT_WAIT}
    Log    Logging in to ${SDNGC_ADMIN_LOGIN_URL}
    Handle Proxy Warning
    Title Should Be    AdminPortal
    ${uuid}=    Generate UUID  
    ${shortened_uuid}=     Evaluate    str("${uuid}")[:12]
    ${email}=        Catenate    ${shortened_uuid}@robotete.com
    Input Text    xpath=//input[@id='nf_email']    ${email}
    Input Password    xpath=//input[@id='nf_password']    ${shortened_uuid}
    Click Button    xpath=//button[@type='submit']
    Wait Until Page Contains    User created   20s
    Go To    ${SDNGC_ADMIN_LOGIN_URL}
    Input Text    xpath=//input[@id='email']    ${email}
    Input Password    xpath=//input[@id='password']    ${shortened_uuid}
    Click Button    xpath=//button[@type='submit']
    Title Should Be    SDN-C AdminPortal
    Log    Logged in to ${SDNGC_ADMIN_LOGIN_URL}
