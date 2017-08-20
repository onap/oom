*** Settings ***
Documentation     This resource is filling out json string templates and returning the json back
Library 	      RequestsLibrary
Library           StringTemplater
Library           OperatingSystem
Resource          global_properties.robot

*** Keywords ***
Fill JSON Template
    [Documentation]    Runs substitution on template to return a filled in json
    [Arguments]    ${json}    ${arguments}
    ${returned_string}=    Template String    ${json}    ${arguments}
    ${returned_json}=  To Json    ${returned_string}
    [Return]    ${returned_json}

Fill JSON Template File
    [Documentation]    Runs substitution on template to return a filled in json
    [Arguments]    ${json_file}    ${arguments}
    ${json}=    OperatingSystem.Get File    ${json_file}
    ${returned_json}=  Fill JSON Template    ${json}    ${arguments}
    [Return]    ${returned_json}