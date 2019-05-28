#!/bin/sh

dr_prov_url="{{.Values.global.dmaapDrProv.name}}:{{.Values.global.dmaapDrProv.externalPort2}}"
ct_header="Content-Type:application/vnd.dmaap-dr.feed"
obo_header="X-DMAAP-DR-ON-BEHALF-OF:dradmin"
feed_payload=/opt/app/datartr/etc/dedicatedFeed.json

sleep 20

if curl -k https://${dr_prov_url}/internal/prov | awk 'BEGIN{ORS=""} {print}' | egrep "\"feeds\":\s+\[\]"; then
   curl -X POST -H ${ct_header} -H ${obo_header} --data-ascii @${feed_payload} --post301 --location-trusted -k https://${dr_prov_url};
else
   echo "NO feed creation required";
fi
