USE portal;
/*
Any updates required by OOM to the portaldb are made here.
1. split up SDC-FE and SDC-BE.  Originally both FE and BE point to the same IP
while the OOM K8s version has these service split up.
*/
UPDATE fn_app SET app_rest_endpoint = 'http://sdc.api.be.simpledemo.onap.org:8080/api/v2' where app_name = 'SDC';
