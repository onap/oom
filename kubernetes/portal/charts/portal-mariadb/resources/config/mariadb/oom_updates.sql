USE portal;
/*
Any updates required by OOM to the portaldb are made here.
1. split up SDC-FE and SDC-BE.  Originally both FE and BE point to the same IP
while the OOM K8s version has these service split up.
*/
-- app_url is the FE, app_rest_endpoint is the BE
--portal-sdk => doesnt have a node port so this won't work
update fn_app set app_url = 'http://portal-sdk.onap.org:8990/ONAPPORTALSDK/welcome.htm', app_rest_endpoint = 'http://portal-sdk:8990/ONAPPORTALSDK/api/v2' where app_name = 'xDemo App';
--dmaap-bc => the dmaap-bc chart actually opens 8080 and 8443, not 8989.  the chart isnt merged yet either. confirm the service name after bc chart merge
update fn_app set app_url = 'http://dmaap-bc.onap.org:8989/ECOMPDBCAPP/dbc#/dmaap', app_rest_endpoint = 'http://dmaap-bc:8989/ECOMPDBCAPP/api/v2' where app_name = 'DMaaP Bus Ctrl';
--sdc-be => 8443:30204, 8080:30205
--sdc-fe => 8181:30206, 9443:30207
update fn_app set app_url = 'http://sdc-fe.onap.org:30206/sdc1/portal', app_rest_endpoint = 'http://sdc-be:8080/api/v2' where app_name = 'SDC';
--pap => 8443:30219
update fn_app set app_url = 'http://pap.onap.org:30219/onap/policy', app_rest_endpoint = 'http://pap:8443/onap/api/v2' where app_name = 'Policy';
--vid => 8080:30200
update fn_app set app_url = 'http://vid.onap.org:8080/vid/welcome.htm', app_rest_endpoint = 'http://vid:8080/vid/api/v2' where app_name = 'Virtual Infrastructure Deployment';
--sparky => sparky doesn't open a node port..
update fn_app set app_url = 'http://aai-sparky-be.onap.org:30200/services/aai/webapp/index.html#/viewInspect', app_rest_endpoint = 'http://aai-sparky-be.{{.Release.Namespace}}:9517/api/v2' where app_name = 'A&AI UI';
--cli => 8080:30260
update fn_app set app_url = 'http://cli.onap.org:30260/', app_type = 1 where app_name = 'CLI';
--msb-discovery => 10081:30281  this is clearly incorrect
update fn_app set app_url = 'http://msb-discovery.onap.org:8080/iui/microservices/default.html' where app_name = 'MSB';