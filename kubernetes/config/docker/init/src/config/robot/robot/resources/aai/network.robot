*** Settings ***
Documentation	  Validate A&AI Serivce Instance
...
...	              Validate A&AI Serivce Instance

Resource          aai_interface.robot
Library    Collections
Library    OperatingSystem
Library    RequestsLibrary
Library    JSONUtils
Library    HttpLibrary.HTTP

Resource          ../json_templater.robot

*** Variables ***
${INDEX PATH}     /aai/v8
${GENERIC_QUERY_PATH}  /search/generic-query?
${SYSTEM USER}    robot-ete
${CUSTOMER SPEC PATH}    /business/customers/customer/
${SERVICE SUBSCRIPTIONS}    /service-subscriptions/service-subscription/
${SERVICE INSTANCE}    /service-instances?service-instance-name=
${SERVCE INSTANCE TEMPLATE}    robot/assets/templates/aai/service_subscription.template    

*** Keywords ***    
Validate Network
    [Documentation]    Query and Validates A&AI Service Instance	
    [Arguments]    ${service_instance_name}    ${service_type}  ${customer_id}   
	${resp}=    Run A&AI Get Request      ${INDEX PATH}${CUSTOMER SPEC PATH}${CUSTOMER ID}${SERVICE SUBSCRIPTIONS}${service_type}${SERVICE INSTANCE}${service_instance_name}
    Dictionary Should Contain Value	${resp.json()['service-instance'][0]}    ${service_instance_name}
	   
	

*** Keywords ***    
Create Network
    [Documentation]    Query and Validates A&AI Service Instance	
    [Arguments]    ${CUSTOMER ID}    
    ${json_string}=    Catenate     { "service-type": "VDNS" , "service-subscriptions":[{"service-instance-id":"instanceid123","service-instance-name":"VDNS"}]}
	${put_resp}=    Run A&AI Put Request     ${INDEX PATH}${CUSTOMER SPEC PATH}${CUSTOMER ID}${SERVICE SUBSCRIPTIONS}/VDNS    ${json_string}
    Should Be Equal As Strings 	${put_resp.status_code} 	201
	[Return]  ${put_resp.status_code}	
	
	