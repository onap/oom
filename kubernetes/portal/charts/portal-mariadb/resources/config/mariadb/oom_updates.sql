USE portal;
/*
Any updates required by OOM to the portaldb are made here.
1. split up SDC-FE and SDC-BE.  Originally both FE and BE point to the same IP
while the OOM K8s version has these service split up.
*/
-- app_url is the FE, app_rest_endpoint is the BE
--portal-sdk => TODO: doesn't open a node port yet
update fn_app set app_url = 'http://{{.Values.config.portalSdkHostName}}:{{.Values.config.portalSdkPort}}/ONAPPORTALSDK/welcome.htm', app_rest_endpoint = 'http://portal-sdk:8990/ONAPPORTALSDK/api/v2' where app_name = 'xDemo App';
--dmaap-bc => the dmaap-bc doesn't open a node port..
update fn_app set app_url = 'http://{{.Values.config.dmaapBcHostName}}:{{.Values.config.dmaapBcPort}}/ECOMPDBCAPP/dbc#/dmaap', app_rest_endpoint = 'http://dmaap-bc:8989/ECOMPDBCAPP/api/v2' where app_name = 'DMaaP Bus Ctrl';
--sdc-be => 8443:30204, 8080:30205
--sdc-fe => 8181:30206, 9443:30207
update fn_app set app_url = 'http://{{.Values.config.sdcFeHostName}}:{{.Values.config.sdcFePort}}/sdc1/portal', app_rest_endpoint = 'http://sdc-be:8080/api/v2' where app_name = 'SDC';
--pap => 8443:30219
update fn_app set app_url = 'http://{{.Values.config.papHostName}}:{{.Values.config.papPort}}/onap/policy', app_rest_endpoint = 'http://pap:8443/onap/api/v2' where app_name = 'Policy';
--vid => 8080:30200
update fn_app set app_url = 'http://{{.Values.config.vidHostName}}:{{.Values.config.vidPort}}/vid/welcome.htm', app_rest_endpoint = 'http://vid:8080/vid/api/v2' where app_name = 'Virtual Infrastructure Deployment';
--sparky => TODO: sparky doesn't open a node port yet
update fn_app set app_url = 'http://{{.Values.config.aaiSparkyHostName}}:{{.Values.config.aaiSparkyPort}}/services/aai/webapp/index.html#/viewInspect', app_rest_endpoint = 'http://aai-sparky-be.{{.Release.Namespace}}:9517/api/v2' where app_name = 'A&AI UI';
--cli => 8080:30260
update fn_app set app_url = 'http://{{.Values.config.cliHostName}}:{{.Values.config.cliPort}}/', app_type = 1 where app_name = 'CLI';
--msb-discovery => 10081:30281  this is clearly incorrect
update fn_app set app_url = 'http://{{.Values.config.msbDiscoveryHostName}}:{{.Values.config.msbDiscoveryPort}}/iui/microservices/default.html' where app_name = 'MSB';