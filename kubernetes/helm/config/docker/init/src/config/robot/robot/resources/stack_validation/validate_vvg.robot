*** Settings ***
Documentation	  Testing openstack.
Library    String
Library    DNSUtils
Library    Collections
Resource          validate_common.robot


*** Variables ***

*** Keywords ***
Validate vVG Stack
    [Documentation]    Validation of vVG stack (TBD)
    [Arguments]    ${stack_name}
    Log    All server processes up

