*** Settings ***
Documentation     The interface for interacting with Openstack Heat API.
Library           OpenstackLibrary
Library 	      RequestsLibrary
Library	          UUID
Library    OperatingSystem
Library    HEATUtils
Library    StringTemplater
Library    Collections
Resource    ../global_properties.robot
Resource    ../json_templater.robot
Resource    openstack_common.robot

*** Variables ***
${OPENSTACK_HEAT_API_VERSION}    /v1
${OPENSTACK_HEAT_STACK_PATH}    /stacks
${OPENSTACK_HEAT_ADD_STACK_TEMPLATE}    robot/assets/templates/heat_add_stack.template


*** Keywords ***
Get Openstack Stacks
    [Documentation]    Returns the openstack stacks info
    [Arguments]    ${alias}
    ${resp}=    Internal Get Openstack    ${alias}    ${GLOBAL_OPENSTACK_HEAT_SERVICE_TYPE}    ${OPENSTACK_HEAT_STACK_PATH}
    [Return]    ${resp.json()}

Get Openstack Stack
    [Documentation]    Returns the openstack stacks info for the given stack name
    [Arguments]    ${alias}    ${stack_name}
    ${resp}=    Internal Get Openstack    ${alias}    ${GLOBAL_OPENSTACK_HEAT_SERVICE_TYPE}    ${OPENSTACK_HEAT_STACK_PATH}    /${stack_name}
    [Return]    ${resp.json()}

Create Openstack Stack
    [Documentation]    Takes an openstack heat yaml and returns the created stack
    [Arguments]    ${alias}    ${request}
    ${resp}=    Internal Post Openstack    ${alias}    ${GLOBAL_OPENSTACK_HEAT_SERVICE_TYPE}    ${OPENSTACK_HEAT_STACK_PATH}    data_path=    data=${request}
    [Return]    ${resp.json()}

Make Add Stack Request
    [Documentation]    Makes a JSON Add Stack Request from  YAML template and env files
    [Arguments]    ${name}    ${template}    ${env}
    ${templatedata}=    Template Yaml To Json    ${template}
    ${envdata}=    Env Yaml To Json    ${env}
    ${dict}=  Create Dictionary     template=${templatedata}    parameters=${envdata}    stack_name=${name}
    ${resp}=    OperatingSystem.Get File    ${OPENSTACK_HEAT_ADD_STACK_TEMPLATE}
    ${request}=     Template String    ${resp}    ${dict}
    Log    $request
    [Return]    ${request}

Delete Openstack Stack
    [Documentation]    Deletes and Openstack Stack for the passed name and id
    [Arguments]    ${alias}    ${stack_name}    ${stack_id}
    ${data_path}=    Catenate    /${stack_name}/${stack_id}
    ${resp}=    Internal Delete Openstack    ${alias}    ${GLOBAL_OPENSTACK_HEAT_SERVICE_TYPE}    ${OPENSTACK_HEAT_STACK_PATH}    data_path=${data_path}
    Should Be Equal As Strings    204  ${resp.status_code}
    [Return]    ${resp}

Get Stack Details
    [Documentation]    Gets all of the information necessary for tearing down an existing Openstack Stack
    [Arguments]    ${alias}    ${stack_name}
    ${resp}=    Internal Get Openstack    ${alias}    ${GLOBAL_OPENSTACK_HEAT_SERVICE_TYPE}    ${OPENSTACK_HEAT_STACK_PATH}    /${stack_name}
    ${result}=    Stack Info Parse    ${resp.json()}
    [Return]     ${result}

Get Stack Template
    [Documentation]    Gets all of the template information of an existing Openstack Stack
    [Arguments]    ${alias}    ${stack_name}    ${stack_id}
    ${data_path}=    Catenate    /${stack_name}/${stack_id}/template
    ${resp}=    Internal Get Openstack    ${alias}    ${GLOBAL_OPENSTACK_HEAT_SERVICE_TYPE}    ${OPENSTACK_HEAT_STACK_PATH}    ${data_path}
    ${template}= 	Catenate    ${resp.json()}
    [Return]    ${template}

Get Stack Resources
    [Documentation]    Gets all of the resources of an existing Openstack Stack
    [Arguments]    ${alias}    ${stack_name}    ${stack_id}
    ${data_path}=    Catenate    /${stack_name}/${stack_id}/resources
    ${resp}=    Internal Get Openstack    ${alias}    ${GLOBAL_OPENSTACK_HEAT_SERVICE_TYPE}    ${OPENSTACK_HEAT_STACK_PATH}    ${data_path}
    [Return]    ${resp.json()}

Wait for Stack to Be Deployed
    [Arguments]    ${alias}   ${stack_name}    ${timeout}=600s
    ${stack_info}=    Wait Until Keyword Succeeds    ${timeout}    30 sec    Get Deployed Stack    ${alias}    ${stack_name}
    ${status}=   Get From Dictionary    ${stack_info}    stack_status
    Should Be Equal    ${status}    CREATE_COMPLETE
    [Return]    ${stack_info}

Get Deployed Stack
    [Arguments]    ${alias}    ${stack_name}
    ${stack_info}=    Get Stack Details    ${alias}    ${stack_name}
    ${status}=   Get From Dictionary    ${stack_info}    stack_status
    Should Not Be Equal    ${status}    CREATE_IN_PROGRESS
    [Return]    ${stack_info}
