*** Settings ***
Documentation	  Closed Loop Test cases

Resource    ../resources/test_templates/closedloop_test_template.robot

Test Teardown    Teardown Closed Loop

*** Test Cases ***

VFW Closed Loop Test
    [TAGS]    ete    closedloop
    VFW Policy
VDNS Closed Loop Test
    [TAGS]    ete    closedloop
    VDNS Policy    