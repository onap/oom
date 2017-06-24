*** Settings ***
Documentation	  Initializes ONAP Test Web Page and Password

Library    Collections
Library    OperatingSystem
Library    StringTemplater
Resource          ../resources/openstack/keystone_interface.robot
Resource          ../resources/openstack/nova_interface.robot


Test Timeout    1 minutes

*** Variables ***
${URLS_HTML_TEMPLATE}   robot/assets/templates/web/index.html.template


${WEB_USER}       test
${WEB_PASSWORD}

${URLS_HTML}   html/index.html
${CREDENTIALS_FILE}   /etc/lighttpd/authorization
#${CREDENTIALS_FILE}   authorization

*** Test Cases ***
Update ONAP Page
    [Tags]   UpdateWebPage
    Run Keyword If   '${WEB_PASSWORD}' == ''   Fail   "WEB Password must not be empty"
    Run Openstack Auth Request    auth
    ${server_map}=    Get Openstack Servers    auth
    ${oam_ip_map}=   Create Dictionary
    Set To Dictionary    ${oam_ip_map}   10.0.0.1=onapdns
    Set To Dictionary    ${oam_ip_map}   aai-service.onap-aai=aai
    Set To Dictionary    ${oam_ip_map}   sdnhost.onap-appc=appc
    Set To Dictionary    ${oam_ip_map}   10.0.3.1=sdc
    Set To Dictionary    ${oam_ip_map}   10.0.4.1=dcae_controller
    Set To Dictionary    ${oam_ip_map}   10.0.4.105=dcae_cdap
    Set To Dictionary    ${oam_ip_map}   10.0.4.102=dcae_coll
    Set To Dictionary    ${oam_ip_map}   mso.onap-mso=mso
    Set To Dictionary    ${oam_ip_map}   drools.onap-policy=policy
    Set To Dictionary    ${oam_ip_map}   sdnhost.onap-sdnc=sdnc
    Set To Dictionary    ${oam_ip_map}   vid-server.onap-vid=vid
    Set To Dictionary    ${oam_ip_map}   portalapps.onap-portal=portal
    Set To Dictionary    ${oam_ip_map}   robot-openecompete.onap-robot=robot
    Set To Dictionary    ${oam_ip_map}   dmaap.onap-message-router=message_router

    ${values}=   Create Dictionary
    ${keys}=    Get Dictionary Keys    ${oam_ip_map}
    :for   ${oam_ip}   in    @{keys}
    \    ${value_name}=   Get From Dictionary    ${oam_ip_map}   ${oam_ip}
    \    Set Public Ip    ${server_map}    ${oam_ip}   ${value_name}   ${values}
    Log    ${values}
    Run Keyword If   '${WEB_PASSWORD}' != ''   Create File   ${CREDENTIALS_FILE}   ${WEB_USER}:${WEB_PASSWORD}
    Create File From Template   ${URLS_HTML_TEMPLATE}   ${URLS_HTML}   ${values}

*** Keywords ***
Create File From Template
    [Arguments]    ${template}   ${file}   ${values}
    ${data}    OperatingSystem.Get File   ${template}
    ${data}=   Template String   ${data}   ${values}
    Create File     ${file}   ${data}

Set Public Ip
    [Arguments]   ${server_map}    ${oam_ip}   ${value_name}   ${values}
    ${status}   ${public_ip}=   Run Keyword And Ignore Error  Get Public Ip   ${server_map}    ${oam_ip}
    ${public_ip}=   Set Variable If   '${status}' == 'PASS'   ${public_ip}   ${oam_ip}
    Set To Dictionary   ${values}   ${value_name}   ${public_ip}

Get Public Ip
    [Arguments]   ${server_map}    ${oam_ip}
    ${servers}   Get Dictionary Values    ${server_map}
    :for   ${server}   in   @{servers}
    \    ${status}   ${public_ip}   Run Keyword And Ignore Error   Search Addresses   ${server}   ${oam_ip}
    \    Return From Keyword If   '${status}' == 'PASS'   ${public_ip}
    Fail  ${oam_ip} Server Not Found

Search Addresses
    [Arguments]   ${server}   ${oam_ip}
    ${addresses}   Get From Dictionary   ${server}   addresses
    ${public_ips}   Get From Dictionary   ${addresses}   public
    ${public_ip}=   Get V4 IP   ${public_ips}
    ${oam_ips}   Get From Dictionary   ${addresses}   ${GLOBAL_VM_PROPERTIES['network']}
    ${this_oam_ip}=   Get V4 IP   ${oam_ips}
    Return From Keyword If   '${this_oam_ip}' == '${oam_ip}'   ${public_ip}
    Fail  ${oam_ip} Server Not Found

Get V4 IP
    [Arguments]   ${ipmaps}
    :for   ${ipmap}   in   @{ipmaps}
    \    ${ip}   Get From Dictionary   ${ipmap}   addr
    \    ${version}   Get From Dictionary   ${ipmap}   version
    \    Return from Keyword if   '${version}' == '4'   ${ip}
    Fail  No Version 4 IP
