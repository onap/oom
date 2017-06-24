*** Settings ***
Documentation	  This test template encapsulates the VNF Orchestration use case.

Resource        test_templates/model_test_template.robot
Resource        test_templates/vnf_orchestration_test_template.robot
Resource        asdc_interface.robot

Library	        UUID
Library	        Collections
Library         OperatingSystem
Library         HttpLibrary.HTTP
Library         ExtendedSelenium2Library
Library         RequestsLibrary

*** Variables ***

${ADD_DEMO_CUSTOMER_BODY}   robot/assets/templates/aai/add_demo_customer.template
${AAI_INDEX_PATH}     /aai/v8
${VF_MODULES_NAME}     _Demo_VFModules.json
${FILE_CACHE}    /share/

*** Keywords ***
Load Customer And Models
    [Documentation]   Use openECOMP to Orchestrate a service.
    [Arguments]    ${customer_name}
    Load Customer  ${customer_name}
    Load Models  ${customer_name}

Load Customer
    [Documentation]   Use openECOMP to Orchestrate a service.
    [Arguments]    ${customer_name}
    Setup Orchestrate VNF   ${GLOBAL_AAI_CLOUD_OWNER}   SharedNode    OwnerType    v1    CloudZone
    Set Test Variable    ${CUSTOMER_NAME}    ${customer_name}
    ${region}=   Get Openstack Region
    Create Customer For VNF Demo    ${CUSTOMER_NAME}    ${CUSTOMER_NAME}    INFRA    ${GLOBAL_AAI_CLOUD_OWNER}    ${region}   ${TENANT_ID}

Load Models
    [Documentation]   Use openECOMP to Orchestrate a service.
    [Arguments]    ${customer_name}
    Set Test Variable    ${CUSTOMER_NAME}    ${customer_name}
    ${status}   ${value}=   Run Keyword And Ignore Error   Distribute Model   vFW   demoVFW
    ${status}   ${value}=   Run Keyword And Ignore Error   Distribute Model   vLB   demoVLB

Distribute Model
    [Arguments]   ${service}   ${modelName}
    ${service_model_type}     ${vnf_type}    ${vf_modules}=   Model Distribution For Directory    ${service}   ${modelName}

Create Customer For VNF Demo
    [Documentation]    Create demo customer for the demo
    [Arguments]    ${customer_name}   ${customer_id}   ${customer_type}    ${clouder_owner}    ${cloud_region_id}    ${tenant_id}
    ${data_template}=    OperatingSystem.Get File    ${ADD_DEMO_CUSTOMER_BODY}
    ${arguments}=    Create Dictionary    subscriber_name=${customer_name}    global_customer_id=${customer_id}    subscriber_type=${customer_type}     cloud_owner=${clouder_owner}  cloud_region_id=${cloud_region_id}    tenant_id=${tenant_id}
    Set To Dictionary   ${arguments}       service1=vFW       service2=vLB
    ${data}=	Fill JSON Template    ${data_template}    ${arguments}
	${put_resp}=    Run A&AI Put Request     ${INDEX PATH}${ROOT_CUSTOMER_PATH}${customer_id}    ${data}
    ${status_string}=    Convert To String    ${put_resp.status_code}
    Should Match Regexp    ${status_string}    ^(201|412)$
    Create Service If Not Exists    vFW
    Create Service If Not Exists    vLB

Preload User Model
    [Documentation]   Preload the demo data for the passed VNF with the passed module name
    [Arguments]   ${vnf_name}   ${vf_module_name}
    # Go to A&AI and get information about the VNF we need to preload
    ${status}  ${generic_vnf}=   Run Keyword And Ignore Error   Get Service Instance    ${vnf_name}
    Run Keyword If   '${status}' == 'FAIL'   FAIL   VNF Name: ${vnf_name} is not found.
    ${vnf_type}=   Set Variable   ${generic_vnf['vnf-type']}
    ${relationships}=   Set Variable   ${generic_vnf['relationship-list']['relationship']}
    ${relationship_data}=    Get Relationship Data   ${relationships}
    ${customer_id}=   Catenate
    :for    ${r}   in   @{relationship_data}
    \   ${service}=   Set Variable If    '${r['relationship-key']}' == 'service-subscription.service-type'   ${r['relationship-value']}    ${service}
    \   ${service_instance_id}=   Set Variable If    '${r['relationship-key']}' == 'service-instance.service-instance-id'   ${r['relationship-value']}   ${service_instance_id}
    \   ${customer_id}=    Set Variable If   '${r['relationship-key']}' == 'customer.global-customer-id'   ${r['relationship-value']}   ${customer_id}
    ${invariantUUID}=   Get Persona Model Id     ${service_instance_id}    ${service}    ${customer_id}

    # We still need the vf module names. We can get them from VID using the persona_model_id (invariantUUID) from A&AI
    Setup Browser
    Login To VID GUI
    ${vf_modules}=   Get Module Names from VID    ${invariantUUID}
    Log    ${generic_vnf}
    Log   ${service_instance_id},${vnf_name},${vnf_type},${vf_module_name},${vf_modules},${service}
    Preload Vnf    ${service_instance_id}   ${vnf_name}   ${vnf_type}   ${vf_module_name}    ${vf_modules}    ${service}    demo
    [Teardown]    Close All Browsers


Get Relationship Data
    [Arguments]   ${relationships}
    :for    ${r}   in   @{relationships}
    \     ${status}   ${relationship_data}   Run Keyword And Ignore Error    Set Variable   ${r['relationship-data']}
    \     Return From Keyword If    '${status}' == 'PASS'   ${relationship_data}


Get Service Instance
    [Arguments]   ${vnf_name}
    ${resp}=    Run A&AI Get Request      ${AAI_INDEX PATH}/network/generic-vnfs/generic-vnf?vnf-name=${vnf_name}
    Should Be Equal As Strings 	${resp.status_code} 	200
    [Return]   ${resp.json()}

Get Persona Model Id
    [Documentation]    Query and Validates A&AI Service Instance
    [Arguments]    ${service_instance_id}    ${service_type}   ${customer_id}
	${resp}=    Run A&AI Get Request      ${INDEX PATH}${CUSTOMER SPEC PATH}${customer_id}${SERVICE SUBSCRIPTIONS}${service_type}${SERVICE INSTANCE}${service_instance_id}
    ${persona_model_id}=   Get From DIctionary   ${resp.json()['service-instance'][0]}    persona-model-id
    [Return]   ${persona_model_id}


Get Model UUID from VID
    [Documentation]    Must use UI since rest call get redirect to portal and get DNS error
    ...    Search all services and match on the invariantUUID
    [Arguments]   ${invariantUUID}
    Go To     ${GLOBAL_VID_SERVER}${VID_ENV}/rest/models/services
    ${resp}=   Get Text   xpath=//body/pre
    ${json}=   To Json    ${resp}
    :for   ${dict}  in  @{json}
    \    ${uuid}=   Get From DIctionary   ${dict}   uuid
    \    ${inv}=   Get From DIctionary   ${dict}    invariantUUID
    \    Return From Keyword If   "${invariantUUID}" == "${inv}"   ${uuid}
    [Return]    ""


Get Module Names from VID
    [Documentation]    Must use UI since rest call get redirect to portal and get DNS error
    ...    Given the invariantUUID of the model, mock up the vf_modules list passed to Preload VNF
    [Arguments]   ${invariantUUID}
    ${id}=   Get Model UUID from VID    ${invariantUUID}
    Go To     ${GLOBAL_VID_SERVER}${VID_ENV}/rest/models/services/${id}
    ${resp}=   Get Text   xpath=//body/pre
    ${json}=   To Json    ${resp}
    ${modules}=   Create List
    ${vnfs}=   Get From Dictionary    ${json}   vnfs
    ${keys}=   Get Dictionary Keys    ${vnfs}
    :for   ${key}  in  @{keys}
    \    Add VFModule   ${vnfs['${key}']}   ${modules}
    [Return]    ${modules}

Add VFModule
    [Documentation]   Dig the vf module names from the VID service model
    [Arguments]   ${vnf}   ${modules}
    ${vfModules}=   Get From Dictionary    ${vnf}   vfModules
    ${keys}=   Get Dictionary Keys    ${vfModules}
    :for   ${key}  in  @{keys}
    \    ${module}=   Get From Dictionary    ${vfModules}   ${key}
    \    ${dict}=    Create Dictionary   name=${module['name']}
    \    Append to List   ${modules}   ${dict}






APPC Mount Point
    [Arguments]   ${vf_module_name}
    Run Openstack Auth Request    auth
    ${status}   ${stack_info}=   Run Keyword and Ignore Error    Wait for Stack to Be Deployed    auth    ${vf_module_name}   timeout=120s
    Run Keyword if   '${status}' == 'FAIL'   FAIL   ${vf_module_name} Stack is not found
    ${stack_id}=    Get From Dictionary    ${stack_info}    id
    ${server_list}=    Get Openstack Servers    auth
    ${vpg_name_0}=    Get From Dictionary    ${stack_info}    vpg_name_0
    ${vpg_public_ip}=    Get Server Ip    ${server_list}    ${stack_info}   vpg_name_0    network_name=public
    ${vpg_oam_ip}=    Get From Dictionary    ${stack_info}    vpg_private_ip_1
    ${appc}=    Create Mount Point In APPC    ${vpg_name_0}    ${vpg_oam_ip}

Instantiate VNF
    [Arguments]   ${service}
    Setup Orchestrate VNF    ${GLOBAL_AAI_CLOUD_OWNER}    SharedNode    OwnerType    v1    CloudZone
    ${vf_module_name}    ${service}=    Orchestrate VNF    DemoCust    ${service}   ${service}    ${TENANT_NAME}
    Save For Delete
    Log to Console   Customer Name=${CUSTOMER_NAME}
    Log to Console   VNF Module Name=${vf_module_name}

Save For Delete
    [Documentation]   Create a variable file to be loaded for save for delete
    ${dict}=    Create Dictionary
    Set To Dictionary   ${dict}   TENANT_NAME=${TENANT_NAME}
    Set To Dictionary   ${dict}   TENANT_ID=${TENANT_ID}
    Set To Dictionary   ${dict}   CUSTOMER_NAME=${CUSTOMER_NAME}
    Set To Dictionary   ${dict}   STACK_NAME=${STACK_NAME}
    Set To Dictionary   ${dict}   SERVICE=${SERVICE}
    Set To Dictionary   ${dict}   VVG_SERVER_ID=${VVG_SERVER_ID}
    Set To Dictionary   ${dict}   SERVICE_INSTANCE_ID=${SERVICE_INSTANCE_ID}

    Set To Dictionary   ${dict}   VLB_CLOSED_LOOP_DELETE=${VLB_CLOSED_LOOP_DELETE}
    Set To Dictionary   ${dict}   VLB_CLOSED_LOOP_VNF_ID=${VLB_CLOSED_LOOP_VNF_ID}

    Set To Dictionary   ${dict}   CATALOG_SERVICE_ID=${CATALOG_SERVICE_ID}

    ${vars}=    Catenate
    ${keys}=   Get Dictionary Keys    ${dict}
    :for   ${key}   in   @{keys}
    \    ${value}=   Get From Dictionary   ${dict}   ${key}
    \    ${vars}=   Catenate   ${vars}${key} = "${value}"\n

    ${comma}=   Catenate
    ${vars}=    Catenate   ${vars}CATALOG_RESOURCE_IDS = [
    :for   ${id}   in    @{CATALOG_RESOURCE_IDS}
    \    ${vars}=    Catenate  ${vars}${comma} "${id}"
    \    ${comma}=   Catenate   ,
    ${vars}=    Catenate  ${vars}]\n
    OperatingSystem.Create File   ${FILE_CACHE}/${STACK_NAME}.py   ${vars}


