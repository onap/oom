*** Settings ***
Documentation     The main interface for interacting with ASDC. It handles low level stuff like managing the http request library and DCAE required fields
Library           OperatingSystem
Library            ArchiveLibrary
Library           Collections
Resource          ../asdc_interface.robot

Variables       ../../assets/service_mappings.py

*** Variables ***
${ASDC_BASE_PATH}    /sdc1
${ASDC_DESIGNER_PATH}    /proxy-designer1#/dashboard
${ASDC_ASSETS_DIRECTORY}    robot/assets/asdc
${VFW_DIRECTORY}    base_vfw
${VLB_DIRECTORY}    base_vlb
${VVG_DIRECTORY}    base_vvg
${SCALING_DIRECTORY}    dns_scaling
${ASDC_ZIP_DIRECTORY}    ${ASDC_ASSETS_DIRECTORY}/temp

#***************** Test Case Variables *********************
${CATALOG_RESOURCE_IDS}
${CATALOG_SERVICE_ID}

*** Keywords ***

Model Distribution For Directory
    [Arguments]    ${service}   ${catalog_service_name}=
    ${directory_list}=    Get From Dictionary    ${GLOBAL_SERVICE_FOLDER_MAPPING}    ${service}
    ${ziplist}=    Create List
    :for   ${directory}    in    @{directory_list}
    \    ${zip}=    Catenate    ${ASDC_ZIP_DIRECTORY}/${directory}.zip
    \    ${folder}=    Catenate    ${ASDC_ASSETS_DIRECTORY}/${directory}
    \    OperatingSystem.Create Directory    ${ASDC_ASSETS_DIRECTORY}/temp
    \    Create Zip From Files In Directory        ${folder}    ${zip}
    \    Append To List    ${ziplist}    ${zip}
    ${catalog_service_name}    ${catalog_resource_name}    ${vf_modules}    ${catalog_resource_ids}   ${catalog_service_id}   Distribute Model From ASDC    ${ziplist}    ${catalog_service_name}
    Set Test Variable   ${CATALOG_RESOURCE_IDS}   ${catalog_resource_ids}
    Set Test Variable   ${CATALOG_SERVICE_ID}   ${catalog_service_id}
    [Return]    ${catalog_service_name}    ${catalog_resource_name}    ${vf_modules}




Teardown Model Distribution
    [Documentation]    Clean up at the end of the test
    Log   ${CATALOG_SERVICE_ID} ${CATALOG_RESOURCE_IDS}
    Teardown Models    ${CATALOG_SERVICE_ID}   ${CATALOG_RESOURCE_IDS}

Teardown Models
    [Documentation]    Clean up at the end of the test
    [Arguments]     ${catalog_service_id}    ${catalog_resource_ids}
    Return From Keyword If    '${catalog_service_id}' == ''
    :for    ${catalog_resource_id}   in   @{catalog_resource_ids}
    \   ${resourece_json}=   Mark ASDC Catalog Resource Inactive    ${catalog_resource_id}
    ${service_json}=   Mark ASDC Catalog Service Inactive    ${catalog_service_id}
    ${services_json}=   Delete Inactive ASDC Catalog Services
    ${resources_json}=    Delete Inactive ASDC Catalog Resources
