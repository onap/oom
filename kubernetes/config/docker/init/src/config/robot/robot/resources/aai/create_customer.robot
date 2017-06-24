*** Settings ***
Documentation	  Create A&AI Customer API.
...
...	              Create A&AI Customer API

Resource   aai_interface.robot
Resource   ../json_templater.robot
Library    Collections
Library    OperatingSystem


*** Variables ***
${INDEX PATH}     /aai/v8 
${ROOT_CUSTOMER_PATH}  /business/customers/customer/
${SYSTEM USER}    robot-ete
${A&AI ADD CUSTOMER BODY}    robot/assets/templates/aai/add_customer.template

*** Keywords ***    
Create Customer
    [Documentation]    Creates a customer in A&AI	
    [Arguments]    ${customer_name}  ${customer_id}  ${customer_type}    ${service_type}      ${clouder_owner}    ${cloud_region_id}    ${tenant_id}  
    ${data_template}=    OperatingSystem.Get File    ${A&AI ADD CUSTOMER BODY}  
    ${arguments}=    Create Dictionary    subscriber_name=${customer_name}    global_customer_id=${customer_id}    subscriber_type=${customer_type}     cloud_owner1=${clouder_owner}  cloud_region_id1=${cloud_region_id}    tenant_id1=${tenant_id}    service1=${service_type}       
    ${data}=	Fill JSON Template    ${data_template}    ${arguments}         
	${put_resp}=    Run A&AI Put Request     ${INDEX PATH}${ROOT_CUSTOMER_PATH}${customer_id}    ${data}
    Should Be Equal As Strings 	${put_resp.status_code} 	201
	[Return]  ${put_resp.status_code}

*** Keywords ***    
Delete Customer
    [Documentation]    Deletes a customer in A&AI	
    [Arguments]    ${customer_id}
    ${get_resp}=    Run A&AI Get Request     ${INDEX PATH}${ROOT_CUSTOMER_PATH}${customer_id}    
	Run Keyword If    '${get_resp.status_code}' == '200'    Delete Customer Exists    ${customer_id}    ${get_resp.json()['resource-version']}
	   
*** Keywords ***    
Delete Customer Exists
    [Documentation]    Deletes a customer in A&AI	
    [Arguments]    ${customer_id}    ${resource_version_id}   
    ${put_resp}=    Run A&AI Delete Request    ${INDEX PATH}${ROOT_CUSTOMER_PATH}${customer_id}    ${resource_version_id}
    Should Be Equal As Strings 	${put_resp.status_code} 	204  
