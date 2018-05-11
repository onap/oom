# aaf info - everything is from the private oam network (also called onap private network)
GLOBAL_AAF_SERVER = "https://aaf-service.{{include "common.namespace" .}}:8100"
GLOBAL_AAF_USERNAME = "demo@people.osaaf.org"
GLOBAL_AAF_PASSWORD = "demo123456!"

# aai info - everything is from the private oam network (also called onap private network)
GLOBAL_AAI_SERVER_PROTOCOL = "https"
GLOBAL_AAI_SERVER_PORT = "8443"
GLOBAL_AAI_USERNAME = "AAI"
GLOBAL_AAI_PASSWORD = "AAI"
# appc info - everything is from the private oam network (also called onap private network)
GLOBAL_APPC_SERVER_PROTOCOL = "http"
GLOBAL_APPC_SERVER_PORT = "8282"
GLOBAL_APPC_SERVER = "http://appc.{{include "common.namespace" .}}:"
GLOBAL_APPC_USERNAME = "admin"
GLOBAL_APPC_PASSWORD = "admin"
# sdc info - everything is from the private oam network (also called onap private network)
GLOBAL_ASDC_SERVER_PROTOCOL = "http"
GLOBAL_ASDC_FE_PORT = "8181"
GLOBAL_ASDC_BE_PORT = "8080"
GLOBAL_ASDC_BE_ONBOARD_PORT = "8081"
GLOBAL_ASDC_BE_USERNAME = "beep"
GLOBAL_ASDC_BE_PASSWORD = "boop"
# clamp info - everything is from the private oam network (also called onap private network)
GLOBAL_CLAMP_SERVER_PROTOCOL = "http"
GLOBAL_CLAMP_SERVER_PORT = "8080"
# nbi info - everything is from the private oam network (also called onap private network)
GLOBAL_NBI_SERVER_PROTOCOL = "http"
GLOBAL_NBI_SERVER_PORT = "8080"
# cli info - everything is from the private oam network (also called onap private network)
GLOBAL_CLI_SERVER_PROTOCOL = "http"
GLOBAL_CLI_SERVER_PORT = "8080"
# dcae info - everything is from the private oam network (also called onap private network)
GLOBAL_DCAE_SERVER_PROTOCOL = "http"
GLOBAL_DCAE_HEALTH_SERVER_PORT = "80"
GLOBAL_DCAE_USERNAME = "console"
GLOBAL_DCAE_PASSWORD = "ZjJkYjllMjljMTI2M2Iz"
# microservice bus info - everything is from the private oam network (also called onap private network)
GLOBAL_MSB_SERVER_PROTOCOL = "http"
GLOBAL_MSB_SERVER_PORT = "80"
# message router info - everything is from the private oam network (also called onap private network)
GLOBAL_MR_SERVER_PROTOCOL = "http"
GLOBAL_MR_SERVER_PORT = "3904"
# mso info - everything is from the private oam network (also called onap private network)
GLOBAL_MSO_SERVER_PROTOCOL = "http"
GLOBAL_MSO_SERVER_PORT = "8080"
GLOBAL_MSO_USERNAME = "InfraPortalClient"
GLOBAL_MSO_PASSWORD = "password1$"
# music info - everything is from the private oam network (also called onap private network)
GLOBAL_MUSIC_SERVER_PROTOCOL = "http"
GLOBAL_MUSIC_SERVER_PORT = "8080"
# oof
GLOBAL_OOF_SERVER_PROTOCOL = "http"
GLOBAL_OOF_HOMING_SERVER_PORT = "8091"
GLOBAL_OOF_SNIRO_SERVER_PORT = "8698"
# openstack info - info to select right info in environment
# packet generate vnf info - everything is from the private oam network (also called onap private network)
GLOBAL_PACKET_GENERATOR_PORT = "8183"
GLOBAL_PACKET_GENERATOR_USERNAME = "admin"
GLOBAL_PACKET_GENERATOR_PASSWORD = "admin"
GLOBAL_PGN_PORT = "2831"
# policy info - everything is from the private oam network (also called onap private network)
GLOBAL_POLICY_SERVER_PROTOCOL = "http"
GLOBAL_POLICY_SERVER_PORT = "8081"
GLOBAL_POLICY_HEALTHCHECK_PORT = "6969"
GLOBAL_POLICY_AUTH = "dGVzdHBkcDphbHBoYTEyMw=="
GLOBAL_POLICY_CLIENTAUTH = "cHl0aG9uOnRlc3Q="
GLOBAL_POLICY_USERNAME = "healthcheck"
GLOBAL_POLICY_PASSWORD = "zb!XztG34"
# portal info - everything is from the private oam network (also called onap private network)
GLOBAL_PORTAL_SERVER_PROTOCOL = "http"
GLOBAL_PORTAL_SERVER_PORT = "8989"
GLOBAL_PORTAL_USERNAME = "demo"
GLOBAL_PORTAL_PASSWORD = "Kp8bJ4SXszM0WXlhak3eHlcse"
# sdngc info - everything is from the private oam network (also called onap private network)
GLOBAL_SDNGC_SERVER_PROTOCOL = "http"
GLOBAL_SDNGC_REST_PORT = "8282"
GLOBAL_SDNGC_ADMIN_PORT = "8843"
GLOBAL_SDNGC_USERNAME = "admin"
GLOBAL_SDNGC_PASSWORD = "Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U"
# sms (AAF)  info
GLOBAL_SMS_SERVER_PROTOCOL = "https"
GLOBAL_SMS_SERVER_NAME = "aaf-sms.{{include "common.namespace" .}}"
GLOBAL_SMS_SERVER_PORT = "10443"
# vid info - everything is from the private oam network (also called onap private network)
GLOBAL_VID_SERVER_PROTOCOL = "http"
GLOBAL_VID_SERVER_PORT = "8080"
GLOBAL_VID_USERNAME = "demo"
GLOBAL_VID_PASSWORD = "Kp8bJ4SXszM0WX"
GLOBAL_VID_HEALTH_USERNAME = "Default"
GLOBAL_VID_HEALTH_PASSWORD = "AppPassword!1"
# vnfsdk info - everything is from the private oam network (also called onap private network)
GLOBAL_VNFSDK_SERVER_PROTOCOL = "http"
GLOBAL_VNFSDK_SERVER_PORT = "8702"
#global selenium info
GLOBAL_PROXY_WARNING_TITLE=""
GLOBAL_PROXY_WARNING_CONTINUE_XPATH=""
# dns info
GLOBAL_DNS_TRAFFIC_DURATION = "600"
# location where heat templates are loaded from
GLOBAL_HEAT_TEMPLATES_FOLDER = "/share/heat"
# Log info
GLOBAL_LOG_SERVER_PROTOCOL = "http"
GLOBAL_LOG_ELASTICSEARCH_PORT = "9200"
GLOBAL_LOG_LOGSTASH_PORT = "9600"
GLOBAL_LOG_KIBANA_PORT = "5601"
